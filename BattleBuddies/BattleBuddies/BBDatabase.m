//
//  BBDatabase.m
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBDatabase.h"
#import "BBItem.h"

@implementation BBDatabase

#pragma mark - items and buddies

//TODO: Actually implement this....
+ (NSArray *)itemsInBackpack
{
    return @[[BBItem buddyBall], [BBItem potion], [BBItem potion]];
}

+ (NSArray *)caughtBuddies
{
    return nil;
}

+ (NSArray *)allBuddies
{
    return nil;
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
