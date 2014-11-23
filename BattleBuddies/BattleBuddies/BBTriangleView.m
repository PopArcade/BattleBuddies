//
//  BBTriangleView.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBTriangleView.h"

@interface BBTriangleView ()
{
    UIColor *_backgroundColor;
}
@end

@implementation BBTriangleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setStartingCorner:(BBTriangleCorner)corner
{
    _startingCorner = corner;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [self drawTriangle];
    
    CGContextRestoreGState(context);
    context = nil;
}

- (void)drawTriangle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGPoint bottomLeft = CGPointZero;
    CGPoint topLeft = CGPointMake(0.0, height);
    CGPoint topRight = CGPointMake(width, height);
    CGPoint bottomRight = CGPointMake(width, 0.0);
    
    CGPoint corners[4];
    corners[BBTriangleCornerBottomLeft] = bottomLeft;
    corners[BBTriangleCornerTopLeft] = topLeft;
    corners[BBTriangleCornerTopRight] = topRight;
    corners[BBTriangleCornerBottomRight] = bottomRight;
    
    // Generate a triangle path.
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:corners[self.startingCorner]];
    [bezierPath addLineToPoint:corners[(self.startingCorner + 1) % 4]];
    [bezierPath addLineToPoint:corners[(self.startingCorner + 2) % 4]];
    [bezierPath closePath];
    
    CGContextAddPath(context, bezierPath.CGPath);
    
    [self.backgroundColor setFill];
    CGContextFillPath(context);
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
