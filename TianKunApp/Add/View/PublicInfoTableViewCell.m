//
//  PublicInfoTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PublicInfoTableViewCell.h"

@implementation PublicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_inputTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textChange{
    if (_textBlock) {
        _textBlock(_inputTextField.text);
    }
    
}

@end
