//
//  SDSoundManager.m
//  SDLibrary
//
//  Created by rpoolos1951 on 9/7/12.
//  Copyright (c) 2012 Super Duper Publications. All rights reserved.
//

#import "SDSoundManager.h"

#define CLS_LOG(...) NSLog(__VA_ARGS__);

@interface SDSoundManager () <AVAudioPlayerDelegate>
{
    SDAudioPlayer *audioPlayer;
    
    NSMutableArray *audioPlayers;
    NSMutableDictionary *audioPlayerBlocks;
    
    NSMutableArray *soundEffectPlayers;
}

@end

@implementation SDSoundManager

static SDSoundManager *sharedManager = nil;

+ (SDSoundManager *)sharedManager
{
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[SDSoundManager alloc] init];
        }
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [super allocWithZone:zone];
            return sharedManager;
        }
    }
    return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        // Inits
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    CLS_LOG(@"Sound Manager: Did Receive Memory Warning");
    
    for (__strong SDAudioPlayer *effect in soundEffectPlayers) {
        if (!effect.isPlaying) {
            CLS_LOG(@"Released Effect: %@",effect.url.lastPathComponent);
            effect = nil;
        }
    }
    
    if (!audioPlayer.isPlaying) {
        CLS_LOG(@"Released Main Audio Player");
        audioPlayer = nil;
    }
}

#pragma mark - Super Functions

- (void)stopAllAudio
{
    // Stop the main player
    [audioPlayer stop];
    
    // Stop all sound effects
    for (SDAudioPlayer *effect in soundEffectPlayers) {
        [effect stop];
    }
}

- (void)stopMainAudio
{
    // Stop the main player
    [audioPlayer stop];
}

- (void)pauseMainAudio
{
    // Pause the main player
    [audioPlayer pause];
}

- (void)resumeMainAudio
{
    // Stop the main player
    [audioPlayer play];
}

#pragma mark - Basic Audio Playing

- (void)playAudioNamed:(NSString *)sound
{
    [self playAudioNamed:sound atVolume:1.0];
}

- (void)playAudioNamed:(NSString *)sound atVolume:(float)volume
{
    // Get the extension
    NSString *extension = [self getExtensionForSound:sound];
    
    // Clean the filename.
    NSString *trimmedSound = [sound stringByDeletingPathExtension];
    
    // Reset the audioPlayer
    audioPlayer.numberOfLoops = 0;
    
    CLS_LOG(@"Try to Play Audio Named: %@.%@",trimmedSound,extension);
    
    
    [self playAudioAtURL:[[NSBundle mainBundle] URLForResource:trimmedSound withExtension:extension] atVolume:volume];
    
//    // Check if Audio Player is already playing & if the Audio Player is playing the same thing we want to play.
//    if (audioPlayer.isPlaying && [trimmedSound isEqualToString:[audioPlayer.url.lastPathComponent stringByDeletingPathExtension]]) {
//        // Stop playing if its the same sound.
//        [audioPlayer stop];
//        
//        CLS_LOG(@"Already Playing, Stop Audio Named: %@.%@",trimmedSound,extension);
//        
//        return;
//    }
//    
//    if ([self checkIfSoundExists:[NSString stringWithFormat:@"%@.%@",trimmedSound,extension]]) {
//        
//        NSError *error;
//        audioPlayer = [[SDAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:trimmedSound withExtension:extension] error:&error];
//        [audioPlayer setDelegate:self];
//        [audioPlayer setVolume:volume];
//        [audioPlayer play];
//        
//        if (error) {
//            CLS_LOG(@"Failed to Play Audio Named: %@.%@",trimmedSound,extension);
//            CLS_LOG(@"Error: %@",[error localizedDescription]);
//        } else {
//            CLS_LOG(@"Play Audio Named: %@.%@",trimmedSound,extension);
//        }
//        
//    } else {
//        //audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"aiff"]] error:NULL];
//        //[audioPlayer setDelegate:self];
//        //[audioPlayer play];
//    
//        CLS_LOG(@"Didn't Find Audio Named: %@.%@",trimmedSound,extension);
//        
//        // Grab the completion block
//        SDSoundCompletionBlock block = [audioPlayerBlocks objectForKey:sound];
//        
//        // If we have a completion block fire it with a false finished.
//        if (block) {
//            block(NO);
//            [audioPlayerBlocks removeObjectForKey:sound];
//        }
//    }
}

