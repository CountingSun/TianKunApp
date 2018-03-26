//
//  CommentViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//



#import "QMUICommonViewController.h"

typedef void(^TextViewTextChangeBlock)(NSString *textViewText);

@interface CommentViewController : QMUICommonViewController
@property (nonatomic ,copy)TextViewTextChangeBlock textViewTextChangeBlock;
@property(nonatomic, strong) QMUITextView *textView;

- (void)showInParentViewController:(UIViewController *)controller;
- (void)hideWithIsClearnText:(BOOL)isClearn;

@end
