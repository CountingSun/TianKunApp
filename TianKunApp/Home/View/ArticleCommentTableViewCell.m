//
//  ArticleCommentTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ArticleCommentTableViewCell.h"

@implementation ArticleCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.qmui_width/2;
    
    _naemLabel.textColor = COLOR_TEXT_BLACK;
    _timeLabel.textColor = COLOR_TEXT_LIGHT;
    _contentLbel.textColor = COLOR_TEXT_LIGHT;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
