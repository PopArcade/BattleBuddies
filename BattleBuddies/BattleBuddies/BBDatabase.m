//
//  BBDatabase.m
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBDatabase.h"

NSString * const BBDatabaseUserDefaultKeyBackpack = @"BBBackpack";
NSString * const BBDatabaseUserDefaultKeyCaughtBuddies = @"CaughtBBBuddies";
NSString * const BBDatabaseUserDefaultKeyAllBuddies = @"AllBBBuddies";

@implementation BBDatabase

#pragma mark - items and buddies

+ (NSArray *)itemsInBackpack
{
    NSData *itemsData = [[NSUserDefaults standardUserDefaults] objectForKey:BBDatabaseUserDefaultKeyBackpack];
    NSArray *items = itemsData ? [NSKeyedUnarchiver unarchiveObjectWithData:itemsData] : nil;
    
    return items ? items : [NSArray array];
}

+ (void)addItemToBackpack:(BBItem *)item
{
    if (item) {
        NSMutableArray *mutableBackpack = [[self itemsInBackpack] mutableCopy];
        [mutableBackpack addObject:item];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mutableBackpack.copy];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:BBDatabaseUserDefaultKeyBackpack];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)removeItemFromBackpackAtIndex:(NSUInteger)index
{
    NSMutableArray *mutableBackpack = [[self itemsInBackpack] mutableCopy];
    
    if (index >= mutableBackpack.count) {
        NSLog(@"Index out of bounds");
        return;
    }
    
    [mutableBackpack removeObjectAtIndex:index];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mutableBackpack.copy];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:BBDatabaseUserDefaultKeyBackpack];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)caughtBuddies
{
    NSData *buddiesData = [[NSUserDefaults standardUserDefaults] objectForKey:BBDatabaseUserDefaultKeyCaughtBuddies];
    NSArray *buddies = buddiesData ? [NSKeyedUnarchiver unarchiveObjectWithData:buddiesData] : nil;
    
    return buddies ? buddies : [NSArray array];
}

+ (void)addBuddyToCaughtBuddies:(BBBuddy *)buddy
{
    if (buddy) {
        NSMutableArray *mutableBuddies = [[self caughtBuddies] mutableCopy];
        [mutableBuddies addObject:buddy];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mutableBuddies.copy];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:BBDatabaseUserDefaultKeyCaughtBuddies];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSSet *)allBuddies
{
    NSData *buddiesData = [[NSUserDefaults standardUserDefaults] objectForKey:BBDatabaseUserDefaultKeyAllBuddies];
    NSArray *buddiesArray = buddiesData ? [NSKeyedUnarchiver unarchiveObjectWithData:buddiesData] : [NSArray array];
    NSSet *buddiesSet = [NSSet setWithArray:buddiesArray];
    
    return buddiesSet ? buddiesSet : [NSSet set];
}

+ (void)updateAllBuddiesWithBuddies:(NSSet *)buddySeeds
{
    NSMutableSet *allBuddies = [[self allBuddies] mutableCopy];
    
    [buddySeeds enumerateObjectsUsingBlock:^(BBBuddySeed *seed, BOOL *stop) {
        if (seed) {
            if ([allBuddies containsObject:seed]) {
                [allBuddies removeObject:seed];
            }
            [allBuddies addObject:seed];
        }
    }];
    
    NSArray *buddiesArray = [allBuddies allObjects];
    NSData *buddiesData = [NSKeyedArchiver archivedDataWithRootObject:buddiesArray];
    [[NSUserDefaults standardUserDefaults] setObject:buddiesData forKey:BBDatabaseUserDefaultKeyAllBuddies];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - data resources

+ (NSArray *)attributesArray
{
    static NSArray *attributesArray = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        attributesArray = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"BaseAttributes" withExtension:@"plist"]];
    });
    
    return attributesArray;
}

+ (NSArray *)nameSuffixArray
{
    static NSArray *namesArray = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       namesArray = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"NameSuffix" withExtension:@"plist"]];
    });
    
    return namesArray;
}

+ (NSDictionary *)attacksDictionary
{
    static NSDictionary *attacksDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        attacksDictionary = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Attacks" withExtension:@"plist"]];
    });
    
    return attacksDictionary;
}

+ (NSArray *)attackSyllabusArray
{
    static NSArray *attackSyllabus = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        attackSyllabus = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AttackSyllabus" withExtension:@"plist"]];
    });
    
    return attackSyllabus;
}

+ (NSArray *)elementArray
{
    static NSArray *elementArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        elementArray = @[@"Normal", @"Fire", @"Water", @"Grass", @"Electric", @"Flying", @"Ghost", @"Psychic", @"Fighting", @"Rock", @"Dark", @"Dragon", @"Poison", @"Bug", @"Steel", @"Ice"];
    });
    
    return elementArray;
}

+ (NSString *)stringForElement:(NSUInteger)element
{
    return [BBDatabase elementArray][element];
}

@end
