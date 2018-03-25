//
//  RemindMessageTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RemindMessageTableViewCell.h"

@implementation RemindMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.textColor = COLOR_TEXT_GENGRAL;
    _starTimeLabel.textColor = COLOR_TEXT_LIGHT;
    _endTimeLabel.textColor = COLOR_THEME;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
