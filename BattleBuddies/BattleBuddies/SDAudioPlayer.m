//
//  SDAudioPlayer.m
//  SDAudioKit
//
//  Created by rpoolos1951 on 2/5/13.
//  Copyright (c) 2013 Super Duper Publications. All rights reserved.
//

#import "SDAudioPlayer.h"

@interface SDAudioPlayer ()
{
    int lastVolumeSetKey;
}
@end

@implementation SDAudioPlayer


#pragma mark - Volume Change Keys

- (int)newVolumeKey
{
    int newVolumeKey = lastVolumeSetKey;
    
    while (newVolumeKey == lastVolumeSetKey) {
        newVolumeKey = arc4random() % INT16_MAX;
    }
    
    return newVolumeKey;
}

#pragma mark - Advance Volume Control

- (void)setVolume:(float)volume
{
    [super setVolume:volume];
    
    // Generate a unique key eachtime we change the volume.
    lastVolumeSetKey = [self newVolumeKey];
}

- (void)fadeOut
{
    [self fadeOutOverTime:2.0];
}

- (void)fadeOutOverTime:(NSTimeInterval)time
{
    [self fadeToVolume:0.0 overTime:time];
}

- (void)fadeIn
{
    [self fadeInOverTime:2.0];
}

- (void)fadeInOverTime:(NSTimeInterval)time
{
    [self fadeToVolume:1.0 overTime:time];
}

- (void)fadeToVolume:(float)volume
{
    [self fadeToVolume:volume overTime:2.0];
}

#define STEPS 1
- (void)fadeToVolume:(float)volume overTime:(NSTimeInterval)time
{
    if (self.volume == volume) {
        return;
    }
    
    // Create a new volumeKey. Set it to be the lastVolumeKey.
    int originalKey = [self newVolumeKey];
    lastVolumeSetKey = originalKey;
    
    // Store the original volume. And calculate a volume difference.
    float originalVolume = self.volume;
    float volumeDifference = originalVolume - volume;

    // Figure out the number of steps. Default 10 steps.
    int steps = 10;
    
    #if STEPS == 1
    // # of steps based on time. 0.1 per step.
    steps = time / 0.1;
    #elif STEPS == 2
    // # of steps based on volume. 0.05 per step.
    steps = volumeDifference / 0.05;
    #elif STEPS == 3
    // Some magic number of steps based on volume change and time.
    // Probably has some limits such as maximum/minimum number of steps and maximum volume change per step for smoothness.
    #endif
    
    // Calculate
    NSTimeInterval timePerStep = time / (steps - 1);
    float volumePerStep = volumeDifference / (steps - 1);
    
    // Loop through and create some volume steps in blocks.
    for (int i = 0; i < steps; i++) {
        double delayInSeconds = timePerStep * i;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            // The volume has changed since this block was scheduled.
            if (originalKey != lastVolumeSetKey) {
                return ;
            }
            
            float newVolume = originalVolume - (volumePerStep * i);
            
            // We call to super because our setVolume override generates a new key.
            [super setVolume:newVolume];
        });
    }
}

// TODO: Provide a function exposing bitmask options.
//- (void)fadeToVolume:(float)volume overTime:(NSTimeInterval)time withOptions:(int)options
// Options to include the step function and timing curve.

@end
