//
//  WQBaseViewController.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQBaseViewController : UIViewController
/**
 是否隐藏导航栏
 */
@property (nonatomic,assign) BOOL isHiddenNav;
/**
 设置返回按钮文字
 
 @param backButtonTitle void
 */
-(void)setBackButtonTitle:(NSString *)backButtonTitle;

/**
 加载失败提示
 
 @param status 提示语
 */
-(void)showErrorWithStatus:(NSString *)status;

/**
 加载等待提示
 
 @param status 提示语
 */
-(void)showWithStatus:(NSString *)status;

/**
 加载成功提示
 
 @param status 提示语
 */
-(void)showSuccessWithStatus:(NSString *)status;

-(void)dismiss;

@end
