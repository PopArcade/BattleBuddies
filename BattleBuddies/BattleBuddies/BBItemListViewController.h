//
//  BBItemListViewController.h
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBItemListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *itemBackPackTableView;

@end
