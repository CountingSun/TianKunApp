//
//  CooperationDetailTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/5.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CooperationDetailTableViewCell.h"

@implementation CooperationDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


    _titleLabel.textColor = COLOR_TEXT_LIGHT;
    _detailLabel.textColor = COLOR_TEXT_BLACK;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
