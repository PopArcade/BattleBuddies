//
//  BBBuddy.m
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBBuddy.h"
#import <CommonCrypto/CommonDigest.h>
#import "BBDatabase.h"

NSString * const kBBAttackKey = @"attack";
NSString * const kBBSpAttackKey = @"spAttack";
NSString * const kBBDefenseKey = @"defense";
NSString * const kBBSpDefenseKey = @"spDefense";
NSString * const kBBHealthKey = @"health";
NSString * const kBBSpeedKey = @"speed";
NSString * const kBBAgilityKey = @"agility";

NSInteger const kFirstEvolution = 15;
NSInteger const kSecondEvolution = 35;

@interface BBBuddy ()

@property (nonatomic, strong) NSString *uniqueIdentifier;

@property (nonatomic, strong, readwrite) NSArray *names;
@property (nonatomic, strong, readwrite) NSURL *bodyImage;

@property (nonatomic, strong, readwrite) NSURL *faceImage;

@property (nonatomic, readwrite) BBElement element;

@property (nonatomic, readwrite) NSUInteger evolutionLevel;
//@property (nonatomic, readwrite) NSUInteger level;
@property (nonatomic, readwrite) NSUInteger experience;
@property (nonatomic, readonly) NSUInteger neededExperienceForLevel;

@property (nonatomic, strong, readwrite) NSNumber *baseAttack;
@property (nonatomic, strong, readwrite) NSNumber *baseSpAttack;
@property (nonatomic, strong, readwrite) NSNumber *baseDefense;
@property (nonatomic, strong, readwrite) NSNumber *baseSpDefense;
@property (nonatomic, strong, readwrite) NSNumber *baseMaxHealth;
@property (nonatomic, strong, readwrite) NSNumber *baseSpeed;
@property (nonatomic, strong, readwrite) NSNumber *baseAgility;

@property (nonatomic, readwrite) BBStatusChanger status;
@property (nonatomic, readwrite) NSNumber *health;

@property (nonatomic, strong) NSArray *learnableAttacks;
@property (nonatomic, strong) NSArray *currentAttacks;

@property (nonatomic, readwrite) NSUInteger attack1pp;
@property (nonatomic, readwrite) NSUInteger attack2pp;
@property (nonatomic, readwrite) NSUInteger attack3pp;
@property (nonatomic, readwrite) NSUInteger attack4pp;

@end

@implementation BBBuddy

- (instancetype)initFromUniqueIdentifier:(NSString *)uniqueIdentifier name:(NSString *)name imageURL:(NSURL *)imageURL level:(NSUInteger)level
{
    self = [super init];
    
    if (self) {
        NSString *md5 = [self MD5forString:uniqueIdentifier];
        
        [self setUpBaseStatsWithUniqueIdentifier:md5];
        
        _uniqueIdentifier = md5;
        
        NSArray *names = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSUInteger mod = names.count;
        
        NSArray *nameSuffixArray = [BBDatabase nameSuffixArray];
        
        NSMutableArray *mutableNamesArray = [NSMutableArray array];
        
        for (uint i = 0; i < 3; i++) {
            NSString *baseName = names[i % mod];
            NSString *suffix = nameSuffixArray[[self NSUIntegerForCharacterAtPosition:(8 + i) ofHexString:md5]];
            
            [mutableNamesArray addObject:[NSString stringWithFormat:@"%@%@", baseName, suffix]];
        }
        
        _names = mutableNamesArray.copy;
        
        _level = level;
        _evolutionLevel = (level < kFirstEvolution ? 0 : (level < kSecondEvolution ? 1 : 2));
        _experience = 0;
        
        _status = BBStatusChangerNone;
        _health = _baseMaxHealth;
        
        _faceImage = imageURL;
    }
    
    return self;
}

+ (instancetype)buddyFromUniqueIdentifier:(NSString *)uniqueIdentifier name:(NSString *)name imageURL:(NSURL *)imageURL level:(NSUInteger)level
{
    return [[[self class] alloc] initFromUniqueIdentifier:uniqueIdentifier name:name imageURL:imageURL level:level];
}

+ (instancetype)buddyFromBuddySeed:(BBBuddySeed *)buddySeed atLevel:(NSUInteger)level
{
    return [[[self class] alloc] initFromUniqueIdentifier:buddySeed.screenName name:buddySeed.name imageURL:buddySeed.imageURL level:level];
}

