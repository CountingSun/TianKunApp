//
//  EducationTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationTableViewCell.h"

@implementation EducationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
