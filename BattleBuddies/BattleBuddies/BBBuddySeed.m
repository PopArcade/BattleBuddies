//
//  BBBuddySeed.m
//  BattleBuddies
//
//  Created by Marcus Smith on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBBuddySeed.h"

@implementation BBBuddySeed

- (instancetype)initWithName:(NSString *)name screenName:(NSString *)screenName imageURL:(NSURL *)imageURL
{
    self = [super init];
    
    if (self) {
        _name = name;
        _screenName = screenName;
        _imageURL = imageURL;
    }
    
    return self;
}

+ (instancetype)buddySeedWithName:(NSString *)name screenName:(NSString *)screenName imageURL:(NSURL *)imageURL
{
    return [[[self class] alloc] initWithName:name screenName:screenName imageURL:imageURL];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ScreenName: %@, Name: %@, EARL:%@", self.screenName, self.name, self.imageURL];
}

@end
