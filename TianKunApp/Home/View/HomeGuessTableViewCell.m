//
//  HomeGuessTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeGuessTableViewCell.h"

@implementation HomeGuessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.backgroundColor = COLOR_THEME;
    [_reloadButton setTitleColor:COLOR_TEXT_LIGHT forState:0];
    [_reloadButton setSpacingBetweenImageAndTitle:5];
    [_reloadButton setImagePosition:QMUIButtonImagePositionLeft];
    [_reloadButton setImage:[UIImage imageNamed:@"刷新"] forState:0];
    
}
- (IBAction)reloadButtonClickEvent:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
