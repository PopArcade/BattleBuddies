//
//  BBAttack.m
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBAttack.h"
#import "BBDatabase.h"

@implementation BBAttack

- (instancetype)initWithName:(NSString *)name element:(BBElement)element isSpecial:(BOOL)isSpecial power:(NSNumber *)power accuracy:(NSNumber *)accuracy statusChanger:(BBStatusChanger)statusChanger statusChangerAccuracy:(NSNumber *)statusChangerAccuracy numberOfUses:(NSNumber *)numberOfUses targetsSelf:(BOOL)targetsSelf
{
    self = [super init];
    
    if (self) {
        _name = name;
        _element = element;
        _special = isSpecial;
        _power = power;
        _accuracy = accuracy;
        _statusChanger = statusChanger;
        _statusChangerAccuracy = statusChangerAccuracy;
        _numberOfUses = numberOfUses;
        _targetsSelf = targetsSelf;
    }
    
    return self;
}

+ (instancetype)attackWithName:(NSString *)name element:(BBElement)element isSpecial:(BOOL)isSpecial power:(NSNumber *)power accuracy:(NSNumber *)accuracy statusChanger:(BBStatusChanger)statusChanger statusChangerAccuracy:(NSNumber *)statusChangerAccuracy numberOfUses:(NSNumber *)numberOfUses targetsSelf:(BOOL)targetsSelf
{
    return [[[self class] alloc] initWithName:name element:element isSpecial:isSpecial power:power accuracy:accuracy statusChanger:statusChanger statusChangerAccuracy:statusChangerAccuracy numberOfUses:numberOfUses targetsSelf:targetsSelf];
}

+ (BBAttack *)attackFromDictionary:(NSDictionary *)dictionary
{
    NSString *name = dictionary[@"name"];
    BBElement element = [(NSNumber *)dictionary[@"element"] unsignedIntegerValue];
    BOOL isSpecial = [(NSNumber *)dictionary[@"special"] boolValue];
    NSNumber *power = dictionary[@"power"];
    NSNumber *accuracy = dictionary[@"accuracy"];
    BBStatusChanger statusChanger = [(NSNumber *)dictionary[@"statusChanger"] unsignedIntegerValue];
    NSNumber *statusChangerAccuracy = dictionary[@"statusChangerAccuracy"];
    NSNumber *numberOfUses = dictionary[@"pp"];
    BOOL targetsSelf = [(NSNumber *)dictionary[@"targetsSelf"] boolValue];
    
    return [BBAttack attackWithName:name element:element isSpecial:isSpecial power:power accuracy:accuracy statusChanger:statusChanger statusChangerAccuracy:statusChangerAccuracy numberOfUses:numberOfUses targetsSelf:targetsSelf];
}

+ (BBAttack *)attackNumber:(NSInteger)number forElement:(BBElement)element inLevelClass:(BBLevelClass)levelClass
{
    number %= 2;
    
    NSArray *attackSyllabus = [BBDatabase attackSyllabusArray];
    
    NSArray *syllabusForElement = attackSyllabus[element];
    NSArray *syllabusForClass = syllabusForElement[levelClass];
    NSArray *syllabusForVariation = syllabusForClass[0];
    NSString *attackName = syllabusForVariation[number];
    
    NSDictionary *allAttacksDictionary = [BBDatabase attacksDictionary];
    NSDictionary *attackDictionary = allAttacksDictionary[attackName];
    
    return [BBAttack attackFromDictionary:attackDictionary];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ATTACK - %@ : %@ type, power: %d, accuracy: %.2f", self.name, [BBDatabase stringForElement:self.element], [self.power intValue],  [self.accuracy floatValue]];
}

@end
