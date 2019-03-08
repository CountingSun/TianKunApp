//
//  FindJobDetailTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindJobDetailTableViewCell.h"

@implementation FindJobDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 10;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
