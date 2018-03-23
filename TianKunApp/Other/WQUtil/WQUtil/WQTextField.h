//
//  WQTextField.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/14.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQTextField : UITextField

/**
 UITextField

 @param frame 位置
 @param font 字体
 @param textColor 颜色
 @param placeHolder 提示
 @return UITextField
 */
-(instancetype)initWithFrame:(CGRect)frame
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor
                 placeHolder:(NSString *)placeHolder
                    delegate:(id<UITextFieldDelegate>)delegate;


/**
 UITextField
 placeHolderColor和leftView设置为nil则为默认样式

 @param frame 位置
 @param font 字体
 @param textColor 颜色
 @param placeHolder 提示
 @param placeHolderColor 提示文字颜色
 @param leftView 左边view
 @param clearButtonMode 清除按钮样式
 @param keyBoardtype 键盘类型
 @return UITextField
 */
-(instancetype)initWithFrame:(CGRect)frame
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor
                 placeHolder:(NSString *)placeHolder
                 placeHolderColor:(UIColor *)placeHolderColor
                    leftView:(UIView *)leftView
             clearButtonMode:(UITextFieldViewMode)clearButtonMode
                keyBoardtype:(UIKeyboardType)keyBoardtype
                    delegate:(id<UITextFieldDelegate>)delegate;


@end
