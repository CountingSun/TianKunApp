//
//  SBView.m
//  SBPlayer
//
//  Created by sycf_ios on 2017/4/10.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import "SBPlayer.h"
#import "SBTitleView.h"
#import "SBPlayerErrorView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SBPlayer ()

@property (nonatomic,strong,readonly) AVPlayerLayer *playerLayer;
//当前播放url
@property (nonatomic,strong) NSURL *url;
//底部控制视图
@property (nonatomic,strong) SBControlView *controlView;
//暂停和播放视图
@property (nonatomic,strong) SBPauseOrPlayView *pauseOrPlayView;
//原始约束
@property (nonatomic,strong) NSArray *oldConstriants;
//添加标题
@property (nonatomic,strong) SBTitleView *titleView;
//加载动画
@property (nonatomic,strong) UIActivityIndicatorView *activityIndeView;

@property (nonatomic ,strong) SBPlayerErrorView *playerErrorView;


/**
 记录进入后台时 视频是否在播放
 */
@property (nonatomic ,assign) BOOL isHadPlay;

/**
 判断是否刷新进度条
 */
@property (nonatomic ,assign) BOOL isNeesReloadSlider;

/**
 当前播放时间
 */
@property (nonatomic ,assign) CGFloat currectPlayTime;

/**
 拖动手势 拖动屏幕更改播放进度
 */
@property (nonatomic ,strong) UIPanGestureRecognizer *panGR;

