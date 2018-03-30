//
//  PublicUploadTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PublicUploadTableViewCell.h"
#import "UIView+AddTapGestureRecognizer.h"
@implementation PublicUploadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _addImageView.userInteractionEnabled = YES;
    [_addImageView addTapGestureRecognizerWithActionBlock:^{
        if (_block) {
            _block();
        }
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
