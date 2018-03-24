//
//  UserInfoPhotoTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UserInfoPhotoTableViewCell.h"
#import "UIView+AddTapGestureRecognizer.h"

@implementation UserInfoPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _goLabel.textColor = [UIColor redColor];

    
}
- (IBAction)photoButtonClick:(id)sender {
    if (_block) {
        _block();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