- (void)playAudioData:(NSData *)sound
{
    [self playAudioData:sound atVolume:1.0];
}

- (void)playAudioData:(NSData *)sound atVolume:(float)volume
{
    // Check if audio is playing & if audio playing is the same as what we want to play
    if (audioPlayer.isPlaying && [audioPlayer.data isEqualToData:sound]) {
        // Stop playing if its the same. otherwise start the new sound.
        [audioPlayer stop];
        return;
    }
    
    // Make sure the sound exists
    if (sound) {
        audioPlayer = [[SDAudioPlayer alloc] initWithData:sound error:nil];
        [audioPlayer setVolume:volume];
        [audioPlayer play];
    }
}

- (void)stopAudioNamed:(NSString *)sound
{
    // Get the extension
    NSString *extension = [self getExtensionForSound:sound];
    
    // Clean the filename.
    sound = [sound stringByDeletingPathExtension];
    
    CLS_LOG(@"Try to Stop Audio Named: %@.%@",sound,extension);
    
    // Check if Audio Player is already playing & if the Audio Player is playing the same thing we want to play.
    if (audioPlayer.isPlaying && [sound isEqualToString:[audioPlayer.url.lastPathComponent stringByDeletingPathExtension]]) {
        // Stop playing if its the same sound.
        [audioPlayer stop];
        
        CLS_LOG(@"Already Playing, Stop Audio Named: %@.%@",sound,extension);
        
        return;
    }
}

- (void)stopAudioData:(NSData *)sound
{
    // Check if audio is playing & if audio playing is the same as what we want to play
    if (audioPlayer.isPlaying && [audioPlayer.data isEqualToData:sound]) {
        // Stop playing if its the same. otherwise start the new sound.
        [audioPlayer stop];
        return;
    }
}

#pragma mark - Advanced Audio Playing

- (SDAudioPlayer *)loopAudioNamed:(NSString *)sound atVolume:(float)volume
{
    CLS_LOG(@"SDAudioManager: Start Loop");
    [self playAudioNamed:sound atVolume:volume];
    
    audioPlayer.numberOfLoops = -1;
    
    return (SDAudioPlayer *)audioPlayer;
}

- (void)playAudioNamed:(NSString *)sound withCompletion:(SDSoundCompletionBlock)completionBlock
{
    [self playAudioNamed:sound atVolume:1.0 withCompletion:completionBlock];
}

- (void)playAudioNamed:(NSString *)sound atVolume:(float)volume withCompletion:(SDSoundCompletionBlock)completionBlock
{
    if (!audioPlayerBlocks) {
        audioPlayerBlocks = [NSMutableDictionary dictionary];
    }
    
    [audioPlayerBlocks setObject:completionBlock forKey:sound];
    
    [self playAudioNamed:sound atVolume:volume];
}

- (void)queueAudioNamed:(NSString *)firstSound, ...
{
    NSMutableArray *sounds = [NSMutableArray array];
        
    va_list soundList;
    va_start(soundList, firstSound);
    for (NSString *arg = firstSound; arg != nil; arg = va_arg(soundList, NSString*))
    {
        [sounds addObject:arg];
    }
    va_end(soundList);
    
    NSTimeInterval delay = 0.0;
    
    for (NSString *sound in sounds) {
        [self performSelector:@selector(playAudioNamed:) withObject:sound afterDelay:delay];
        
        delay += [self lengthOfAudioNamed:sound];
    }
}

#pragma mark - Sound Information

- (NSString *)getExtensionForSound:(NSString *)sound
{
    // Try to get the extension from the string.
    NSString *extension = [sound pathExtension];
    
    // If no extension found we need to find it.
    if (extension.length == 0) {
        if ([[NSBundle mainBundle] URLForResource:sound withExtension:@"m4a"]) {
            extension = @"m4a";
        } else if ([[NSBundle mainBundle] URLForResource:sound withExtension:@"mp3"]) {
            extension = @"mp3";
        } else if ([[NSBundle mainBundle] URLForResource:sound withExtension:@"wav"]) {
            extension = @"wav";
        }  else {
            return NULL;
        }
    }
    
    return extension;
}

