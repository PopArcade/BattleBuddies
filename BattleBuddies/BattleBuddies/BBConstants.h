//
//  BBConstants.h
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, BBStatusChanger) {
    BBStatusChangerNone = 0,
    BBStatusChangerPoisoned,
    BBStatusChangerAsleep,
    BBStatusChangerConfused,
    BBStatusChangerBurned,
    BBStatusChangerParalyzed,
    BBStatusChangerFrozen,
};

typedef NS_ENUM(NSInteger, BBElement) {
    BBElementNormal = 0,
    BBElementFire,
    BBElementWater,
    BBElementGrass,
    BBElementElectric,
    BBElementFlying,
    BBElementGhost,
    BBElementPsychic,
    BBElementFighting,
    BBElementRock,
    BBElementDark,
    BBElementDragon,
    BBElementPoison,
    BBElementBug,
    BBElementSteel,
    BBElementIce,
    BBElementMax = BBElementIce,
    BBElementFirst = BBElementNormal,
};

typedef NS_ENUM(NSInteger, BBLevelClass) {
    BBLevelClassTwo = 0,
    BBLevelClassFive,
    BBLevelClassEight,
    BBLevelClassTen,
    BBLevelClassTwenty,
    BBLevelClassThirty,
    BBLevelClassFourty,
    BBLevelClassFifty,
    BBLevelClassMax = BBLevelClassFifty,
    BBLevelClassFirst = BBLevelClassTwo,
};;

NSString * NSStringForBBElement(BBElement element);
CGFloat BBElementEffectiveMultiplierForElements(BBElement attackingElement, BBElement defendingElement);
