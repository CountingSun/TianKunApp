//
//  TKAudioContrilView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "TKAudioContrilView.h"

#import "UIView+CustomControlView.h"
#import "MMMaterialDesignSpinner.h"
#import "DocumentInfo.h"
#import <MediaPlayer/MediaPlayer.h>

#define BottomDistance 10
#define buttonWH 60

@interface TKAudioContrilView ()<UIGestureRecognizerDelegate>
//当前时间
@property (nonatomic,strong) UILabel *timeLabel;
//总时间
@property (nonatomic,strong) UILabel *totalTimeLabel;
//进度条
@property (nonatomic,strong) ASValueTrackingSlider *slider;
//缓存进度条
@property (nonatomic,strong) UISlider *bufferSlier;

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIButton *backTimeButton;

@property (nonatomic ,strong) UIButton *forwardTimeButton;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 系统菊花 */
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;

@end

@implementation TKAudioContrilView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"music_player_background"].CGImage);
        
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI{
    
    _backButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButtton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButtton];
    [_backButtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(-2);
        make.width.height.offset(50);
    }];
    [_backButtton setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];

    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
 
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backButtton.mas_right);
        make.top.equalTo(self).offset(-2);
        make.right.equalTo(self).offset(-55);
        make.height.offset(50);
        
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"00:00";
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.width.mas_equalTo(@50);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(@20);
    }];

    _totalTimeLabel = [[UILabel alloc]init];
    _totalTimeLabel.textAlignment = NSTextAlignmentLeft;
    _totalTimeLabel.font = [UIFont systemFontOfSize:12];
    _totalTimeLabel.textColor = [UIColor whiteColor];
    _totalTimeLabel.text = @"00:00";

    [self addSubview:_totalTimeLabel];
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(@50);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(@20);

    }];

    
    _slider = [[ASValueTrackingSlider alloc]init];
    _slider.popUpViewCornerRadius = 0.0;
    _slider.popUpViewColor = RGBA(19, 19, 9, 1);
    _slider.popUpViewArrowLength = 8;
    _slider.minimumTrackTintColor = RGB(253, 217, 58, 1);
    _slider.maximumTrackTintColor = [UIColor whiteColor];

    [_slider setThumbImage:[UIImage imageNamed:@"player_point"] forState:UIControlStateNormal];
    
    
    // slider开始滑动事件
    [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [_slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [_slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
    [_slider addGestureRecognizer:sliderTap];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [_slider addGestureRecognizer:panRecognizer];
    [self addSubview:_slider];

    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(@20);
        make.left.equalTo(_timeLabel.mas_right).offset(10);
        make.right.equalTo(_totalTimeLabel.mas_left).offset(-10);

    }];
    
    _backTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_backTimeButton setImage:[UIImage imageNamed:@"后退"] forState:0];
    [_backTimeButton addTarget:self action:@selector(clickBackTimeButton) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_backTimeButton];
    
    [_backTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.bottom.equalTo(self).offset(-BottomDistance);
        make.width.height.offset(buttonWH);
    }];
    
    
    _forwardTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_forwardTimeButton setImage:[UIImage imageNamed:@"快进"] forState:0];
    [_forwardTimeButton addTarget:self action:@selector(clickForwardTimeButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_forwardTimeButton];
    
    [_forwardTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-40);
        make.bottom.equalTo(self).offset(-BottomDistance);
        make.width.height.offset(buttonWH);
    }];
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_playButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    [self addSubview:_playButton];
    [_playButton addTarget:self action:@selector(hanlePlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    

    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-BottomDistance);
        make.width.height.offset(buttonWH);
        make.centerX.equalTo(self);
    }];

    
}
-(void)hanlePlayBtn:(UIButton *)button{
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
        [self.delegate zf_controlView:self playAction:button];
    }

}
/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTap:)]) {
            [self.delegate zf_controlView:self progressSliderTap:tapValue];
        }
    }
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    [self zf_playerCancelAutoFadeOutControlView];
    self.slider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchBegan:)]) {
        [self.delegate zf_controlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderValueChanged:)]) {
        [self.delegate zf_controlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
//    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchEnded:)]) {
        [self.delegate zf_controlView:self progressSliderTouchEnded:sender];
    }
}
-(void)handleTap:(UITapGestureRecognizer *)gesture{
}
- (void)clickBackButton:(UIButton *)sender{
    // 在cell上并且是竖屏时候响应关闭事件
        if ([self.delegate respondsToSelector:@selector(zf_controlView:backAction:)]) {
            [self.delegate zf_controlView:self backAction:sender];
    }

}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

- (void)clickBackTimeButton{
    if (_audioContrilDelegate) {
        [_audioContrilDelegate clickBackTimeButtonEvent];
    }
}
- (void)clickForwardTimeButton{
    if (_audioContrilDelegate) {
        [_audioContrilDelegate clickForwardTimeButtonEvent];
    }


}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGRect rect = [self thumbRect];
    CGPoint point = [touch locationInView:self.slider];
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
    }
    return YES;
}
/**
 slider滑块的bounds
 */
- (CGRect)thumbRect {
    return [self.slider thumbRectForBounds:self.slider.bounds
                                      trackRect:[self.slider trackRectForBounds:self.slider.bounds]
                                          value:self.slider.value];
}
- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.slider.value           = value;
        // 更新当前播放时间
        self.timeLabel.text       = [NSString stringWithFormat:@"%02ld:%02ld", (long)proMin, (long)proSec];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
        [dict setObject:[NSNumber numberWithInteger:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
        [dict setObject:[NSNumber numberWithInteger:totalTime] forKey:MPMediaItemPropertyPlaybackDuration];

        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];

        _totalTime = totalTime;
        _currectTime = currentTime;
        
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)durMin, (long)durSec];
}
- (void)zf_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
//    NSInteger durMin = totalTime / 60;//总秒
//    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02ld:%02ld", (long)proMin, (long)proSec];
//    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02ld:%02zd", (long)durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
//    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    self.slider.popUpView.hidden = YES;
    // 更新slider的值
    self.slider.value            = draggedValue;
    // 更新当前时间
    self.timeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    
}
/** 播放按钮状态 */
- (void)zf_playerPlayBtnState:(BOOL)state {
    self.playButton.selected = state;
}
/** 加载的菊花 */
- (void)zf_playerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}
- (void)zf_playerDraggedEnd {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.playButton.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];
}
- (void)autoFadeOutControlView {
}
- (void)setDocumentInfo:(DocumentInfo *)documentInfo{
    _documentInfo = documentInfo;
    _titleLabel.text = documentInfo.data_title;
    NSLog(@"锁屏设置");
    // BASE_INFO_FUN(@"配置NowPlayingCenter");
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //音乐的标题
    [info setObject:_documentInfo.data_title forKey:MPMediaItemPropertyTitle];
    //音乐的艺术家
    [info setObject:_documentInfo.author forKey:MPMediaItemPropertyArtist];
    //音乐的播放速度
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    
    //音乐的总时间
    
    //音乐的播放时间
    [info setObject:[NSNumber numberWithInt:0] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    
    //音乐的封面
    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"music_player_background.png"]];
    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //完成设置
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];

}
- (void)resetView{
    _timeLabel.text = @"00:00";
    _totalTimeLabel.text  = @"00:00";
    _slider.value = 0;
    
}
- (NSInteger)totalTime{
    return _totalTime;
    
}
- (NSInteger)currectTime{
    return _currectTime;
    
}
@end
