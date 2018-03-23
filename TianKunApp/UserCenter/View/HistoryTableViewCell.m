//
//  HistoryTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = COLOR_TEXT_BLACK;
    _nimLabel.textColor = COLOR_TEXT_LIGHT;
    _timeLabel.textColor = COLOR_TEXT_LIGHT;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
