//
//  SOTablePickerController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 03/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOTablePickerController.h"
#import "SOEventManager.h"
#import "SOTable.h"
#import "SOLocation.h"
#import "SOCircleView.h"

@interface SOTablePickerController ()

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (nonatomic,copy) NSArray *tables;
@property (nonatomic,strong) SOLocation *location;
@property (nonatomic,strong) UILabel *detailsLabel;
@property (nonatomic,strong) SOTable *selectedTable;

@end

@implementation SOTablePickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.location = [SOEventManager sharedInstance].selectedEvent.location;
    [self visualizeLocation];
    [self registerForTouches];
    
}

- (void)visualizeLocation
{
    NSMutableArray *tables = [NSMutableArray array];
    for (SOTable *table in self.location.tables)
    {
        SOCircleView *circleView = [[SOCircleView alloc] initWithFrame:CGRectMake(table.xPoint, table.yPoint, 50, 50)];
        circleView.layer.cornerRadius = 25;
        if (table.free) circleView.backgroundColor = [UIColor yellowColor];
        else circleView.backgroundColor = [UIColor grayColor];
        [tables addObject:circleView];
    }
    
    self.tables = tables;
    
    for (SOCircleView *circle in self.tables)
    {
        [self.mapImageView addSubview:circle];
    }
    
    UIView *stageView = [[UIView alloc] initWithFrame:CGRectMake(self.location.stageCenterX - self.location.stageWidth/2, self.location.stageCenterY, self.location.stageWidth, self.location.stageHeight)];
    stageView.backgroundColor = [UIColor brownColor];
    [self.mapImageView addSubview:stageView];
    
    self.detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    self.detailsLabel.backgroundColor = [UIColor greenColor];
}

- (void)registerForTouches
{
    self.mapImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    imageTapRecognizer.numberOfTapsRequired = 1;
    [self.mapImageView addGestureRecognizer:imageTapRecognizer];
}

- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    CGPoint tapPoint = [sender locationInView:self.mapImageView];
    for (SOCircleView *table in self.tables)
    {
        if ([table pointInside:tapPoint withEvent:nil])
        {
            SOTable *tappedTable = self.location.tables[[self.tables indexOfObject:table]];
            self.detailsLabel.text = [NSString stringWithFormat:@"Asztal %d fő részére: %@", tappedTable.numberOfSeats, tappedTable.free ? @"Szabad" : @"Foglalt"];
            self.selectedTable = tappedTable;
            self.detailsLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.detailsLabel];
            break;
        }
        else
        {
            self.selectedTable = nil;
            [self.detailsLabel removeFromSuperview];
            NSLog(@"tap x: %.2f\tx: %.2f", tapPoint.x, tapPoint.y);
        }
    }
    
}


- (IBAction)confirmButtonPressed:(UIBarButtonItem *)sender
{
    //TODO: update ticket with desk information
    [SOEventManager sharedInstance].selectedEvent.selectedTable = self.selectedTable;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
