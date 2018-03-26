//
//  WQTabBar.m
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/9.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "WQTabBar.h"
@interface WQTabBar ()

@property (strong, nonatomic) UIButton *composeButton;

@end

@implementation WQTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.composeButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.composeButton.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    // 一个UITabBarButton的索引
    NSInteger index = 0;
    
    // 每个Button的宽
    CGFloat itemW = self.bounds.size.width / 5;
    
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGRect rect = subView.frame;
            
            rect.origin.x = index * itemW;
            rect.size.width = itemW;
            
            if (index == 1) {
                index ++;
            }
            subView.frame = rect;
            index ++;
        }
    }
    
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
            animation.duration = 1;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

- (void)composeBtnClick :(UIButton *)sender {
    if (self.composeButtonClick) {
        self.composeButtonClick();
    }
}

#pragma mark -- 懒加载
- (UIButton *)composeButton {
    if(!_composeButton){
        _composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_composeButton addTarget:self action:@selector(composeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_composeButton setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
        [_composeButton setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateHighlighted];
        [_composeButton sizeToFit];
    }
    return _composeButton;
}
@end
