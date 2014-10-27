//
//  BBMapAtlas.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBMapAtlas.h"

@implementation BBMapAtlas

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadAtlas];
    }
    return self;
}

- (void)loadAtlas
{
    NSLog(@"[BBMapAtlas] StartLoading");
    UIImage *atlas = [UIImage imageNamed:@"terrain_atlas"];
    
    NSMutableArray *tiles = [NSMutableArray array];
    
    for (int x = 0; x < 32; x++) {
        NSMutableArray *row = [NSMutableArray array];
        
        for (int y = 0; y < 32; y++) {
            CGImageRef croppedImage = CGImageCreateWithImageInRect(atlas.CGImage, CGRectMake(x * 32.0, y * 32.0, 32.0, 32.0));
            
            UIImage *tile = [UIImage imageWithCGImage:croppedImage];
            [row addObject:tile];
        }
        
        [tiles addObject:row];
    }
    
    [self setTiles:tiles.copy];
    tiles = nil;
    NSLog(@"[BBMapAtlas] FinishLoading");
}

#pragma mark - Convenience Tiles

- (UIImage *)grassATile
{
    return self.tiles[21][5];
}

- (UIImage *)grassBTile
{
    return self.tiles[22][5];
}

- (UIImage *)grassCTile
{
    return self.tiles[23][5];
}


@end