@end
static NSInteger _afterCount = 0;
@implementation SBPlayer
+(Class)layerClass{
    return [AVPlayerLayer class];
}
//MARK: Get方法和Set方法
-(AVPlayer *)player{
    return self.playerLayer.player;
}
-(void)setPlayer:(AVPlayer *)player{
    self.playerLayer.player = player;
}
-(AVPlayerLayer *)playerLayer{
    return (AVPlayerLayer *)self.layer;
}
-(CGFloat)rate{
    return self.player.rate;
}
-(void)setRate:(CGFloat)rate{
    self.player.rate = rate;
}
-(void)setMode:(SBLayerVideoGravity)mode{
    switch (mode) {
        case SBLayerVideoGravityResizeAspect:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case SBLayerVideoGravityResizeAspectFill:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case SBLayerVideoGravityResize:
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
    }
}
-(void)setTitle:(NSString *)title{
    self.audioControlView.title = title;
}
-(NSString *)title{
    return self.titleView.titleLabel.text;
}
//MARK:实例化
-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        _url = url;
        [self setupPlayerUI];
        [self assetWithURL:url];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupPlayerUI];
    }
    return self;
}
-(void)assetWithURL:(NSURL *)url{
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    self.anAsset = [[AVURLAsset alloc]initWithURL:url options:options];
    NSArray *keys = @[@"duration"];
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    
    dispatch_async(queue, ^{
        [self.anAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            NSError *error = nil;
            AVKeyValueStatus tracksStatus = [self.anAsset statusOfValueForKey:@"duration" error:&error];
            switch (tracksStatus) {
                case AVKeyValueStatusLoaded:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!CMTIME_IS_INDEFINITE(self.anAsset.duration)) {
                            CGFloat second = self.anAsset.duration.value / self.anAsset.duration.timescale;
                            
                            
                            if (_fileType == 3) {
                                self.audioControlView.totalTime = [self convertTime:second];
                                self.audioControlView.minValue = 0;
                                self.audioControlView.maxValue = second;
                                
                                if (_delegate) {
                                    [_delegate palyerStatusLoaded];
                                }
                            }else{
                                self.controlView.totalTime = [self convertTime:second];
                                self.controlView.minValue = 0;
                                self.controlView.maxValue = second;
                                
                            }
                        }
                    });
                    [self setupPlayerWithAsset:self.anAsset];
                }
                    break;
                case AVKeyValueStatusFailed:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.activityIndeView stopAnimating];
                        if (_fileType == 3) {
                            self.audioControlView.userInteractionEnabled = NO;
                            
                        }else{
                            self.controlView.userInteractionEnabled = NO;
                            
                        }
                        
                        [self addErrorView];
                        
                    });
                }
                    break;
                case AVKeyValueStatusCancelled:
                {
                    NSLog(@"AVKeyValueStatusCancelled取消");
                }
                    break;
                case AVKeyValueStatusUnknown:
                {
                    NSLog(@"AVKeyValueStatusUnknown未知");
                }
                    break;
                case AVKeyValueStatusLoading:
                {
                    NSLog(@"AVKeyValueStatusLoading正在加载");
                }
                    break;
            }
        }];


    });
    
                   


}
-(instancetype)initWithAsset:(AVURLAsset *)asset{
    self = [super init];
    if (self) {
        [self setupPlayerUI];
        [self setupPlayerWithAsset:asset];
    }
    return self;
}
-(void)setupPlayerWithAsset:(AVURLAsset *)asset{
    self.item = [[AVPlayerItem alloc]initWithAsset:asset];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
    [self.playerLayer displayIfNeeded];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self addPeriodicTimeObserver];
    //添加KVO
    [self addKVO];
    //添加消息中心
    [self addNotificationCenter];
}
//FIXME: Tracking time,跟踪时间的改变
-(void)addPeriodicTimeObserver{
    __weak typeof(self) weakSelf = self;
    playbackTimerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.f, 1.f) queue:NULL usingBlock:^(CMTime time) {
        
        CGFloat currectTime = weakSelf.item.currentTime.value/weakSelf.item.currentTime.timescale;
        _currectPlayTime = currectTime;
        
        if (weakSelf.isNeesReloadSlider) {
            if (_fileType == 3) {
                
                weakSelf.audioControlView.value = currectTime;

            }else{
                weakSelf.controlView.value = currectTime;
            }
        }else{
            _afterCount = 0;
        }
//        NSLog(@"当前播放状态：%@",@(weakSelf.status));
//
        NSLog(@"当前播放时间：%@",@(weakSelf.currectPlayTime));
        
        
        
        if (weakSelf.tryWatchTime) {
            if (currectTime>= weakSelf.tryWatchTime) {
                [weakSelf pause];
                weakSelf.playerTryWatchFinishView.hidden = NO;
                [weakSelf setSubViewsIsHide:NO];
                

            }

        }
        
        
        
        
        
        if (!CMTIME_IS_INDEFINITE(self.anAsset.duration)) {
            
            if (_fileType == 3) {
                

            }else{
                weakSelf.controlView.currentTime = [weakSelf convertTime:weakSelf.controlView.value];
            }
        }
        if (_afterCount>=5) {
            [weakSelf setSubViewsIsHide:YES];
        }else{
            [weakSelf setSubViewsIsHide:NO];
        }
        if (_fileType == 3) {
            _afterCount = 0;
        }else{
            _afterCount += 1;
        }
    }];
}
//TODO: KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus itemStatus = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
        
        switch (itemStatus) {
            case AVPlayerItemStatusUnknown:
            {
                _status = SBPlayerStatusUnknown;
                NSLog(@"AVPlayerItemStatusUnknown");
            }
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                _status = SBPlayerStatusReadyToPlay;
                NSLog(@"AVPlayerItemStatusReadyToPlay");
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                _status = SBPlayerStatusFailed;
                NSLog(@"AVPlayerItemStatusFailed");
            }
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {  //监听播放器的下载进度
        NSArray *loadedTimeRanges = [self.item loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
        CMTime duration = self.item.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        //缓存值
        if (_fileType == 3) {
            self.audioControlView.bufferValue=timeInterval / totalDuration;

        }else{
            self.controlView.bufferValue=timeInterval / totalDuration;

        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        _status = SBPlayerStatusBuffering;
        if (!self.activityIndeView.isAnimating) {
            [self.activityIndeView startAnimating];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        NSLog(@"缓冲达到可播放");
        _status = SBPlayerStatusCanPlay;

        [self.activityIndeView stopAnimating];
    } else if ([keyPath isEqualToString:@"rate"]){//当rate==0时为暂停,rate==1时为播放,当rate等于负数时为回放
        if ([[change objectForKey:NSKeyValueChangeNewKey]integerValue]==0) {
            _isPlaying=false;
            _status = SBPlayerStatusPlaying;
            if (_fileType == 3) {
                self.audioControlView.playButton.selected = NO;

            }else{
                self.controlView.playButton.selected = NO;

            }
            
        }else{
            _isPlaying=true;
            _status = SBPlayerStatusStopped;
            if (_fileType == 3) {
                self.audioControlView.playButton.selected = YES;
                
            }else{
                self.controlView.playButton.selected = YES;
                
            }

        }
    }

}
//添加KVO
-(void)addKVO{
    //监听状态属性
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听网络加载情况属性
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听播放的区域缓存是否为空
    [self.item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓存可以播放的时候调用
    [self.item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    //监听暂停或者播放中
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}
//MARK:添加消息中心
-(void)addNotificationCenter{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SBPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

}
//MARK: NotificationCenter
-(void)SBPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification{
    [self.item seekToTime:kCMTimeZero];
    [self setSubViewsIsHide:NO];
    _afterCount = 0;
    [self pause];
    [self.pauseOrPlayView.imageBtn setSelected:NO];

}
-(void)deviceOrientationDidChange:(NSNotification *)notification{
    UIInterfaceOrientation _interfaceOrientation=[[UIApplication sharedApplication]statusBarOrientation];
    switch (_interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            _isFullScreen = YES;
            if (!self.oldConstriants) {
                self.oldConstriants = [self getCurrentVC].view.constraints;
            }
            [self.controlView updateConstraintsIfNeeded];
            //删除UIView animate可以去除横竖屏切换过渡动画
            [UIView animateWithDuration:kTransitionTime delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0. options:UIViewAnimationOptionTransitionCurlUp animations:^{
//                [[UIApplication sharedApplication].keyWindow addSubview:self];
//                [self mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow);
//                }];
//                [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.offset(SCREEN_HEIGHT);
//
//                }];
                self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

                [self layoutIfNeeded];
            } completion:nil];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
        {
            _isFullScreen = NO;
//            [[self getCurrentVC].view addSubview:self];
            //删除UIView animate可以去除横竖屏切换过渡动画
            [UIView animateKeyframesWithDuration:kTransitionTime delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//                if (self.oldConstriants) {
//                    [[self getCurrentVC].view addConstraints:self.oldConstriants];
//                }
//                [self mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.right.top.mas_equalTo([UIApplication sharedApplication].keyWindow);
//                    make.height.offset(250);
//                }];
                self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9);
                

                [self layoutIfNeeded];
            } completion:nil];
        }
            break;
        case UIInterfaceOrientationUnknown:
            NSLog(@"UIInterfaceOrientationUnknown");
            break;
    }
    [[self getCurrentVC].view layoutIfNeeded];

}
-(void)willResignActive:(NSNotification *)notification{
    if (_fileType == 3) {
        
    }else{
        _isHadPlay = _isPlaying;
        
        if (_isPlaying) {
            [self setSubViewsIsHide:NO];
            _afterCount = 0;
            [self pause];
            [self.controlView.playButton setSelected:NO];
        }

    }
}
-(void)applicationDidBecomeActive:(NSNotification *)notification{
    if (_isHadPlay) {
        if (_fileType == 3) {
            
        }else{
            [self play];
            [self setSubViewsIsHide:NO];
            [self.controlView.playButton setSelected:YES];

        }
    }
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
- (void)drawRect:(CGRect)rect {
    [self setupPlayerUI];
}
//MARK: 设置界面 在此方法下面可以添加自定义视图，和删除视图
-(void)setupPlayerUI{
    //添加加载视图
    [self addLoadingView];
    //初始化时间
    [self initTimeLabels];
    //添加标题
    _isNeesReloadSlider = YES;

    if (_fileType == 3) {
//        [self addTitle];
        [self audioControlView];

    }else{
        //添加点击事件
        [self addGestureEvent];
        //添加控制视图
        [self addControlView];
        //添加播放开始视图
        [self addPlayerStateView];
        [self addTitle];

    }
    
    
    
    
    
    
}
//初始化时间
-(void)initTimeLabels{
    if (_fileType == 3) {

    }else{
        self.controlView.currentTime = @"00:00";
        self.controlView.totalTime = @"00:00";

    }
}
//添加加载视图
-(void)addLoadingView{
    [self addSubview:self.activityIndeView];
    [self.activityIndeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@64);
        make.center.mas_equalTo(self);
    }];
}
//添加标题
-(void)addTitle{
    if (_fileType == 3) {
        
    }else{
        [self addSubview:self.titleView];
        [self bringSubviewToFront:self.titleView];

    }
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(0);
        make.width.mas_equalTo(self.mas_width);
        if (IS_IPHONE_X) {
            make.height.offset(72);
        }else{
            make.height.offset(52);
        }
    }];
}
- (void)addErrorView{
    [self addSubview:self.playerErrorView];
    [self.playerErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.width.offset(80);
        make.height.offset(60);

    }];
    
    
}
//添加点击事件
-(void)addGestureEvent{
    
//    添加右滑手势：

    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
//    [self addGestureRecognizer:panGR];
    _panGR = panGR;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapAction:)];
    tap.delegate = self;
    [tap requireGestureRecognizerToFail:panGR];
    [self addGestureRecognizer:tap];


}
#pragma mark- 拖动手势 拖动屏幕更改当前播放进度
- (void)panGRAct: (UIPanGestureRecognizer *)rec{
    
    
    _afterCount = 0;
    
    _isNeesReloadSlider = NO;
    
    CGPoint point = [rec translationInView:self];
    
    CGFloat changeValue = point.x /5;
    
    CGFloat newChangeValue = _currectPlayTime + changeValue;
    
    if (_fileType == 3) {
        [self.audioControlView setValue:newChangeValue];
    }else{
        [self.controlView setValue:newChangeValue];
    }

    
    if (rec.state == UIGestureRecognizerStateEnded|| rec.state == UIGestureRecognizerStateCancelled) {
        CMTime pointTime = CMTimeMake(newChangeValue * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
        }];
    }
    
    
    
}
-(void)handleTapAction:(UITapGestureRecognizer *)gesture{
    
    if (_playerTryWatchFinishView) {
        if (!_playerTryWatchFinishView.hidden) {
            [self setSubViewsIsHide:NO];
            _afterCount = 0;
            return;
        }
    }
    if (self.controlView.hidden) {
        [self setSubViewsIsHide:NO];
        _afterCount = 0;
    }else{
        [self setSubViewsIsHide:YES];
        _afterCount = 6;
    }
}
#pragma mark- ################## 懒加载视图 ################################
//添加播放和暂停按钮
-(void)addPauseAndPlayBtn{
    [self addSubview:self.pauseOrPlayView];
    [self.pauseOrPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.controlView);
    }];
}
//添加开始视图
-(void)addPlayerStateView{
    [self addSubview:self.playerStateView];
    [_playerStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self layoutIfNeeded];

}

