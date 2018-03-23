//
//  MessageSetTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MessageSetTableViewCell.h"

@implementation MessageSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _detilLabel.textColor = COLOR_TEXT_LIGHT;
    _mainLabel.textColor = COLOR_TEXT_BLACK;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
