//
//  BBBuddySeed.h
//  BattleBuddies
//
//  Created by Marcus Smith on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

// I don't know why the fuck this is called Buddy Seed.  Jacab made it up.  This is like a stub for your twitter buddies
#import <Foundation/Foundation.h>

@interface BBBuddySeed : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *imageURL;

- (instancetype)initWithName:(NSString *)name screenName:(NSString *)screenName imageURL:(NSURL *)imageURL;
+ (instancetype)buddySeedWithName:(NSString *)name screenName:(NSString *)screenName imageURL:(NSURL *)imageURL;

@end
