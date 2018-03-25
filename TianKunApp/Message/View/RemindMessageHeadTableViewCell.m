//
//  RemindMessageHeadTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RemindMessageHeadTableViewCell.h"

@implementation RemindMessageHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _detailLabel.textColor = COLOR_TEXT_LIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
