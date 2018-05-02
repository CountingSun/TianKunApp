//
//  InteractionListTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "InteractionListTableViewCell.h"

@implementation InteractionListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = COLOR_TEXT_BLACK;
    _contentLabel.textColor = COLOR_TEXT_GENGRAL;
    _timeLabel.textColor = COLOR_TEXT_LIGHT;
    _lookLabel.textColor = COLOR_TEXT_LIGHT;
    _commentLabel.textColor = COLOR_TEXT_LIGHT;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