//添加控制视图
-(void)addControlView{

    [self addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(@44);
    }];
    [self layoutIfNeeded];
}
//音频播放的界面
- (TKAudioContrilView *)audioControlView{
    if (!_audioControlView) {
        _audioControlView = [[TKAudioContrilView alloc] init];
//        _audioControlView.delegate = self;
        
        [self addSubview:_audioControlView];
        [_audioControlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
        
    }
    
    return _audioControlView;
}

//懒加载ActivityIndicateView
-(UIActivityIndicatorView *)activityIndeView{
    if (!_activityIndeView) {
        _activityIndeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndeView.hidesWhenStopped = YES;
    }
    return _activityIndeView;
}
//懒加载标题
-(SBTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[SBTitleView alloc]init];
        __weak typeof(self) weakSelf = self;
        [_controlView.tapGesture requireGestureRecognizerToFail:_titleView.backButton.gestureRecognizers.firstObject];

        _titleView.backBlcok = ^{
            if (weakSelf.delegate) {
                [weakSelf.delegate clickBakcButton];
                
            }
        };
        
    }
    return _titleView;
}
//懒加载开始视图
- (SBPlayerStateView *)playerStateView{
    if (!_playerStateView) {
        _playerStateView = [[SBPlayerStateView alloc]init];
        _playerStateView.hidden = YES;
        _playerStateView.delegate = self;
        
    }
    return _playerStateView;
}

