//
//  BBBuddyCell.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBBuddyCell.h"

@implementation BBBuddyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Views

- (UIImageView *)buddyImage
{
    if (!_buddyImage) {
        _buddyImage = [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 7, 50, 50)];
        _buddyImage.backgroundColor = [UIColor blackColor];
    }
    return _buddyImage;
}

- (UILabel *)buddyName
{
    if (!_buddyName) {
        _buddyName = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 200, 50)];
        _buddyName.backgroundColor = [UIColor redColor];
    }
    return _buddyName;
}

@end
