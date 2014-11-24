//
//  BBBuddyListViewController.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBBuddyListViewController.h"
#import "BBDatabase.h"
#import "BBBuddyCell.h"
#import "BBBuddy.h"

@interface BBBuddyListViewController ()

@property (nonatomic, strong) NSArray *caughtBuddies;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@end

@implementation BBBuddyListViewController

- (instancetype)initWithMaxNumberOfSelections:(NSUInteger)maxSelections
{
    self = [super init];
    
    if (self) {
        _maxSelections = maxSelections;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancel:)];

    [self setTitle:[NSString stringWithFormat:@"Pick your Battle Budd%@!!", self.maxSelections > 1 ? @"ies" : @"y"]];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];

    [self.navigationItem setLeftBarButtonItem:self.doneButton];
//    self.doneButton.enabled = NO;


    
    
    [self.view addSubview:self.buddyListTableView];
    
    NSArray *buddySeeds = [[BBDatabase allBuddies] allObjects];
    
    NSMutableArray *mutableBuddies = [NSMutableArray array];
    
    [buddySeeds enumerateObjectsUsingBlock:^(BBBuddySeed *seed, NSUInteger idx, BOOL *stop) {
        if (seed) {
            [mutableBuddies addObject:[BBBuddy buddyFromBuddySeed:seed atLevel:10]];
        }
    }];
    
    self.caughtBuddies = mutableBuddies.copy;
    
    self.selectedBuddies = [[NSMutableArray alloc] initWithCapacity:self.maxSelections];

}

#pragma mark Navigation

- (void)done:(id)sender
{
    [self.delegate buddyListViewController:self didFinishWithSelectedBuddies:self.selectedBuddies.copy];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Views

- (UITableView *)buddyListTableView
{
    if (!_buddyListTableView) {
        _buddyListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
        [_buddyListTableView setDataSource:self];
        [_buddyListTableView setDelegate:self];
    
    }
    return _buddyListTableView;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [[BBDatabase allBuddies] count];
    return [self.caughtBuddies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBBuddyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[BBBuddyCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
//    BBBuddy *buddy = [[BBDatabase caughtBuddies] objectAtIndex:indexPath.row];
    BBBuddy *buddy = [self.caughtBuddies objectAtIndex:indexPath.row];
    
    cell.buddyName.text = buddy.name;
    cell.buddyImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:buddy.faceImage]];
    
//    [cell.contentView addSubview:cell.buddyImage];
    [cell.contentView addSubview:cell.buddyName];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
//    BBBuddy *buddy = [[BBDatabase caughtBuddies] objectAtIndex:indexPath.row];
//    BBBuddy *buddy = [self.caughtBuddies objectAtIndex:indexPath.row];
//    BBBuddyCell *thisCell = [self.buddyListTableView cellForRowAtIndexPath:indexPath];
    BBBuddyCell *thisCell = (BBBuddyCell *) [tableView cellForRowAtIndexPath:indexPath];

    

    if (thisCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [self.selectedBuddies removeObject:thisCell.buddyName.text];
    }
    
    if ([self.selectedBuddies count] < self.maxSelections)
    {
        if (thisCell.accessoryType == UITableViewCellAccessoryNone)
        {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedBuddies addObject:thisCell.buddyName.text];
        }
        else
        {
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    NSLog(@"%@",self.selectedBuddies);
    NSLog(@"%lu",(unsigned long)[self.selectedBuddies count]);
    
//    if ([self.selectedBuddies count] > 5) {self.doneButton.enabled = YES;}
//    if ([self.selectedBuddies count] < 6) {self.doneButton.enabled = NO;}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
