//
//  BBTriangleView.h
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BBTriangleCorner) {
    BBTriangleCornerBottomLeft,
    BBTriangleCornerTopLeft,
    BBTriangleCornerTopRight,
    BBTriangleCornerBottomRight,
};

@interface BBTriangleView : UIView

@property (nonatomic, readwrite) BBTriangleCorner startingCorner;

@end
