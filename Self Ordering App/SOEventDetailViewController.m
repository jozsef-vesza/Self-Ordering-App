//
//  SOEventDetailViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 04/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOEventDetailViewController.h"
#import "SOEventManager.h"

@interface SOEventDetailViewController () <UIAlertViewDelegate>

@property (nonatomic,strong) SOEventManager *eventManager;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *ticketCountField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIStepper *ticketCountStepper;
@property (weak, nonatomic) IBOutlet UIButton *tablePickerButton;


@end

@implementation SOEventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventManager = [SOEventManager sharedInstance];
    [self setupView];
    [self checkForTickets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hud removeFromSuperview];
}

- (void)setupView
{
    self.titleLabel.text = self.eventManager.selectedEvent.eventTitle;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", self.eventManager.selectedEvent.eventDate];
    self.descriptionLabel.text = self.eventManager.selectedEvent.eventDescription;
    self.descriptionLabel.editable = NO;
    self.ticketCountField.userInteractionEnabled = NO;
    self.ticketCountStepper.value = 0;
    self.ticketCountStepper.minimumValue = 0;
    self.ticketCountStepper.maximumValue = self.eventManager.selectedEvent.ticketsLeft;
    self.ticketCountStepper.wraps = NO;
    self.ticketCountStepper.autorepeat = YES;
    self.ticketCountStepper.continuous = YES;
    self.priceLabel.text = [NSString stringWithFormat:@"%ld Ft", (long)self.eventManager.selectedEvent.ticketPrice];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)checkForTickets
{
    BOOL noTicketsLeft = self.eventManager.selectedEvent.ticketsLeft == 0;
    if (noTicketsLeft)
    {
        UIAlertView *noTixAlert = [[UIAlertView alloc] initWithTitle:@"Nincs több jegy" message:@"A műsorra elfogytak a jegyek" delegate:self cancelButtonTitle:@"Vissza" otherButtonTitles: nil];
        [noTixAlert show];
    }
}

#pragma mark - User interactions

- (IBAction)ticketCountChanged:(UIStepper *)sender
{
    self.ticketCountField.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    self.priceLabel.text = [NSString stringWithFormat:@"%ld Ft", self.eventManager.selectedEvent.ticketPrice * (int)sender.value];
    BOOL atLeastOneTicketSelected = sender.value > 0;
    if (atLeastOneTicketSelected) self.navigationItem.rightBarButtonItem.enabled = YES;
    else self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (IBAction)orderButtonPressed:(UIBarButtonItem *)sender
{
    SOEvent *eventToAdd = [self.eventManager selectedEvent];
    
    __weak SOEventDetailViewController *weakSelf = self;
    
    [self.eventManager addEventToCart:eventToAdd times:self.ticketCountStepper.value forUser:[SOSessionManager sharedInstance].activeUser onComplete:^
    {
        SOEventDetailViewController *strongSelf = weakSelf;
        eventToAdd.ticketsLeft -= eventToAdd.numberOfTicketsOrdered;
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            strongSelf.hud.mode = MBProgressHUDModeCustomView;
            strongSelf.hud.labelText = @"Sikeres mentés!";
            [strongSelf.hud show:YES];
            [strongSelf.hud hide:YES afterDelay:1.0];
        });
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)tablePickerButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"tablePickerSeque" sender:self];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
