//
//  WQTextView.m
//  WeddingApp
//
//  Created by seekmac002 on 2017/12/19.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "WQTextView.h"

@interface WQTextView ()<UITextViewDelegate>

@property (nonatomic,strong) UILabel *placeholderLabel;
@end

@implementation WQTextView

-(instancetype)initWithFrame:(CGRect)frame texeColor:(UIColor *)texeColor font:(UIFont *)font placeholder:(NSString *)placeholder{
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.font = font;
        self.textColor = texeColor;
        
        _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        
        _placeholderLabel.font = font;
        _placeholderLabel.textColor = [UIColor groupTableViewBackgroundColor];
        _placeholderLabel.text = placeholder;
        
        [self addSubview:_placeholderLabel];

    }
    return self;
    
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length) {
        _placeholderLabel.hidden = YES;
    }else{
        
        _placeholderLabel.hidden = NO;

    }
}

@end
