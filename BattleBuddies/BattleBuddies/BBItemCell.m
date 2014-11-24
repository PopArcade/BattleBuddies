//
//  BBItemCell.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBItemCell.h"

@implementation BBItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Views

- (UIImageView *)itemImage
{
    if (!_itemImage) {
        _itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 7, 50, 50)];
        _itemImage.backgroundColor = [UIColor blackColor];
    }
    return _itemImage;
}

- (UILabel *)itemName
{
    if (!_itemName) {
        _itemName = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 200, 50)];
        _itemName.backgroundColor = [UIColor redColor];
    }
    return _itemName;
}

@end
