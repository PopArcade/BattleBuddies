//
//  BBConstants.m
//  BattleBuddies
//
//  Created by Marcus Smith on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBConstants.h"
#import "BBDatabase.h"

NSString * NSStringForBBElement(BBElement element)
{
    return [BBDatabase elementArray][element];
}

CGFloat BBElementEffectiveMultiplierForElements(BBElement attackingElement, BBElement defendingElement)
{
    NSArray *attackArray = [BBDatabase elementEffectivenessArray][attackingElement];
    NSNumber *effectiveness = attackArray[defendingElement];
    
    return [effectiveness floatValue];
}