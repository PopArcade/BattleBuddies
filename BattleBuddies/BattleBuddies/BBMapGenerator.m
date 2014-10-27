//
//  BBMapGenerator.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BBMapGenerator.h"



@interface NSArray (random)
- (id)randomObject;
@end
@implementation NSArray (random)
- (id)randomObject
{
    return self[arc4random() % self.count];
}
@end



NSInteger const QuadrantSize = 100;

@interface BBMapGenerator ()

@property (nonatomic, readwrite) CGSize size;

@property (nonatomic, strong) NSOperationQueue *generatorQueue;

@property (nonatomic, strong) NSMutableDictionary *cachedQuadrants;

@property (nonatomic, strong) NSArray *grasses;
@property (nonatomic, strong) NSArray *grassEdges;

@property (nonatomic, strong) NSArray *lightDirt;
@property (nonatomic, strong) NSArray *lightDirtEdges;

@property (nonatomic, strong) NSArray *darkDirt;

@property (nonatomic, strong) NSArray *tileTypes;

@end

@implementation BBMapGenerator

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.size = size;
        
        self.generatorQueue = [[NSOperationQueue alloc] init];
        self.generatorQueue.maxConcurrentOperationCount = 4;
        
        self.cachedQuadrants = [NSMutableDictionary dictionary];
        
        static dispatch_once_t grassToken;
        dispatch_once(&grassToken, ^{
            self.grasses = @[@{@"type": @"grasses", @"x": @(22), @"y": @(5)},
                             @{@"type": @"grasses", @"x": @(22), @"y": @(3)},
                             @{@"type": @"grasses", @"x": @(22), @"y": @(5)},
                             @{@"type": @"grasses", @"x": @(23), @"y": @(5)},
                             @{@"type": @"grasses", @"x": @(21), @"y": @(11)},
                             @{@"type": @"grasses", @"x": @(22), @"y": @(11)},
                             @{@"type": @"grasses", @"x": @(23), @"y": @(11)},
                        ];
        });
        
        static dispatch_once_t grassEdgesToken;
        dispatch_once(&grassEdgesToken, ^{
            self.grassEdges = @[@{@"type": @"grassEdges", @"x": @(21), @"y": @(8)},
                                @{@"type": @"grassEdges", @"x": @(22), @"y": @(8)},
                                @{@"type": @"grassEdges", @"x": @(23), @"y": @(8)},
                                @{@"type": @"grassEdges", @"x": @(21), @"y": @(9)},
                                @{@"type": @"grassEdges", @"x": @(23), @"y": @(9)},
                                @{@"type": @"grassEdges", @"x": @(21), @"y": @(10)},
                                @{@"type": @"grassEdges", @"x": @(22), @"y": @(10)},
                                @{@"type": @"grassEdges", @"x": @(23), @"y": @(10)},
                        ];
        });
        
        
        
        static dispatch_once_t lightDirtToken;
        dispatch_once(&lightDirtToken, ^{
            self.lightDirt = @[@{@"type": @"lightDirt", @"x": @(15), @"y": @(5)},
                               @{@"type": @"lightDirt", @"x": @(16), @"y": @(5)},
                               @{@"type": @"lightDirt", @"x": @(17), @"y": @(5)},
                               ];
        });
        
        static dispatch_once_t lightDirtEdgesToken;
        dispatch_once(&lightDirtEdgesToken, ^{
            self.lightDirtEdges = @[@{@"type": @"lightDirt", @"x": @(16), @"y": @(0)},
                                    @{@"type": @"lightDirt", @"x": @(16), @"y": @(4)},
                                    @{@"type": @"lightDirt", @"x": @(17), @"y": @(5)},
                                    ];
        });
        
        
        
        
        static dispatch_once_t darkDirtToken;
        dispatch_once(&darkDirtToken, ^{
            self.darkDirt = @[@{@"type": @"darkDirt", @"x": @(18), @"y": @(5)},
                              @{@"type": @"darkDirt", @"x": @(19), @"y": @(5)},
                              @{@"type": @"darkDirt", @"x": @(20), @"y": @(5)},
                          ];
        });
        
        static dispatch_once_t tilesToken;
        dispatch_once(&tilesToken, ^{
            self.tileTypes = @[self.grasses, self.lightDirt];
        });

    }
    return self;
}

- (instancetype)init
{
    return [self initWithSize:CGSizeMake(5000.0, 5000.0)];
}

#pragma mark - Loading

- (NSArray *)tileAtlasCoordinatesAtX:(int)x andY:(int)y
{
//    NSLog(@"x: %i y: %i",x,y);
    int quadrantIndex = [self quadrantForX:x andY:y];
    
    // Load the quadrant if necessary.
    NSArray *quadrant = self.cachedQuadrants[@(quadrantIndex)];
    
    if (!quadrant) {
        
        NSArray *nearByQuadrants = [self nearByQuadrants:quadrantIndex];
        
        // Clear Nearby Cache
        [self.cachedQuadrants.allKeys enumerateObjectsUsingBlock:^(NSNumber *quadrantID, NSUInteger idx, BOOL *stop) {
            if (![nearByQuadrants containsObject:quadrantID]) {
                [self.cachedQuadrants removeObjectForKey:quadrantID];
            }
        }];
        
        // Load quadrant and nearby quadrants
        for (int i = 0; i < nearByQuadrants.count; i++) {
            NSNumber *quadrantID = nearByQuadrants[i];
            
            if (![self.cachedQuadrants.allKeys containsObject:quadrantID]) {
                NSLog(@"Load Quadrant: %i",quadrantIndex);
                
                NSURL *quadrantURL = [self URLForQuadrant:quadrantIndex];
                
                NSError *readError;
                NSData *data = [NSData dataWithContentsOfURL:quadrantURL options:NSDataReadingMappedIfSafe error:&readError];
                
                if (readError) {
                    NSLog(@"Read: %@",readError);
                }
                
                NSError *jsonError;
                NSArray *quadrant = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                
                if (jsonError) {
                    NSLog(@"Read: %@",jsonError);
                }
                
                self.cachedQuadrants[quadrantID] = quadrant;
            }
        }
        
        NSLog(@"%@",self.cachedQuadrants.allKeys);
    }
    
    NSArray *loadedQuadrant = self.cachedQuadrants[@(quadrantIndex)];
    
    int normalizedX = x % QuadrantSize;
    int normalizedY = y % QuadrantSize;
    
    NSDictionary *tile = loadedQuadrant[normalizedX][normalizedY];
    CGPoint baseCoodinate = CGPointMake([tile[@"x"] integerValue], [tile[@"y"] integerValue]);;
    
    NSDictionary *overlay = tile[@"overlay"];
    
    if (overlay) {
        CGPoint overlayCoordinate = CGPointMake([overlay[@"x"] integerValue], [overlay[@"y"] integerValue]);
        return @[[NSValue valueWithCGPoint:baseCoodinate],[NSValue valueWithCGPoint:overlayCoordinate]];
    }
    
    return @[[NSValue valueWithCGPoint:baseCoodinate]];
}

