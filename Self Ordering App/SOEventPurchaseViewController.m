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
    self.eventAlreadyPaid = self.eventManager.selectedEvent.isPaid;
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.eventAlreadyPaid) self.navigationItem.rightBarButtonItem.title = @"Részletek";
    else self.navigationItem.rightBarButtonItem.title = @"Vásárlás";
}

- (void)setupViews
{
    SOEvent *currentEvent = self.eventManager.selectedEvent;
    self.eventTitleLabel.text = currentEvent.eventTitle;
    self.eventDateLabel.text = [NSString stringWithFormat:@"%@", currentEvent.eventDate];
    self.eventDescriptionText.text = currentEvent.eventDescription;
    self.eventDescriptionText.editable = NO;
    self.eventTicketsLabel.text = [NSString stringWithFormat:@"%d db jegy", currentEvent.numberOfTicketsOrdered];
    self.eventPriceLabel.text = [NSString stringWithFormat:@"%d Ft (%d Ft/db)", currentEvent.ticketPrice * currentEvent.numberOfTicketsOrdered, currentEvent.ticketPrice];
}

#pragma mark - User interaction

- (IBAction)purchaseButtonPressed:(UIBarButtonItem *)sender
{
    if (self.eventAlreadyPaid)
    {
        [self performSegueWithIdentifier:@"ticketSegue" sender:self];
    }
    else
    {
        [self.eventManager sendOrderForEvent:self.eventManager.selectedEvent forUser:[SOSessionManager sharedInstance].activeUser onComplete:^(SOEvent *event)
        {
            NSLog(@"%hhd", event.isPaid);
            [self performSegueWithIdentifier:@"ticketSegue" sender:self];
        }
        onError:^(NSError *error)
        {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.eventAlreadyPaid)
    {
        
    }
    else
    {
        
    }
}

@end
