//
//  BBDatabase.h
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBBuddy.h"
#import "BBItem.h"

@interface BBDatabase : NSObject

+ (NSArray *)itemsInBackpack;
+ (void)addItemToBackpack:(BBItem *)item;
+ (void)removeItemFromBackpackAtIndex:(NSUInteger)index;

/// Returns an array of Caught Buddies
+ (NSArray *)caughtBuddies;
+ (void)addBuddyToCaughtBuddies:(BBBuddy *)buddy;

/// Returns a Set of BuddySeeds
+ (NSSet *)allBuddies;
+ (void)updateAllBuddiesWithBuddies:(NSSet *)buddySeeds;

+ (NSArray *)attributesArray;
+ (NSArray *)nameSuffixArray;
+ (NSDictionary *)attacksDictionary;
+ (NSArray *)attackSyllabusArray;
+ (NSArray *)elementArray;
+ (NSArray *)elementEffectivenessArray;
+ (NSString *)stringForElement:(NSUInteger)element;

@end
