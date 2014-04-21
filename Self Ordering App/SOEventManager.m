//
//  SOEventManager.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOEventManager.h"
#import "SONetworkingManager.h"
#import "NSArray+removeDuplicateOrders.h"
#import <EventKit/EventKit.h>

@interface SOEventManager ()

@property (nonatomic,strong) SONetworkingManager *networkManager;

@property (nonatomic) NSMutableArray *regularCellItems;
@property (nonatomic) NSMutableArray *promotedCellItems;
@property (nonatomic) NSMutableArray *multiCellItems;

@end

@implementation SOEventManager

#pragma mark - Singleton function and setup

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _regularCellItems = [NSMutableArray array];
        _promotedCellItems = [NSMutableArray array];
        _multiCellItems = [NSMutableArray array];
        _eventsArray = [NSArray array];
        _networkManager = [SONetworkingManager sharedInstance];
    }
    return self;
}

#pragma mark - Event loading/saving

- (void)loadItemsOnComplete:(void (^)(NSArray *items))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    [self loadEvents];
    BOOL noDownloadedEvents = [self.eventsArray count] == 0;
    if (noDownloadedEvents)
    {
        [self.networkManager downloadEventsOnComplete:^(NSArray *events)
        {
            [self clearItemsOnComplete:nil];
            [self sortArray:events];
            [self saveEvents];
            aCompletionHandler(self.eventsArray);
        }
        onError:^(NSError *error)
        {
            anErrorHandler(error);
        }];
    }
    else
    {
        aCompletionHandler(self.eventsArray);
    }
}

- (void)clearItemsOnComplete:(void (^)())aCompletionHandler
{
    [[SOSessionManager sharedInstance] deleteSavedItemsFromPath:eventsKeyPath];
    [_regularCellItems removeAllObjects];
    [_promotedCellItems removeAllObjects];
    [_multiCellItems removeAllObjects];
    if (aCompletionHandler)
    {
        aCompletionHandler();
    }
}

- (void)saveEvents
{
    [[SOSessionManager sharedInstance] saveDownloadedItems:self.eventsArray to:eventsKeyPath];
}

- (void)loadEvents
{
    self.eventsArray = [[SOSessionManager sharedInstance] loadSavedItemsFromPath:eventsKeyPath];
}

#pragma mark - User operations

- (void)addEventToCart:(SOEvent *)anEvent times:(int)aTimes forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler
{
    SOEvent *eventToBeAdded = [SOEvent eventWithEvent:anEvent];
    eventToBeAdded.numberOfTicketsOrdered = 1;
    NSMutableArray *tempCart = [anUser.eventOrders mutableCopy];
    for (int i = 0; i < aTimes; i++)
    {
        [tempCart addObject:eventToBeAdded];
    }
    anUser.eventOrders = [NSArray checkForDuplicatesForType:[SOEvent class] inArray:tempCart];
    aCompletionHandler();
}

- (void)removeEventFromCart:(SOEvent *)anEvent forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler
{
    NSMutableArray *tempCart = nil;
    if (anEvent.isPaid)
    {
        tempCart = [anUser.paidEventOrders mutableCopy];
        [self.networkManager deleteEventOrder:anEvent forUser:anUser onComplete:^()
        {
            [tempCart removeObject:anEvent];
            anUser.paidEventOrders = [tempCart copy];
            aCompletionHandler();
        }
        onError:^(NSError *error)
        {
            NSLog(@"Error while deleting object: %@", error);
        }];
    }
    else
    {
        tempCart = [anUser.eventOrders mutableCopy];
        [tempCart removeObject:anEvent];
        anUser.eventOrders = [tempCart copy];
        aCompletionHandler();
    }
    
}

- (void)sendOrderForEvent:(SOEvent *)anEvent forUser:(SOUser *)anUser onComplete:(void (^)(SOEvent *event))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    [self.networkManager sendOrderForEvent:anEvent forUser:anUser onComplete:^(SOEvent *event)
    {
        // Get the current event orders (paid/unpaid)
        NSMutableArray *unpaidArray = [anUser.eventOrders mutableCopy];
        NSMutableArray *paidArray = [anUser.paidEventOrders mutableCopy];
        
        // Remove the paid event from the unpaid array
        // Add the returned event to the paid array
        [unpaidArray removeObject:anEvent];
        [paidArray addObject:event];
        
        // Save changes
        anUser.eventOrders = [unpaidArray copy];
        anUser.paidEventOrders = [paidArray copy];
        
        aCompletionHandler(event);
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)addEventToCalendar:(SOEvent *)anEvent onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            EKEvent *newEvent = [EKEvent eventWithEventStore:store];
            newEvent.title = anEvent.eventTitle;
            newEvent.allDay = NO;
            newEvent.startDate = anEvent.eventDate;
            newEvent.endDate = [anEvent.eventDate dateByAddingTimeInterval:anEvent.eventDuration * 60];
            newEvent.location = anEvent.location.name;
            newEvent.calendar = [store defaultCalendarForNewEvents];
            
            NSError *saveError;
            [store saveEvent:newEvent span:EKSpanThisEvent error:&saveError];
            if (saveError == noErr) aCompletionHandler();
            else anErrorHandler(saveError);
        }
    }];
}

#pragma mark - Event utilities

- (void)loadQRImageForCurrentEventOnComplete:(void (^)(UIImage *image))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    NSString *path = [NSString stringWithFormat:@"%@", self.selectedEvent.identifier];
    UIImage *image = [[[SOSessionManager sharedInstance] loadSavedItemsFromPath:path] lastObject];
    BOOL eventImageCached = image != nil;
    if (eventImageCached)
    {
        aCompletionHandler(image);
    }
    else
    {
        [self.networkManager downloadQRCodeForEvent:self.selectedEvent andUser:[SOSessionManager sharedInstance].activeUser onComplete:^(UIImage *image)
        {
            aCompletionHandler(image);
            if (image)
            {
                [[SOSessionManager sharedInstance] saveDownloadedItems:@[image] to:path];
            }
            
        }
        onError:^(NSError *error)
        {
            anErrorHandler(error);
        }];
    }
    
}

- (void)sortArray:(NSArray *)anArray
{
    NSMutableArray *allEvents = [[NSMutableArray alloc] init];
    NSMutableArray *tempMultiCellArray = [[NSMutableArray alloc] init];
    for (SOEvent *event in anArray)
    {
        switch (event.priority)
        {
            case 1:
                if (self.promotedCellItems.count < 1)
                {
                    [self.promotedCellItems addObject:event];
                }
                else
                {
                    [self.regularCellItems addObject:event];
                }
                break;
            case 2:
                if (tempMultiCellArray.count < 2)
                {
                    [tempMultiCellArray addObject:event];
                }
                else
                {
                    [self.regularCellItems addObject:event];
                }
                break;
            default:
                [self.regularCellItems addObject:event];
                break;
        }
    }
    
    for (int i = 0; i < tempMultiCellArray.count; i += 2)
    {
        NSArray *eventPair = [NSArray arrayWithObjects:tempMultiCellArray[i], tempMultiCellArray[i+1], nil];
        [self.multiCellItems addObject:eventPair];
    }
    
    [allEvents addObjectsFromArray:self.promotedCellItems];
    [allEvents addObjectsFromArray:self.multiCellItems];
    [allEvents addObjectsFromArray:self.regularCellItems];
    
    self.eventsArray = allEvents;
    
}

- (void)dealloc
{
    NSLog(@"%@ dealloc'd", [self class]);
}

@end
