//
//  RecommendMessageTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RecommendMessageTableViewCell.h"

@implementation RecommendMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = COLOR_VIEW_BACK;
    _mainImageView.layer.masksToBounds = YES;
    _detailLabel.textColor = COLOR_TEXT_LIGHT;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
