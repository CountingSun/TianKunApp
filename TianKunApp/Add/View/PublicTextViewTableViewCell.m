//
//  PublicTextViewTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PublicTextViewTableViewCell.h"

@interface PublicTextViewTableViewCell()<QMUITextViewDelegate>


@end

@implementation PublicTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textView.delegate = self;
    
}
- (void)textViewDidChange:(UITextView *)textView{
    if (_textViewChangeBlock) {
        _textViewChangeBlock(textView.text);
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
