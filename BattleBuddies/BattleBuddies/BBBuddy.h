//
//  BBBuddy.h
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBConstants.h"
#import "BBBody.h"
#import "BBAttack.h"
#import "BBBuddySeed.h"

@class BBBuddy;
typedef void(^BBAttackCompletion)(BBAttack *attack, BBBuddy *attackingBuddy, BBBuddy *targetBuddy, BOOL hitSuccess, BOOL statusChangerSuccess, CGFloat elementEffectiveness);

@interface BBBuddy : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSURL *faceImage;
@property (nonatomic, strong, readonly) NSString *bodyImageBack;
@property (nonatomic, strong, readonly) NSString *bodyImageFront;

@property (nonatomic, readonly) BBElement element;

@property (nonatomic, readonly) NSUInteger evolutionLevel;
@property (nonatomic, readwrite) NSUInteger level;
@property (nonatomic, readonly) NSUInteger experience;
@property (nonatomic, readonly) NSUInteger givesExp;

@property (nonatomic, strong, readonly) NSNumber *attack;
@property (nonatomic, strong, readonly) NSNumber *spAttack;
@property (nonatomic, strong, readonly) NSNumber *defense;
@property (nonatomic, strong, readonly) NSNumber *spDefense;
@property (nonatomic, strong, readonly) NSNumber *maxHealth;
@property (nonatomic, strong, readonly) NSNumber *speed;
@property (nonatomic, strong, readonly) NSNumber *agility;

@property (nonatomic, readonly) BBStatusChanger status;
@property (nonatomic, readonly) NSNumber *health;

@property (nonatomic, strong, readonly) BBAttack *attack1;
@property (nonatomic, strong, readonly) BBAttack *attack2;
@property (nonatomic, strong, readonly) BBAttack *attack3;
@property (nonatomic, strong, readonly) BBAttack *attack4;

@property (nonatomic, readwrite) NSUInteger attack1pp;
@property (nonatomic, readwrite) NSUInteger attack2pp;
@property (nonatomic, readwrite) NSUInteger attack3pp;
@property (nonatomic, readwrite) NSUInteger attack4pp;

- (instancetype)initFromUniqueIdentifier:(NSString *)uniqueIdentifier name:(NSString *)name imageURL:(NSURL *)imageURL level:(NSUInteger)level;

+ (instancetype)buddyFromUniqueIdentifier:(NSString *)uniqueIdentifier name:(NSString *)name imageURL:(NSURL *)imageURL level:(NSUInteger)level;
+ (instancetype)buddyFromBuddySeed:(BBBuddySeed *)buddySeed atLevel:(NSUInteger)level;

/// Returns a message string if the Buddy levels up for learns a new move
- (NSString *)giveExp:(NSUInteger)exp;

- (void)performAttack:(BBAttack *)attack onBuddy:(BBBuddy *)enemyBuddy withCompletion:(BBAttackCompletion)completion;

- (void)takeDamage:(NSInteger)damage;
- (void)heal:(NSInteger)healAmount;

@end
