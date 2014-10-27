//
//  BBMapCollectionViewCell.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBMapCollectionViewCell.h"

@interface BBMapCollectionViewCell ()

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation BBMapCollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageViews = [NSMutableArray array];
    }
    return self;
}

- (UIImageView *)imageViewAtIndex:(NSInteger)index
{
    if (self.imageViews.count > index) {
        return [self.imageViews objectAtIndex:index];
    }
    else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imageView];
        
        [self.imageViews addObject:imageView];
        
        return imageView;
    }
}

@end
