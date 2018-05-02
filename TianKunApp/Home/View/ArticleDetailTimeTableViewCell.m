//
//  ArticleDetailTimeTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ArticleDetailTimeTableViewCell.h"

@implementation ArticleDetailTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