//懒加载暂停或者播放视图
-(SBPauseOrPlayView *)pauseOrPlayView{
    if (!_pauseOrPlayView) {
        _pauseOrPlayView = [[SBPauseOrPlayView alloc]init];
        _pauseOrPlayView.backgroundColor = [UIColor clearColor];
        _pauseOrPlayView.delegate = self;
    }
    return _pauseOrPlayView;
}
//懒加载控制视图
-(SBControlView *)controlView{
    if (!_controlView) {
        _controlView = [[SBControlView alloc]init];
        _controlView.delegate = self;
        _controlView.backgroundColor = UIColorMask;
        [_controlView.tapGesture requireGestureRecognizerToFail:self.pauseOrPlayView.imageBtn.gestureRecognizers.firstObject];
    }
    return _controlView;
}

- (PlayerTryWatchFinishView *)playerTryWatchFinishView{
    if (!_playerTryWatchFinishView) {
        _playerTryWatchFinishView = [[[NSBundle mainBundle] loadNibNamed:@"PlayerTryWatchFinishView" owner:nil options:nil] firstObject];
        _playerTryWatchFinishView.delegate = self;
        
        [self addSubview:_playerTryWatchFinishView];
        
        [_playerTryWatchFinishView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
            
        }];
        _playerTryWatchFinishView.hidden = YES;
        
        
    }
    if (_fileType == 3) {
        
    }else{
        [self bringSubviewToFront:self.titleView];

    }

    return _playerTryWatchFinishView;
    
}
- (SBPlayerErrorView *)playerErrorView{
    if (!_playerErrorView) {
        _playerErrorView = [[SBPlayerErrorView alloc]init];
    }
    return _playerErrorView;
    
}
//设置子视图是否隐藏
-(void)setSubViewsIsHide:(BOOL)isHide{
    [UIView animateWithDuration:0.3 animations:^{
        self.controlView.hidden = isHide;
        self.pauseOrPlayView.hidden = isHide;
        self.titleView.hidden = isHide;
    }];
}
//MARK: SBPauseOrPlayViewDeleagate
-(void)pauseOrPlayView:(SBPauseOrPlayView *)pauseOrPlayView withState:(BOOL)state{
    _afterCount = 0;
    if (state) {
        [self play];
    }else{
        [self pause];
    }
}
//MARK: SBControlViewDelegate
-(void)controlView:(SBControlView *)controlView pointSliderLocationWithCurrentValue:(CGFloat)value{
    _afterCount = 0;
    
    if (_tryWatchTime&&value>=_tryWatchTime) {
        CMTime pointTime = CMTimeMake(_tryWatchTime * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;

        }];

        self.playerTryWatchFinishView.hidden = NO;
        self.controlView.value = _tryWatchTime;
        
        [self setSubViewsIsHide:NO];

    }else{
        CMTime pointTime = CMTimeMake(value * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;

        }];

    }
}

