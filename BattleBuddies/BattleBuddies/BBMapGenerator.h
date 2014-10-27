//
//  BBMapGenerator.h
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBMapGenerator : NSObject

- (instancetype)initWithSize:(CGSize)size;

@property (nonatomic, readonly) CGSize size;



- (void)generateMap:(void(^)(void))completionBlock;

- (NSArray *)tileAtlasCoordinatesAtX:(int)x andY:(int)y;


@end
