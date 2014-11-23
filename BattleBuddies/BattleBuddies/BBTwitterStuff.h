//
//  BBTwitterStuff.h
//  BattleBuddies
//
//  Created by Marcus Smith on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBBuddySeed.h"

typedef void(^BBTwitterStuffContactsCompletion)(NSArray *buddySeeds, NSError *error);

@interface BBTwitterStuff : NSObject

+ (instancetype)sharedStuff;

- (void)followerBuddySeedsWithCompletion:(BBTwitterStuffContactsCompletion)completion;
- (void)friendBuddySeedsWithCompletion:(BBTwitterStuffContactsCompletion)completion;

@end