#pragma mark- 拖拽进度条
-(void)controlView:(SBControlView *)controlView draggedPositionWithSlider:(UISlider *)slider{
    _afterCount = 0;
    if (_tryWatchTime&&controlView.value>=_tryWatchTime) {
        CMTime pointTime = CMTimeMake(_tryWatchTime * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;

        }];
        controlView.value = _tryWatchTime;
        self.playerTryWatchFinishView.hidden = NO;
        [self setSubViewsIsHide:NO];

    }else{
        CMTime pointTime = CMTimeMake(controlView.value * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
        }];
        
        
        NSLog(@"time:%@",@(controlView.value));

    }

}
-(void)controlView:(SBControlView *)controlView draggedPositionStarWithSlider:(UISlider *)slider {
    _isNeesReloadSlider = NO;
    

}
-(void)controlView:(SBControlView *)controlView draggedPositionEndWithSlider:(UISlider *)slider {
//    _isNeesReloadSlider = YES;

}

-(void)controlView:(SBControlView *)controlView withLargeButton:(UIButton *)button{
    _afterCount = 0;
    if (kScreenWidth<kScreenHeight) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}
- (void)controlView:(SBControlView *)controlView withPlayButton:(UIButton *)button{
    if (button.selected) {
        [self pause];
    }else{
        [self play];
        
    }
    

}
-(void)audioContrilView:(TKAudioContrilView *)controlView pointSliderLocationWithCurrentValue:(CGFloat)value{
    _afterCount = 0;
    
    if (_tryWatchTime&&value>=_tryWatchTime) {
        CMTime pointTime = CMTimeMake(_tryWatchTime * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
            
        }];
        self.playerTryWatchFinishView.hidden = NO;
        self.audioControlView.value = _tryWatchTime;
        [self setSubViewsIsHide:NO];
        
    }else{
        CMTime pointTime = CMTimeMake(value * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
            
        }];
        
    }

}

