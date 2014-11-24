//
//  BBBattleViewController.h
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBuddy.h"
#import "BBBuddyListViewController.h"

@interface BBBattleViewController : UIViewController <BBBuddyListViewControllerDelegate>

@property (nonatomic, strong) BBBuddy *opponent;
@property (nonatomic, strong) NSArray *buddies;

@end
