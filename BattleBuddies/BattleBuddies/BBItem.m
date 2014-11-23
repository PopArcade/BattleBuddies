//
//  BBItem.m
//  BattleBuddies
//
//  Created by Marcus Smith on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBItem.h"

NSString * const BuddyItemKeyName = @"item";
NSString * const BuddyItemKeyImageURL = @"imageURL";

@implementation BBItem

- (instancetype)initWithName:(NSString *)name imageURL:(NSURL *)imageURL
{
    self = [super init];
    
    if (self) {
        _name = name;
        _imageURL = imageURL;
    }
    
    return self;
}

+ (instancetype)itemWithName:(NSString *)name imageURL:(NSURL *)imageURL
{
    return [[[self class] alloc] initWithName:name imageURL:imageURL];
}

#pragma mark - preset items

+ (instancetype)buddyBall
{
    NSURL *imageURL = [[NSBundle mainBundle] URLForResource:@"buddyBall" withExtension:@"png"];
    
    return [self itemWithName:@"Buddy Ball" imageURL:imageURL];
}

+ (instancetype)potion
{
    NSURL *imageURL = [[NSBundle mainBundle] URLForResource:@"potion" withExtension:@"png"];
    
    return [self itemWithName:@"Potion" imageURL:imageURL];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _name = [aDecoder decodeObjectForKey:BuddyItemKeyName];
        _imageURL = [aDecoder decodeObjectForKey:BuddyItemKeyImageURL];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:BuddyItemKeyName];
    [aCoder encodeObject:self.imageURL forKey:BuddyItemKeyImageURL];
}

@end
