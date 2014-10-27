//
//  BBAttack.h
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBConstants.h"


@interface BBAttack : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readwrite) BBElement element;
@property (nonatomic, readwrite) BOOL special;
@property (nonatomic, strong) NSNumber *power;
@property (nonatomic, strong) NSNumber *accuracy;
@property (nonatomic, readwrite) BBStatusChanger statusChanger;
@property (nonatomic, strong) NSNumber *statusChangerAccuracy;
@property (nonatomic, strong) NSNumber *numberOfUses;
@property (nonatomic, readwrite) BOOL targetsSelf;

- (instancetype)initWithName:(NSString *)name element:(BBElement)element isSpecial:(BOOL)isSpecial power:(NSNumber *)power accuracy:(NSNumber *)accuracy statusChanger:(BBStatusChanger)statusChanger statusChangerAccuracy:(NSNumber *)statusChangerAccuracy numberOfUses:(NSNumber *)numberOfUses targetsSelf:(BOOL)targetsSelf;

+ (instancetype)attackWithName:(NSString *)name element:(BBElement)element isSpecial:(BOOL)isSpecial power:(NSNumber *)power accuracy:(NSNumber *)accuracy statusChanger:(BBStatusChanger)statusChanger statusChangerAccuracy:(NSNumber *)statusChangerAccuracy numberOfUses:(NSNumber *)numberOfUses targetsSelf:(BOOL)targetsSelf;

+ (BBAttack *)attackFromDictionary:(NSDictionary *)dictionary;

+ (BBAttack *)attackNumber:(NSInteger)number forElement:(BBElement)element inLevelClass:(BBLevelClass)levelClass;

@end
