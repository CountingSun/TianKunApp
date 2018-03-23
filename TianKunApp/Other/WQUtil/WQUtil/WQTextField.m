//
//  WQTextField.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/14.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQTextField.h"

@implementation WQTextField

-(instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor placeHolder:(NSString *)placeHolder delegate:(id<UITextFieldDelegate>)delegate;
{

    if (self = [super initWithFrame:frame]) {
        
        self.font = font;
        self.textColor = textColor;
        self.placeholder = placeHolder;
        self.delegate = delegate;
        
    }
    return self;
    
}
-(instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor placeHolder:(NSString *)placeHolder placeHolderColor:(UIColor *)placeHolderColor leftView:(UIView *)leftView clearButtonMode:(UITextFieldViewMode)clearButtonMode keyBoardtype:(UIKeyboardType)keyBoardtype delegate:(id<UITextFieldDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        
        self.font = font;
        self.textColor = textColor;

        if (placeHolderColor) {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:placeHolderColor}];

        }else{
            self.placeholder = placeHolder;
            
            
        }
        if (leftView) {
            self.leftView = leftView;
            self.leftViewMode = UITextFieldViewModeAlways;
            
        }
        self.clearButtonMode = clearButtonMode;
        self.keyboardType = keyBoardtype;
        self.delegate = delegate;

    }
    return self;


}
@end
