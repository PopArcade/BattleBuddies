//
//  SDSoundManager.h
//  SDLibrary
//
//  Created by rpoolos1951 on 9/7/12.
//  Copyright (c) 2012 Super Duper Publications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "SDAudioPlayer.h"

typedef void(^SDSoundCompletionBlock)(BOOL finished);

@interface SDSoundManager : NSObject

+ (SDSoundManager *)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)init;

#pragma mark - Super Functions
- (void)stopAllAudio;

- (void)stopMainAudio;
- (void)pauseMainAudio;
- (void)resumeMainAudio;

#pragma mark - Basic Audio Playing
- (void)playAudioAtURL:(NSURL *)url;
- (void)playAudioNamed:(NSString *)sound;
- (void)playAudioData:(NSData *)sound;

- (void)playAudioAtURL:(NSURL *)url atVolume:(float)volume;
- (void)playAudioNamed:(NSString *)sound atVolume:(float)volume;
- (void)playAudioData:(NSData *)sound atVolume:(float)volume;

- (void)stopAudioAtURL:(NSURL *)url;
- (void)stopAudioNamed:(NSString *)sound;
- (void)stopAudioData:(NSData *)sound;

//- (void)pauseAudioNamed:(NSString *)sound;
//- (void)pauseAudioData:(NSData *)sound;

#pragma mark - Advanced Audio Playing
- (SDAudioPlayer *)loopAudioNamed:(NSString *)sound atVolume:(float)volume;

- (void)playAudioNamed:(NSString *)sound withCompletion:(SDSoundCompletionBlock)completionBlock;
- (void)playAudioNamed:(NSString *)sound atVolume:(float)volume withCompletion:(SDSoundCompletionBlock)completionBlock;

- (void)playAudioAtURL:(NSURL *)url withCompletion:(SDSoundCompletionBlock)completionBlock;
- (void)playAudioAtURL:(NSURL *)url atVolume:(float)volume withCompletion:(SDSoundCompletionBlock)completionBlock;

//- (void)queueAudioNamed:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Sound Information
- (BOOL)checkIfSoundExists:(NSString *)sound;
- (NSString *)getExtensionForSound:(NSString *)sound;
- (NSTimeInterval)lengthOfAudioAtURL:(NSURL *)url;
- (NSTimeInterval)lengthOfAudioNamed:(NSString *)sound;
- (NSTimeInterval)lengthOfAudioData:(NSData *)sound;

#pragma mark - Sound Effects
- (void)preloadSoundEffectName:(NSString *)effect;
- (void)playSoundEffectNamed:(NSString *)effect;
- (void)playSoundEffectNamed:(NSString *)effect atVolume:(float)volume;
- (void)forcePlaySoundEffectNamed:(NSString *)effect;

@end
