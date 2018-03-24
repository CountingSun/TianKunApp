//
//  UserInfoHeadTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UserInfoHeadTableViewCell.h"

@implementation UserInfoHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImage.layer.masksToBounds= YES;
    _headImage.layer.cornerRadius = _headImage.qmui_height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