-(void)audioContrilView:(TKAudioContrilView *)controlView draggedPositionWithSlider:(UISlider *)slider {
    _afterCount = 0;
    if (_tryWatchTime&&controlView.value>=_tryWatchTime) {
        CMTime pointTime = CMTimeMake(_tryWatchTime * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
            
        }];
        controlView.value = _tryWatchTime;
        self.playerTryWatchFinishView.hidden = NO;
        [self setSubViewsIsHide:NO];
        
    }else{
        CMTime pointTime = CMTimeMake(controlView.value * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
        }];
        
        
        NSLog(@"time:%@",@(controlView.value));
        
    }
    

}
-(void)audioContrilView:(TKAudioContrilView *)controlView draggedPositionStarWithSlider:(UISlider *)slider {
    _isNeesReloadSlider = NO;

}
-(void)audioContrilView:(TKAudioContrilView *)controlView draggedPositionEndWithSlider:(UISlider *)slider {
    
}
/**
 点击播放按钮
 
 @param controlView 控制视图
 @param button 播放按钮
 */
-(void)audioContrilView:(TKAudioContrilView *)controlView withPlayButton:(UIButton *)button{
    if (button.selected) {
        [self pause];
    }else{
        [self play];
        
    }

}
-(void)audioContrilView:(TKAudioContrilView *)controlView backButton:(UIButton *)backButton{
    if (self.delegate) {
        [self.delegate clickBakcButton];
        
    }

}
/**
 点击后退15s
 
 @param controlView <#controlView description#>
 @param backTimeButton <#backButton description#>
 */
-(void)audioContrilView:(TKAudioContrilView *)controlView backTimeButton:(UIButton *)backTimeButton{
    [self palyerGoBack];
    
}

/**
 点击前进15s
 
 @param controlView <#controlView description#>
 @param forwardTimeButton <#backButton description#>
 */