#pragma mark - Generation

- (void)generateMap:(void (^)(void))completionBlock
{
    int total = [self maxQuadrants];
    
    __block int finished = 0;
    
    for (int i = 0; i < total; i++) {
        NSOperation *quadrantOp = [self generateQuadrant:i];
        
        [quadrantOp setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Quadrant %i Completed",i);
            });
            
            finished++;
            
            if (finished == total) {
                completionBlock();
            }
        }];
        
        [self.generatorQueue addOperation:quadrantOp];
    }
}

// Generates a 1000x1000 block
- (NSOperation *)generateQuadrant:(int)quadrant
{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *columns = [NSMutableArray array];
        for (int x = 0; x < QuadrantSize; x++) {
            NSMutableArray *column = [NSMutableArray array];
            for (int y = 0; y < QuadrantSize; y++) {
                
                
                NSDictionary *previousXTile;
                if (x != 0) {
                    previousXTile = columns[x - 1][y];
                }
                
                NSDictionary *previousYTile;
                if (y != 0) {
                    previousYTile = column[y - 1];
                }
                
                // 90% chance to match previous
                if (previousYTile && previousXTile && (arc4random() % 10)) {
                    NSDictionary *baseTile = previousYTile;
                    
                    // 50% split between above or beside
                    if (arc4random() % 2) {
                        baseTile = previousXTile;
                    }
                    
                    // Grab another random tile matching the type.
                    NSArray *tiles = [self valueForKey:baseTile[@"type"]];
                    NSDictionary *tile = tiles.randomObject;
                    [column addObject:tile];
                }
                // Brand new tile
                else {
                    NSArray *tileType = self.tileTypes.randomObject;
                    NSMutableDictionary *tile = [tileType.randomObject mutableCopy];
                    
                    BOOL leftTileMatches = [previousXTile[@"type"] isEqualToString:tile[@"type"]];
                    BOOL aboveTileMatches = [previousYTile[@"type"] isEqualToString:tile[@"type"]];
                    
                    if (!leftTileMatches && !aboveTileMatches) {
                        tile[@"overlay"] = self.lightDirtEdges[0];
                    }
                    else if (!aboveTileMatches) {
                        tile[@"overlay"] = self.lightDirtEdges[1];
                    }
//                    else if (aboveTileMatches) {
//                        tile[@"overlay"] = self.grassEdges[1];
//                    }
                    
                    [column addObject:tile];
                }
            }
            [columns addObject:column];
        }
        
        NSURL *quadrantURL = [self URLForQuadrant:quadrant];
        
        NSError *jsonError;
        NSData *data = [NSJSONSerialization dataWithJSONObject:columns options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON: %@",jsonError);
        }
        
        NSError *writeError;
        [data writeToURL:quadrantURL options:NSDataWritingAtomic error:&writeError];
        
        if (writeError) {
            NSLog(@"Write: %@",writeError);
        }
    }];
    
    return blockOperation;
}

#pragma mark - Convenience

- (int)maxQuadrants
{
    int width = self.size.width / QuadrantSize;
    int height = self.size.height / QuadrantSize;
    
    int total = width * height;
    
    return total;
}

- (NSURL *)URLForQuadrant:(int)quadrant
{
    NSArray *directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentDirectory = directories.firstObject;
    
    NSString *fileName = [NSString stringWithFormat:@"quadrant%i.json",quadrant];
    
    return [documentDirectory URLByAppendingPathComponent:fileName isDirectory:NO];;
}

- (int)quadrantForX:(int)x andY:(int)y
{
    int quadX = floor(x / QuadrantSize);
    int quadY = floor(y / QuadrantSize);
    
    return quadX + (quadY * (self.size.height / QuadrantSize));
}

- (NSArray *)nearByQuadrants:(int)quadrant
{
    int rowOffset = (self.size.height / QuadrantSize);
    int maxQuadrants = [self maxQuadrants];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObject:@(quadrant)];
    
    if ((quadrant - 1) >= 0) {
        [array addObject:@(quadrant - 1)];
    }
    
    if ((quadrant + 1) < maxQuadrants) {
        [array addObject:@(quadrant + 1)];
    }
    
    if ((quadrant - rowOffset) >= 0) {
        [array addObject:@(quadrant - rowOffset)];
    }
    
    if ((quadrant - rowOffset) < maxQuadrants) {
        [array addObject:@(quadrant + rowOffset)];
    }
    
    return array;
}

@end
