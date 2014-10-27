//
//  BBDatabase.h
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBDatabase : NSObject

+ (NSArray *)attributesArray;
+ (NSArray *)nameSuffixArray;
+ (NSDictionary *)attacksDictionary;
+ (NSArray *)attackSyllabusArray;
+ (NSArray *)elementArray;
+ (NSString *)stringForElement:(NSUInteger)element;

@end
