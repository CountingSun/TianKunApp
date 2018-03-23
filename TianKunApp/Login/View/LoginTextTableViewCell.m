//
//  LoginTextTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "LoginTextTableViewCell.h"

@implementation LoginTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_actionButton setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
    [_actionButton setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateSelected];
    

    [_texeField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (IBAction)buttonClickEvent:(UIButton *)sender {
    sender.selected  =! sender.selected;
    if (_delegate) {
        [_delegate clickSecureButton:sender indexPath:_indexPath];
    }
}
-(void)textChange{
    if (_textBlock) {
        _textBlock(_texeField.text);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
