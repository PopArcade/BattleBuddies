//
//  BBBuddySeed.m
//  BattleBuddies
//
//  Created by Marcus Smith on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBBuddySeed.h"

NSString * const BBBuddySeedEncodingKeyName = @"BBBuddySeedName";
NSString * const BBBuddySeedEncodingKeyScreenName = @"BBBuddySeedScreenName";
NSString * const BBBuddySeedEncodingKeyImageURL = @"BBBuddySeedLevel";

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

#pragma mark - hashing
- (NSUInteger)hash
{
    return [[self screenName] hash];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if ([object hash] == [self hash]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _name = [aDecoder decodeObjectForKey:BBBuddySeedEncodingKeyName];
        _screenName = [aDecoder decodeObjectForKey:BBBuddySeedEncodingKeyScreenName];
        _imageURL = [aDecoder decodeObjectForKey:BBBuddySeedEncodingKeyImageURL];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:BBBuddySeedEncodingKeyName];
    [aCoder encodeObject:self.screenName forKey:BBBuddySeedEncodingKeyScreenName];
    [aCoder encodeObject:self.imageURL forKey:BBBuddySeedEncodingKeyImageURL];
}

@end
