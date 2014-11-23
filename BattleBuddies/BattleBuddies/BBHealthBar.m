//
//  BBHealthBar.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBHealthBar.h"

@interface BBHealthBar ()
{
    UIColor *_backgroundColor;
}
@end

@implementation BBHealthBar

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [self drawBar];
    
    CGContextRestoreGState(context);
    context = nil;
}

- (void)drawBar
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.backgroundColor setFill];
    
    CGContextFillRect(context, CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds) * self.health, CGRectGetHeight(self.bounds)));
}

#pragma mark - Background Color

- (UIColor *)backgroundColor
{
    return _backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    
    _backgroundColor = backgroundColor;
}

@end
