//
//  BBMapTouchView.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBMapTouchView.h"

@interface BBMapTouchView ()
{
    CGFloat multiplier;
    CGFloat lastUpdate;
}

@property (nonatomic, strong) NSTimer *repeatTimer;
@property (nonatomic, readwrite) CGPoint locationOfTouch;

@end

@implementation BBMapTouchView

- (void)updateTouch
{
    lastUpdate += multiplier;
    
    if (lastUpdate > 15.0) {
        lastUpdate = 0.0;
        
        multiplier *= 1.05;
        
        if ([self.delegate respondsToSelector:@selector(stillTouching:)]) {
            [self.delegate stillTouching:self];
        }
    }
}

- (void)cancelTouches
{
    [self.repeatTimer invalidate];
    self.repeatTimer = nil;
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    multiplier = 1.0;
    
    self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(updateTouch) userInfo:nil repeats:YES];
    
    UITouch *touch = touches.anyObject;
    
    self.locationOfTouch = [touch locationInView:self];
    
    if ([self.delegate respondsToSelector:@selector(didBeginTouching:)]) {
        [self.delegate didBeginTouching:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.repeatTimer invalidate];
    self.repeatTimer = nil;
    
    UITouch *touch = touches.anyObject;
    
    self.locationOfTouch = [touch locationInView:self];
    
    if ([self.delegate respondsToSelector:@selector(didEndTouching:)]) {
        [self.delegate didEndTouching:self];
    }
    
    self.locationOfTouch = CGPointZero;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    
    self.locationOfTouch = [touch locationInView:self];
}

@end
