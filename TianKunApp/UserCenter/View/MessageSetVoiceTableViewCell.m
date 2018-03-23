//
//  MessageSetVoiceTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MessageSetVoiceTableViewCell.h"

@implementation MessageSetVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainLabel.textColor = COLOR_TEXT_BLACK;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
