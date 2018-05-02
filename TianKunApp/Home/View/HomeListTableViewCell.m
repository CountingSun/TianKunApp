//
//  HomeListTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeListTableViewCell.h"

@implementation HomeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleImageView.layer.masksToBounds = YES;
    _titleLabel.textColor = COLOR_TEXT_BLACK;
    _detailLabel.textColor = COLOR_TEXT_LIGHT;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
