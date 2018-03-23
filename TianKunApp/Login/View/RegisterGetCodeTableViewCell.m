//
//  RegisterGetCodeTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RegisterGetCodeTableViewCell.h"

@implementation RegisterGetCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}
-(void)textChange{
    if (_textBlock) {
        _textBlock(_textField.text);
    }
    
}
- (IBAction)getCodeButtonClfickEvent:(id)sender {
    
//    if (_buttonClick) {
//        _buttonClick();
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
