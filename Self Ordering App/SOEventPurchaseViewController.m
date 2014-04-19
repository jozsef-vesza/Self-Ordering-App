//
//  SOEventPurchaseViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 20/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOEventPurchaseViewController.h"
#import "SOEventManager.h"

@interface SOEventPurchaseViewController ()

@property (nonatomic,strong) SOEventManager *eventManager;

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionText;
@property (weak, nonatomic) IBOutlet UILabel *eventTicketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventPriceLabel;

@property (nonatomic) BOOL eventAlreadyPaid;

@end

@implementation SOEventPurchaseViewController

#pragma mark - View lifecycle and setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventManager = [SOEventManager sharedInstance];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL eventIsPaid = self.eventManager.selectedEvent.isPaid;
    if (eventIsPaid) self.navigationItem.rightBarButtonItem.title = @"Részletek";
    else self.navigationItem.rightBarButtonItem.title = @"Vásárlás";
}

- (void)setupViews
{
    SOEvent *currentEvent = self.eventManager.selectedEvent;
    self.eventTitleLabel.text = currentEvent.eventTitle;
    self.eventDateLabel.text = [NSString stringWithFormat:@"%@", currentEvent.eventDate];
    self.eventDescriptionText.text = currentEvent.eventDescription;
    self.eventDescriptionText.editable = NO;
    self.eventTicketsLabel.text = [NSString stringWithFormat:@"%ld db jegy", (long)currentEvent.numberOfTicketsOrdered];
    self.eventPriceLabel.text = [NSString stringWithFormat:@"%ld Ft (%ld Ft/db)", currentEvent.ticketPrice * currentEvent.numberOfTicketsOrdered, (long)currentEvent.ticketPrice];
}

#pragma mark - User interaction

- (IBAction)purchaseButtonPressed:(UIBarButtonItem *)sender
{
    BOOL eventIsPaid = self.eventManager.selectedEvent.isPaid;
    if (eventIsPaid)
    {
        [self performSegueWithIdentifier:@"ticketSegue" sender:self];
    }
    else
    {
        [self.eventManager sendOrderForEvent:self.eventManager.selectedEvent forUser:[SOSessionManager sharedInstance].activeUser onComplete:^(SOEvent *event)
        {
            self.eventManager.selectedEvent = event;
            [self performSegueWithIdentifier:@"ticketSegue" sender:self];
        }
        onError:^(NSError *error)
        {
            NSLog(@"Error: %@", error);
        }];
    }
}

@end
