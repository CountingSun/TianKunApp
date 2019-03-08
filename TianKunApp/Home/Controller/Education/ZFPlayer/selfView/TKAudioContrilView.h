//
//  TKAudioContrilView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKAudioContrilView,DocumentInfo;

@protocol TKAudioContrilViewDelegate <NSObject>
- (void)clickBackTimeButtonEvent;
- (void)clickForwardTimeButtonEvent;


@end

@interface TKAudioContrilView : UIView

//返回按钮
@property (nonatomic ,strong) UIButton *backButtton;

@property (nonatomic ,strong) UIButton *playButton;
//进度条当前值
@property (nonatomic,assign) CGFloat value;
//最小值
@property (nonatomic,assign) CGFloat minValue;
//最大值
@property (nonatomic,assign) CGFloat maxValue;
//总时间
@property (nonatomic,assign ) NSInteger totalTime;
//当前时间
@property (nonatomic,assign ) NSInteger currectTime;

//缓存条当前值
@property (nonatomic,assign) CGFloat bufferValue;
//代理方法
@property (nonatomic,copy) NSString *title;

@property (nonatomic ,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic ,strong) DocumentInfo *documentInfo;

@property (nonatomic ,weak) id<TKAudioContrilViewDelegate>audioContrilDelegate;

- (void)resetView;


@end
