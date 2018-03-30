//
//  FindTalentsTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindTalentsTableViewCell.h"

@implementation FindTalentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = COLOR_TEXT_BLACK;
    _detailLabel.textColor = COLOR_THEME;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
