//
//  CollectShareView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^collectButtonBlock)(void);
typedef void(^shareButtonBlock)(void);

@interface CollectShareView : UIView
@property (strong, nonatomic)  QMUIButton *collectButton;
@property (strong, nonatomic)  QMUIButton *shareButton;

@property (nonatomic, copy) collectButtonBlock collectButtonBlock;
@property (nonatomic, copy) shareButtonBlock shareButtonBlock;


- (instancetype)initWithFrame:(CGRect)frame collectButtonBlock:(collectButtonBlock)collectButtonBlock shareButtonBlock:(shareButtonBlock)shareButtonBlock;


@end
