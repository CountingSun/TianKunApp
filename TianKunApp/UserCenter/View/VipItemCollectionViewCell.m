//
//  VipItemCollectionViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "VipItemCollectionViewCell.h"

@implementation VipItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_button setTitleColor:COLOR_TEXT_LIGHT forState:0];
    [_button setImagePosition:QMUIButtonImagePositionTop];
    [_button setSpacingBetweenImageAndTitle:5];
    _button.enabled = YES;
}

@end
