//
//  ConstructionSearchSelectTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ConstructionSearchSelectTableViewCell.h"

@implementation ConstructionSearchSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_firsetButton setImagePosition:QMUIButtonImagePositionRight];
    [_firsetButton setSpacingBetweenImageAndTitle:5];
    [_firsetButton setImage:[UIImage imageNamed:@"三角下"] forState:UIControlStateNormal];
    [_firsetButton setImage:[UIImage imageNamed:@"三角上"] forState:UIControlStateSelected];
    _firsetButton.layer.masksToBounds = YES;
    _firsetButton.layer.cornerRadius = 2;
    _firsetButton.layer.borderWidth = 1;
    _firsetButton.layer.borderColor = COLOR_VIEW_SEGMENTATION.CGColor;
    
    [_secondButton setImagePosition:QMUIButtonImagePositionRight];
    [_secondButton setSpacingBetweenImageAndTitle:5];
    [_secondButton setImage:[UIImage imageNamed:@"三角下"] forState:UIControlStateNormal];
    [_secondButton setImage:[UIImage imageNamed:@"三角上"] forState:UIControlStateSelected];
    _secondButton.layer.masksToBounds = YES;
    _secondButton.layer.cornerRadius = 2;
    _secondButton.layer.borderWidth = 1;
    _secondButton.layer.borderColor = COLOR_VIEW_SEGMENTATION.CGColor;

    [_thirdButton setImagePosition:QMUIButtonImagePositionRight];
    [_thirdButton setSpacingBetweenImageAndTitle:5];
    [_thirdButton setImage:[UIImage imageNamed:@"三角下"] forState:UIControlStateNormal];
    [_thirdButton setImage:[UIImage imageNamed:@"三角上"] forState:UIControlStateSelected];
    _thirdButton.layer.masksToBounds = YES;
    _thirdButton.layer.cornerRadius = 2;
    _thirdButton.layer.borderWidth = 1;
    _thirdButton.layer.borderColor = COLOR_VIEW_SEGMENTATION.CGColor;

    [_fourButton setImagePosition:QMUIButtonImagePositionRight];
    [_fourButton setSpacingBetweenImageAndTitle:5];
    [_fourButton setImage:[UIImage imageNamed:@"三角下"] forState:UIControlStateNormal];
    [_fourButton setImage:[UIImage imageNamed:@"三角上"] forState:UIControlStateSelected];
    _fourButton.layer.masksToBounds = YES;
    _fourButton.layer.cornerRadius = 2;
    _fourButton.layer.borderWidth = 1;
    _fourButton.layer.borderColor = COLOR_VIEW_SEGMENTATION.CGColor;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
