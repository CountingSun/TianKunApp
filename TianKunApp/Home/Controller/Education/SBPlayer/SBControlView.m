//
//  SBControlView.m
//  SBPlayer
//
//  Created by sycf_ios on 2017/4/10.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import "SBControlView.h"
#import "WQSlider.h"

@interface SBControlView ()
//当前时间
@property (nonatomic,strong) UILabel *timeLabel;
//总时间
@property (nonatomic,strong) UILabel *totalTimeLabel;
//进度条
@property (nonatomic,strong) WQSlider *slider;
//缓存进度条
@property (nonatomic,strong) UISlider *bufferSlier;

@end
static NSInteger padding = 8;
@implementation SBControlView
//懒加载
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}
-(UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textAlignment = NSTextAlignmentLeft;
        _totalTimeLabel.font = [UIFont systemFontOfSize:12];
        _totalTimeLabel.textColor = [UIColor whiteColor];
    }
    return _totalTimeLabel;
}
-(WQSlider *)slider{
    if (!_slider) {
        _slider = [[WQSlider alloc]init];
        [_slider setThumbImage:[UIImage imageNamed:@"player_point"] forState:UIControlStateNormal];
        _slider.continuous = NO;
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [_slider addTarget:self action:@selector(handleSliderPosition:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(stareHandleSliderPosition:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(endHandleSliderPosition:) forControlEvents:UIControlEventTouchCancel];

        [_slider addGestureRecognizer:self.tapGesture];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.minimumTrackTintColor = COLOR_THEME;
    }
    return _slider;
}
-(UIButton *)largeButton{
    if (!_largeButton) {
        _largeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _largeButton.contentMode = UIViewContentModeScaleToFill;
        [_largeButton setImage:[UIImage imageNamed:@"player_full_cancel"] forState:UIControlStateSelected];
        [_largeButton setImage:[UIImage imageNamed:@"player_full"] forState:UIControlStateNormal];

        [_largeButton addTarget:self action:@selector(hanleLargeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _largeButton;
}
-(UISlider *)bufferSlier{
    if (!_bufferSlier) {
        _bufferSlier = [[UISlider alloc]init];
        [_bufferSlier setThumbImage:[UIImage new] forState:UIControlStateNormal];
        _bufferSlier.continuous = YES;
        _bufferSlier.minimumTrackTintColor = [UIColor whiteColor];
        _bufferSlier.minimumValue = 0.f;
        _bufferSlier.maximumValue = 1.f;
        _bufferSlier.userInteractionEnabled = NO;
    }
    return _bufferSlier;
}
- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.contentMode = UIViewContentModeScaleToFill;
        [_playButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"player_papuse"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(hanlePlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.selected = NO;

    }
    return _playButton;
}
- (void)drawRect:(CGRect)rect {
    [self setupUI];

}
-(void)setupUI{
    
    [self addSubview:self.timeLabel];
    [self addSubview:self.bufferSlier];
    [self addSubview:self.slider];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.largeButton];

    [self addSubview:self.playButton];
//添加约束
    [self addConstraintsForSubviews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)deviceOrientationDidChange{
    //添加约束
    [self addConstraintsForSubviews];
}
-(void)addConstraintsForSubviews{
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(padding);
        make.width.height.offset(30);
        make.centerY.equalTo(self);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playButton).offset(padding);
        make.bottom.top.mas_equalTo(self);
        make.width.mas_equalTo(@50);
    }];
    
    [self.largeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-padding);
        make.width.height.mas_equalTo(@30);
        make.centerY.equalTo(self);

    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.largeButton.mas_left);
        make.bottom.top.mas_equalTo(self);
        make.width.mas_equalTo(@50).priorityHigh();
    }];

    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(padding);
        make.right.mas_equalTo(self.totalTimeLabel.mas_left).offset(-padding);
        make.centerY.equalTo(self);

    }];
    [self.bufferSlier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.slider);
    }];
    [self layoutIfNeeded];
}
-(void)hanleLargeBtn:(UIButton *)button{
    button.selected =! button.selected;
    if ([self.delegate respondsToSelector:@selector(controlView:withLargeButton:)]) {
        [self.delegate controlView:self withLargeButton:button];
    }
}
-(void)hanlePlayBtn:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(controlView:withPlayButton:)]) {
        [self.delegate controlView:self withPlayButton:button];
    }
}

-(void)handleSliderPosition:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(controlView:draggedPositionWithSlider:)]) {
        [self.delegate controlView:self draggedPositionWithSlider:self.slider];
    }
}
-(void)stareHandleSliderPosition:(UISlider *)slider{
//    [self.tapGesture setEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(controlView:draggedPositionWithSlider:)]) {
        [self.delegate controlView:self draggedPositionStarWithSlider:self.slider];
    }
}
-(void)endHandleSliderPosition:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(controlView:draggedPositionWithSlider:)]) {
        [self.delegate controlView:self draggedPositionEndWithSlider:self.slider];
    }
//    [self.tapGesture setEnabled:YES];

}

-(void)handleTap:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.slider];
    CGFloat pointX = point.x;
    CGFloat sliderWidth = self.slider.frame.size.width;
    CGFloat currentValue = pointX/sliderWidth * self.slider.maximumValue;
    if ([self.delegate respondsToSelector:@selector(controlView:pointSliderLocationWithCurrentValue:)]) {
        [self.delegate controlView:self pointSliderLocationWithCurrentValue:currentValue];
    }
}

//setter 和 getter方法
-(void)setValue:(CGFloat)value{
    self.slider.value = value;
}
-(CGFloat)value{
    return self.slider.value;
}
-(void)setMinValue:(CGFloat)minValue{
    self.slider.minimumValue = minValue;
}
-(CGFloat)minValue{
    return self.slider.minimumValue;
}
-(void)setMaxValue:(CGFloat)maxValue{
    self.slider.maximumValue = maxValue;
}
-(CGFloat)maxValue{
    return self.slider.maximumValue;
}
-(void)setCurrentTime:(NSString *)currentTime{
    self.timeLabel.text = currentTime;
}
-(NSString *)currentTime{
    return self.timeLabel.text;
}
-(void)setTotalTime:(NSString *)totalTime{
    self.totalTimeLabel.text = totalTime;
}
-(NSString *)totalTime{
    return self.totalTimeLabel.text;
}
-(CGFloat)bufferValue{
    return self.bufferSlier.value;
}
-(void)setBufferValue:(CGFloat)bufferValue{
    self.bufferSlier.value = bufferValue;
}
@end
