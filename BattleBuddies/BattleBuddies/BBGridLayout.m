//
//  BBGridLayout.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBGridLayout.h"

@interface BBGridLayout ()

@property (nonatomic, readwrite) NSInteger rows;
@property (nonatomic, readwrite) NSInteger columns;

@property (nonatomic, readwrite) CGSize itemSize;

@property (nonatomic, strong) NSArray *attributes;

@end

@implementation BBGridLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setItemSize:CGSizeMake(32.0, 32.0)];
    }
    return self;
}

- (void)prepareLayout
{
    self.columns = [self.collectionView numberOfSections];
    self.rows = [self.collectionView numberOfItemsInSection:0];
    
//    NSLog(@"Begin Layout");
//    self.attributes = [self layoutAttributesForColumns:self.columns rows:self.rows startingX:0 startY:0];
//    NSLog(@"Finish Layout");
}

#pragma mark - attributes

- (UICollectionViewLayoutAttributes *)layoutAttributesForX:(NSInteger)x andY:(NSInteger)y
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:x inSection:y]];
    
    [attribute setFrame:CGRectMake(x * self.itemSize.width, y * self.itemSize.height, self.itemSize.width, self.itemSize.height)];
    
    return attribute;
}

- (NSArray *)layoutAttributesForColumns:(NSInteger)columns rows:(NSInteger)rows startingX:(NSInteger)indexX startY:(NSInteger)indexY
{
//    NSLog(@"columns: %li rows: %li indexX: %li indexY: %li",(long)columns,(long)rows,(long)indexX,(long)indexY);
    NSMutableArray *attributes = [NSMutableArray array];
    for (int x = (int)indexX; x < (indexX + columns); x++) {
        for (int y = (int)indexY; y < (indexY + rows); y++) {
            
            if (x < self.columns && y < self.rows) {
                [attributes addObject:[self layoutAttributesForX:x andY:y]];
            }
            
        }
    }
    
    return attributes;
}

#pragma mark - Subclass

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger indexX = MAX(0, (int)rect.origin.x / (int)self.itemSize.width);
    NSInteger indexY = MAX(0, (int)rect.origin.y / (int)self.itemSize.height);
    
    NSInteger numberOfColumnsInRect = CGRectGetWidth(rect) / self.itemSize.width;
    NSInteger numberOfRowsInRect = CGRectGetHeight(rect) / self.itemSize.height;
    
    return [self layoutAttributesForColumns:numberOfColumnsInRect rows:numberOfRowsInRect startingX:indexX startY:indexY];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self layoutAttributesForX:indexPath.section andY:indexPath.row];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.itemSize.width * self.columns, self.itemSize.height * self.rows);
}

@end
