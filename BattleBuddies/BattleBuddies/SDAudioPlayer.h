//
//  SDAudioPlayer.h
//  SDAudioKit
//
//  Created by rpoolos1951 on 2/5/13.
//  Copyright (c) 2013 Super Duper Publications. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SDAudioPlayer : AVAudioPlayer

#pragma mark - Advance Volume Control
- (void)fadeOut;
- (void)fadeOutOverTime:(NSTimeInterval)time;

- (void)fadeIn;
- (void)fadeInOverTime:(NSTimeInterval)time;

- (void)fadeToVolume:(float)volume;
- (void)fadeToVolume:(float)volume overTime:(NSTimeInterval)time;

@end
