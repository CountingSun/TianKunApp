//
//  CooperationTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CooperationTableViewCell.h"

@implementation CooperationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = COLOR_TEXT_BLACK;
    _detailLabel.textColor = COLOR_TEXT_LIGHT;
    _nameLabel.textColor = COLOR_TEXT_LIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
