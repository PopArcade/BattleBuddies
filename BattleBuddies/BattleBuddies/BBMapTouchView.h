//
//  BBMapTouchView.h
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBMapTouchView;

@protocol BBMapTouchDelegate <NSObject>

- (void)didBeginTouching:(BBMapTouchView *)view;
- (void)stillTouching:(BBMapTouchView *)view;
- (void)didEndTouching:(BBMapTouchView *)view;

@end

@interface BBMapTouchView : UIView

@property (nonatomic, weak) id <BBMapTouchDelegate> delegate;

@property (nonatomic, readonly) CGPoint locationOfTouch;

@end