- (BOOL)checkIfSoundExists:(NSString *)sound
{
    // Get the extension
    NSString *extension = [self getExtensionForSound:sound];
    
    // Clean the filename.
    sound = [sound stringByDeletingPathExtension];
    
    return ([[NSBundle mainBundle] URLForResource:sound withExtension:extension] ? YES : NO);
}

- (NSTimeInterval)lengthOfAudioAtURL:(NSURL *)url
{
    AVAudioPlayer *durationPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    return durationPlayer.duration;
}

- (NSTimeInterval)lengthOfAudioNamed:(NSString *)sound
{
    NSString *extension = [self getExtensionForSound:sound];
    
    AVAudioPlayer *durationPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:sound withExtension:extension] error:nil];
    
    return durationPlayer.duration;
}

- (NSTimeInterval)lengthOfAudioData:(NSData *)sound
{
    AVAudioPlayer *durationPlayer = [[AVAudioPlayer alloc] initWithData:sound error:nil];
    
    return durationPlayer.duration;
}

#pragma mark - Sound Effects

- (void)preloadSoundEffectName:(NSString *)effect
{
    CLS_LOG(@"Try to Preload Effect Named: %@",effect);

    // Create a reference player.
    SDAudioPlayer *effectPlayer = NULL;
    
    // Loop through existing players.
    for (SDAudioPlayer *soundEffectPlayer in soundEffectPlayers) {
        // Check each player to see if its connected to our effect.
        if ([effect isEqualToString:[soundEffectPlayer.url.lastPathComponent stringByDeletingPathExtension]]) {
            CLS_LOG(@"Effect already loaded.");
        }
    }
    
    // If we didn't find a player we need to make one.
    if (!effectPlayer) {
        NSError *error = NULL;
        
        // If resource for effect exists create a new player. If it doesn't return with log.
        if ([[NSBundle mainBundle] URLForResource:effect withExtension:@"mp3"]) {
            effectPlayer = [[SDAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:effect withExtension:@"mp3"] error:&error];
            
            if (!soundEffectPlayers) {
                soundEffectPlayers = [NSMutableArray array];
            }
            
            [soundEffectPlayers addObject:effectPlayer];
            
            CLS_LOG(@"Created New Player For Effect: %@",effect);
            
        } else {
            CLS_LOG(@"Didn't Find Effect Named: %@",effect);
            return;
        }
    }
    
    // Set the volume based on settings
    [effectPlayer setVolume:[[NSUserDefaults standardUserDefaults] floatForKey:@"soundEffectsVolume"]];
    
    // We found or created an effect player. We can finally play our effect.
    [effectPlayer prepareToPlay];
    
    CLS_LOG(@"Preloaded Effect Named: %@",effect);
}

- (void)playSoundEffectNamed:(NSString *)effect
{
    CLS_LOG(@"Try to Play Effect Named: %@",effect);
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"soundEffects"]) {
        CLS_LOG(@"Sound Effects Turned Off");
        return;
    }
    
    [self playSoundEffectNamed:effect atVolume:[[NSUserDefaults standardUserDefaults] floatForKey:@"soundEffectsVolume"]];
}

- (void)forcePlaySoundEffectNamed:(NSString *)effect
{
    [self playSoundEffectNamed:effect atVolume:1.0];
}

- (void)playSoundEffectNamed:(NSString *)effect atVolume:(float)volume
{
    // Create a reference player.
    SDAudioPlayer *effectPlayer = NULL;
    
    // We need an immuatable copy to loop through to avoid mutating the original during enumeration.
    NSArray *soundEffectPlayersCopy = [NSArray arrayWithArray:soundEffectPlayers];
    
    // Loop through existing players.
    for (SDAudioPlayer *soundEffectPlayer in soundEffectPlayersCopy) {
        // Check each player to see if its connected to our effect.
        if ([effect isEqualToString:[soundEffectPlayer.url.lastPathComponent stringByDeletingPathExtension]]) {
            // Check to see if player is playing.
            if (!soundEffectPlayer.isPlaying) {
                // The effect was idle so we can reuse the player. Break on success;
                effectPlayer = soundEffectPlayer;
                
                CLS_LOG(@"Reused Player For Effect: %@",effect);
                
                break;
            }
        }
    }
    
    // Don't need our copy anymore.
    soundEffectPlayersCopy = nil;
    
    // If we didn't find a player we need to make one.
    if (!effectPlayer) {
        NSError *error = NULL;
        
        // If resource for effect exists create a new player. If it doesn't return with log.
        if ([[NSBundle mainBundle] URLForResource:effect withExtension:@"mp3"]) {
            effectPlayer = [[SDAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:effect withExtension:@"mp3"] error:&error];
            
            if (!soundEffectPlayers) {
                soundEffectPlayers = [NSMutableArray array];
            }
            
            [soundEffectPlayers addObject:effectPlayer];
            
            CLS_LOG(@"Created New Player For Effect: %@",effect);
            
        } else {
            CLS_LOG(@"Didn't Find Effect Named: %@",effect);
            return;
        }
    }
    
    // Set the volume based on settings
    [effectPlayer setVolume:volume];
    
    // We found or created an effect player. We can finally play our effect.
    [effectPlayer play];
    
    CLS_LOG(@"Played Effect Named: %@",effect);
}

