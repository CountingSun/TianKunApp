//
//  WQBaseViewController.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "QMUICommonViewController.h"

@interface WQBaseViewController : QMUICommonViewController
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


/**
 显示加载等待动画
 */
- (void)showLoadingView;


/**
 显示加载等待动画

 @param frame 动画位置
 */
- (void)showLoadingViewWithFrame:(CGRect)frame;


/**
 隐藏加载动画
 */
- (void)hideLoadingView;
- (void)showGetDataFailViewWithReloadBlock:(dispatch_block_t)reloadBlock;
- (void)showGetDataNullWithReloadBlock:(dispatch_block_t)reloadBlock;


@end
