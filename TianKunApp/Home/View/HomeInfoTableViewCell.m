//
//  HomeInfoTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeInfoTableViewCell.h"

@implementation HomeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _choicenessLabel.layer.masksToBounds = YES;
    _choicenessLabel.layer.cornerRadius = 10;
    _choicenessLabel.textColor = COLOR_TEXT_ORANGE;
    _choicenessLabel.layer.borderWidth = 1;
    _choicenessLabel.layer.borderColor = COLOR_TEXT_ORANGE.CGColor;

    _attentionLabel.layer.masksToBounds = YES;
    _attentionLabel.layer.cornerRadius = 10;
    _attentionLabel.textColor = COLOR_TEXT_ORANGE;
    _attentionLabel.layer.borderWidth = 1;
    _attentionLabel.layer.borderColor = COLOR_TEXT_ORANGE.CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
