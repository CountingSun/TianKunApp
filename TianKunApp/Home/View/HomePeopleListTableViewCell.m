//
//  HomePeopleListTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/15.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomePeopleListTableViewCell.h"

@implementation HomePeopleListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowOffset =CGSizeMake(0, 1);
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = .5f;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