- (void)setUpBaseStatsWithUniqueIdentifier:(NSString *)uniqueIdentifier
{
    _element = (BBElement)[self NSUIntegerForCharacterAtPosition:0 ofHexString:uniqueIdentifier];
    _baseAttack = @([self baseStat:kBBAttackKey fromElement:_element andCharacterAtPosition:1 ofHexString:uniqueIdentifier]);
    _baseSpAttack = @([self baseStat:kBBSpAttackKey fromElement:_element andCharacterAtPosition:2 ofHexString:uniqueIdentifier]);
    _baseDefense = @([self baseStat:kBBDefenseKey fromElement:_element andCharacterAtPosition:3 ofHexString:uniqueIdentifier]);
    _baseSpDefense = @([self baseStat:kBBSpDefenseKey fromElement:_element andCharacterAtPosition:4 ofHexString:uniqueIdentifier]);
    _baseMaxHealth = @([self baseStat:kBBHealthKey fromElement:_element andCharacterAtPosition:5 ofHexString:uniqueIdentifier]);
    _baseSpeed = @([self baseStat:kBBSpeedKey fromElement:_element andCharacterAtPosition:6 ofHexString:uniqueIdentifier]);
    _baseAgility = @([self baseStat:kBBAgilityKey fromElement:_element andCharacterAtPosition:7 ofHexString:uniqueIdentifier]);
    
    NSMutableArray *mutableAttackArray = [NSMutableArray array];
    
    for (NSUInteger i = BBLevelClassFirst; i <= BBLevelClassMax; i++) {
        NSInteger variation = [self NSUIntegerForCharacterAtPosition:(10 + (uint)i) ofHexString:uniqueIdentifier] > 7 ? 1 : 0;
        
        BBAttack *attack = [BBAttack attackNumber:variation forElement:_element inLevelClass:i];
        
        [mutableAttackArray addObject:attack];
    }
    
    _learnableAttacks = mutableAttackArray.copy;
}

#pragma upgrading

- (NSString *)giveExp:(NSUInteger)exp
{
    self.experience += exp;
    
    if (self.experience < self.neededExperienceForLevel) {
        return [NSString stringWithFormat:@"%@ gained %lu experience points", self.name, exp];
    }
    
    // Level Up!
    NSString *nameBeforeLeveling = self.name;
    
    while (self.experience > self.neededExperienceForLevel) {
        self.experience -= self.neededExperienceForLevel;
        self.level ++;
    }
    
    NSString *messageString = [NSString stringWithFormat:@"%@ advanced to level %lu", nameBeforeLeveling, self.level];
    
    NSArray *newMoveLevels = @[@2, @5, @8, @10, @20, @30, @40, @50];
    NSNumber *levelNumber = @(self.level);
    
    if ([newMoveLevels containsObject:levelNumber]) {
        NSUInteger index = [newMoveLevels indexOfObject:levelNumber];
        
        BBAttack *newAttack = self.learnableAttacks[index];
        
        self.attack1pp = self.attack2pp;
        self.attack2pp = self.attack3pp;
        self.attack3pp = self.attack4pp;
        self.attack4pp = [[newAttack numberOfUses] integerValue];
        
        messageString = [NSString stringWithFormat:@"%@\n%@ learned %@!", messageString, nameBeforeLeveling, newAttack.name];
    }
    
    NSUInteger correctEvolutionLevel = (self.level < kFirstEvolution ? 0 : (self.level < kSecondEvolution ? 1 : 2));
    
    if (self.evolutionLevel != correctEvolutionLevel) {
        messageString = [NSString stringWithFormat:@"%@\n%@ evolved into %@!!", messageString, self.names[self.evolutionLevel], self.names[correctEvolutionLevel]];
        self.evolutionLevel = correctEvolutionLevel;
    }
    
    return messageString;
}
- (NSUInteger)neededExperienceForLevel
{
    return (self.level * 10);
}

#pragma mark - Attacks

- (NSArray *)currentAttacks
{
    NSArray *moveLearningLevels = @[@2, @5, @8, @10, @20, @30, @40, @50];
    
    uint count = 0;
    
    for (NSNumber *level in moveLearningLevels) {
        if (self.level >= [level unsignedIntegerValue]) {
            count ++;
        }
    }
    
    NSMutableArray *mutableAttacks = [NSMutableArray array];
    
    if (count < 1) {
        return nil;
    }
    
    for (int i = (int)count; i >= 1; i--) {
        if (mutableAttacks.count < 4) {
            BBAttack *attack = self.learnableAttacks[i-1];
            [mutableAttacks addObject:attack];
        }
    }
    
    return [[mutableAttacks reverseObjectEnumerator] allObjects];
}

