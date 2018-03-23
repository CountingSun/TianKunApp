//
//  LoadingView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
@property (nonatomic, strong) UIImageView *AnimationImageView;

@property (nonatomic, copy) NSString *loadingText;

- (instancetype)initWithFrame:(CGRect)frame loadingText:(NSString *)loadingText;
@end
