//
//  BBBuddyListViewController.h
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  BBBuddyListViewController;

@protocol BBBuddyListViewControllerDelegate <NSObject>

- (void)buddyListViewController:(BBBuddyListViewController *)controller didFinishWithSelectedBuddies:(NSArray *)buddies;

@end

@interface BBBuddyListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<BBBuddyListViewControllerDelegate> delegate;
@property (strong, nonatomic) UITableView *buddyListTableView;
@property (strong, nonatomic) NSMutableArray *selectedBuddies;
@property (readwrite, nonatomic) NSUInteger maxSelections;

- (instancetype)initWithMaxNumberOfSelections:(NSUInteger)maxSelections;

@end