- (BBAttack *)attack1
{
    if (self.currentAttacks.count < 1) {
        return nil;
    }
    
    return self.currentAttacks[0];
}

- (BBAttack *)attack2
{
    if (self.currentAttacks.count < 2) {
        return nil;
    }
    
    return self.currentAttacks[1];
}

- (BBAttack *)attack3
{
    if (self.currentAttacks.count < 3) {
        return nil;
    }
    
    return self.currentAttacks[2];
}

- (BBAttack *)attack4
{
    if (self.currentAttacks.count < 4) {
        return nil;
    }
    
    return self.currentAttacks[3];
}

#pragma mark - properties

- (NSNumber *)attack
{
    return @([self.baseAttack floatValue] * self.level);
}

- (NSNumber *)spAttack
{
    return @([self.baseSpAttack floatValue] * self.level);
}

- (NSNumber *)defense
{
    return @([self.baseDefense floatValue] * self.level);
}

- (NSNumber *)spDefense
{
    return @([self.baseSpDefense floatValue] * self.level);
}

- (NSNumber *)maxHealth
{
    return @([self.baseMaxHealth floatValue] * self.level * 5);
}

- (NSNumber *)speed
{
    return @([self.baseSpeed floatValue] * self.level);
}

- (NSNumber *)agility
{
    return @([self.baseAgility floatValue] * self.level);
}

- (NSString *)name
{
    return self.names[self.evolutionLevel];
}

- (NSUInteger)givesExp
{
    NSUInteger sum = [self.attack unsignedIntegerValue] + [self.spAttack unsignedIntegerValue] + [self.defense unsignedIntegerValue] + [self.spDefense unsignedIntegerValue] + [self.maxHealth unsignedIntegerValue] + [self.speed unsignedIntegerValue] + [self.agility unsignedIntegerValue];
    
    NSUInteger avg = sum / 11;
    
    return avg;
}

- (NSURL *)bodyImage
{
    if (!_bodyImage) {
        _bodyImage = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%li-%li",self.element,self.evolutionLevel] withExtension:@"png"];
    }
    
    return _bodyImage;
}

#pragma mark - Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"BUDDY: %@ Element type: %@ Level: %lu\nSTATS:\nAttack    : %d \nSp.Attack: %d \nDefense   : %d \nSp.Defense: %d \nMax Health: %d \nSpeed     : %d \nAgility   : %d \nATTACKS:\n%@", self.name, [BBDatabase stringForElement:self.element], self.level, [self.attack intValue], [self.spAttack intValue], [self.defense intValue], [self.spDefense intValue], [self.maxHealth intValue], [self.speed intValue], [self.agility intValue], self.currentAttacks];
}

#pragma mark - Hashing

- (NSString *)MD5forString:(NSString *)string
{
    const char *cstr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

#pragma mark - Stat conversions from Hex

- (NSUInteger)NSUIntegerForCharacterAtPosition:(uint)position ofHexString:(NSString *)hexString
{
    NSString *characterString = [hexString substringWithRange:NSMakeRange(position, 1)];
    
    return [self NSUIntegerForHexString:characterString];
}

- (NSUInteger)NSUIntegerForHexString:(NSString *)string
{
    NSScanner *scanner=[NSScanner scannerWithString:string];
    uint temp;
    [scanner scanHexInt:&temp];
    
    return (NSUInteger)temp;
}

- (CGFloat)baseStat:(NSString *)stat fromElement:(BBElement)element andCharacterAtPosition:(uint)position ofHexString:(NSString *)hexString
{
    NSUInteger hexValue = [self NSUIntegerForCharacterAtPosition:position ofHexString:hexString];
    
    NSInteger newValue = (NSInteger)hexValue - 7;
    
    newValue = (NSInteger)roundf(newValue / 3.0);
    
    CGFloat variance = newValue / 10.0;
    
    NSDictionary *attributesDict = [BBDatabase attributesArray][element];
    
    CGFloat baseAttr = [(NSNumber *)attributesDict[stat] floatValue];
    
    return baseAttr + variance;
}



@end
