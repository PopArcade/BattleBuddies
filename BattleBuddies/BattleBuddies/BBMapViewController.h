//
//  BBMapViewController.h
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBMapGenerator.h"
#import "BBBuddyListViewController.h"

@interface BBMapViewController : UIViewController <BBBuddyListViewControllerDelegate>

@property (nonatomic, strong) BBMapGenerator *generator;

@end