#pragma mark - AVAudioPlayer Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    CLS_LOG(@"Finished Playing (%@): %@",(flag ? @"Success" : @"Fail"),player.url.lastPathComponent);
    
    SDSoundCompletionBlock block = [audioPlayerBlocks objectForKey:[player.url.lastPathComponent stringByDeletingPathExtension]];
    
    if (block) {
        block(flag);
        [audioPlayerBlocks removeObjectForKey:[player.url.lastPathComponent stringByDeletingPathExtension]];
    }
    
}

#pragma mark - URL Playing

- (void)playAudioAtURL:(NSURL *)url
{
    [self playAudioAtURL:url atVolume:1.0];
}

- (void)playAudioAtURL:(NSURL *)url atVolume:(float)volume
{
    // Reset the audioPlayer
    audioPlayer.numberOfLoops = 0;
    
    CLS_LOG(@"Try to Play Audio At URL: %@",url);
    
    // Check if Audio Player is already playing & if the Audio Player is playing the same thing we want to play.
    if (audioPlayer.isPlaying && [url isEqual:audioPlayer.url]) {
        // Stop playing if its the same sound.
        [audioPlayer stop];
        
        CLS_LOG(@"Already Playing, Stop Audio At URL: %@",url);
        
        return;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        
        NSError *error;
        audioPlayer = [[SDAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer setDelegate:self];
        [audioPlayer setVolume:volume];
        [audioPlayer play];
        
        if (error) {
            CLS_LOG(@"Failed to Play At URL: %@",url);
            CLS_LOG(@"Error: %@",[error localizedDescription]);
        } else {
            CLS_LOG(@"Play Audio At URL: %@",url);
        }
        
    } else {
        CLS_LOG(@"Didn't Find Audio At URL: %@",url);
        
        // Grab the completion block
        SDSoundCompletionBlock block = [audioPlayerBlocks objectForKey:url.absoluteString];
        
        // If we have a completion block fire it with a false finished.
        if (block) {
            block(NO);
            [audioPlayerBlocks removeObjectForKey:url.absoluteString];
        }
    }
}

- (void)stopAudioAtURL:(NSURL *)url
{
    CLS_LOG(@"Try to Stop Audio At URL: %@",url);
    
    // Check if Audio Player is already playing & if the Audio Player is playing the same thing we want to play.
    if (audioPlayer.isPlaying && [url isEqual:audioPlayer.url]) {
        // Stop playing if its the same sound.
        [audioPlayer stop];
        
        CLS_LOG(@"Already Playing, Stop Audio At URL: %@",url);
        
        return;
    }
}

- (void)playAudioAtURL:(NSURL *)url withCompletion:(SDSoundCompletionBlock)completionBlock
{
    [self playAudioAtURL:url atVolume:1.0 withCompletion:completionBlock];
}

- (void)playAudioAtURL:(NSURL *)url atVolume:(float)volume withCompletion:(SDSoundCompletionBlock)completionBlock
{
    if (!url) {
        CLS_LOG(@"Can't Play NULL URL");
        
        if (completionBlock) {
            completionBlock(NO);
        }
        
        return;
    }
    
    if (!audioPlayerBlocks) {
        audioPlayerBlocks = [NSMutableDictionary dictionary];
    }
    
    [audioPlayerBlocks setObject:completionBlock forKey:[url.lastPathComponent stringByDeletingPathExtension]];
    
    [self playAudioAtURL:url atVolume:volume];
}


@end
