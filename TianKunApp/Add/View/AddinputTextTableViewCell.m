//
//  AddinputTextTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/30.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddinputTextTableViewCell.h"

@implementation AddinputTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.textColor = COLOR_THEME;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
