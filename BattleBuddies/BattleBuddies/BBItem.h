//
//  BBItem.h
//  BattleBuddies
//
//  Created by Marcus Smith on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *imageURL;

- (instancetype)initWithName:(NSString *)name imageURL:(NSURL *)imageURL;
+ (instancetype)itemWithName:(NSString *)name imageURL:(NSURL *)imageURL;

+ (instancetype)buddyBall;
+ (instancetype)potion;

@end