-(void)audioContrilView:(TKAudioContrilView *)controlView forwardTimeButton:(UIButton *)forwardTimeButton{
    [self palyerGoFowars];
    
}
//▶️🎵⏪15s
- (void)palyerGoBack{
    _afterCount = 0;
    CGFloat value = self.audioControlView.value-15;
    if (value<0) {
        value = 0;
    }
    
    if (_tryWatchTime&&value>=_tryWatchTime) {
        CMTime pointTime = CMTimeMake(_tryWatchTime * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
            
        }];
        self.playerTryWatchFinishView.hidden = NO;
        [self setSubViewsIsHide:NO];
        
    }else{
        CMTime pointTime = CMTimeMake(value * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
            
        }];
        
    }

}
//▶️🎵前进15s
- (void)palyerGoFowars{
    _afterCount = 0;
    CGFloat value = self.audioControlView.value+15;
    if (value>self.audioControlView.maxValue) {
        value = self.audioControlView.maxValue;
    }
    
    if (_tryWatchTime&&value>=_tryWatchTime) {
        CMTime pointTime = CMTimeMake(_tryWatchTime * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
            
        }];
        self.playerTryWatchFinishView.hidden = NO;
        [self setSubViewsIsHide:NO];
        
    }else{
        CMTime pointTime = CMTimeMake(value * self.item.currentTime.timescale, self.item.currentTime.timescale);
        [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            _isNeesReloadSlider = YES;
            
        }];
        
    }

}

//MARK: UIGestureRecognizer
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[SBControlView class]]||[touch.view isKindOfClass:[SBTitleView class]]) {
        return NO;
    }
    return YES;
}
//将数值转换成时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
//旋转方向
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight||orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown){
        //
        
    }
}

-(void)play{
    _afterCount = 0;

    if (self.player) {
        [self.player play];
    }
}
-(void)pause{
    _afterCount = 0;
    if (self.player) {
        [self.player pause];
    }
}
-(void)stop{
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:playbackTimerObserver];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    if (self.player) {
        [self pause];
        self.anAsset = nil;
        self.item = nil;
        if (_fileType == 3) {
            self.audioControlView.value = 0;

        }else{
            self.controlView.value = 0;
            self.controlView.currentTime = @"00:00";
            self.controlView.totalTime = @"00:00";

        }
        self.player = nil;
        self.activityIndeView = nil;
        [self removeFromSuperview];
    }
}
- (void)outFullScreen{
    [self interfaceOrientation:UIInterfaceOrientationPortrait];

}
//MARK: PlayerTryWatchFinishViewDelegate

- (void)replyButtonClick:(QMUIButton *)button{
    CMTime pointTime = CMTimeMake(0 * self.item.currentTime.timescale, self.item.currentTime.timescale);
    [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    if (_fileType == 3) {
        self.audioControlView.value = 0;
    }else{
        self.controlView.value = 0;

    }
    self.playerTryWatchFinishView.hidden = YES;
    [self play];

}
- (void)buyVipButtonClick:(QMUIButton *)button{
    if (_delegate) {
        [_delegate buyVipButtonClick:button];
    }
    
}
- (void)buyButtonClick:(QMUIButton *)button{
    
    if (_delegate) {
        [_delegate buyButtonClick:button];
    }

}
- (void)playerStateViewclickPlayButton{
    if (_delegate) {
        [_delegate clickStateViewPlayButton];
    }
    if (_status != SBPlayerStatusCanPlay) {
        if (!self.activityIndeView.isAnimating) {
            [self.activityIndeView startAnimating];
        }
    }
    [self play];
    if (_fileType == 3) {
        self.playerStateView.playButton.hidden = YES;
        [self sendSubviewToBack:self.playerStateView];

    }else{
        [self.playerStateView hiddenStateView];

    }
    
}
- (void)setTryWatchTime:(CGFloat)tryWatchTime{
    _tryWatchTime = tryWatchTime;

    if (tryWatchTime == 0) {
        self.playerTryWatchFinishView.hidden = YES;
        
    }
}
@end
