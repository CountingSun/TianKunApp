//
//  SBView.h
//  SBPlayer
//
//  Created by sycf_ios on 2017/4/10.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SBCommonHeader.h"
#import "SBControlView.h"
#import "SBPauseOrPlayView.h"
#import "PlayerTryWatchFinishView.h"

#import "SBPlayerStateView.h"
#import "TKAudioContrilView.h"

@protocol SBPlayerDelegate <NSObject>


/**
 点击返回按钮
 */
- (void)clickBakcButton;

/**
 购买vip

 @param button <#button description#>
 */
- (void)buyVipButtonClick:(QMUIButton *)button;

/**
 购买视频

 @param button <#button description#>
 */
- (void)buyButtonClick:(QMUIButton *)button;

- (void)clickStateViewPlayButton;

- (void)palyerStatusLoaded;

@end

//横竖屏的时候过渡动画时间，设置为0.0则是无动画
#define kTransitionTime 0.2
//填充模式枚举值
typedef NS_ENUM(NSInteger,SBLayerVideoGravity){
    SBLayerVideoGravityResizeAspect,
    SBLayerVideoGravityResizeAspectFill,
    SBLayerVideoGravityResize,
};
//播放状态枚举值
typedef NS_ENUM(NSInteger,SBPlayerStatus){
    SBPlayerStatusFailed,
    SBPlayerStatusReadyToPlay,
    SBPlayerStatusUnknown,
    SBPlayerStatusBuffering,
    SBPlayerStatusCanPlay,
    SBPlayerStatusPlaying,
    SBPlayerStatusStopped,
};
@interface SBPlayer : UIView<SBControlViewDelegate,SBPauseOrPlayViewDelegate,UIGestureRecognizerDelegate,PlayerTryWatchFinishViewDelegate,SBPlayerStateViewDelegat>{
    id playbackTimerObserver;
}
//AVPlayer
@property (nonatomic,strong) AVPlayer *player;
//AVPlayer的播放item
@property (nonatomic,strong) AVPlayerItem *item;
//总时长
@property (nonatomic,assign) CMTime totalTime;
//当前时间
@property (nonatomic,assign) CMTime currentTime;
//资产AVURLAsset
@property (nonatomic,strong) AVURLAsset *anAsset;
//播放器Playback Rate
@property (nonatomic,assign) CGFloat rate;
//播放状态
@property (nonatomic,assign,readonly) SBPlayerStatus status;
//videoGravity设置屏幕填充模式，（只写）
@property (nonatomic,assign) SBLayerVideoGravity mode;
//是否正在播放
@property (nonatomic,assign,readonly) BOOL isPlaying;
//是否全屏
@property (nonatomic,assign,readonly) BOOL isFullScreen;
//设置标题
@property (nonatomic,copy) NSString *title;
//试看时间 为0的时候不限制
@property (nonatomic ,assign) CGFloat tryWatchTime;

@property (nonatomic,strong) TKAudioContrilView *audioControlView;

/**
 3 音频  4 视频
 */
@property (nonatomic ,assign) NSInteger fileType;

/**
 开始的视图
 */
@property (nonatomic,strong) SBPlayerStateView *playerStateView;

/**
 试看完成时展示的视图
 */
@property (nonatomic ,strong) PlayerTryWatchFinishView *playerTryWatchFinishView;

@property (nonatomic,weak) id<SBPlayerDelegate> delegate;

//与url初始化
-(instancetype)initWithUrl:(NSURL *)url;
//将播放url放入资产中初始化播放器
-(void)assetWithURL:(NSURL *)url;
//公用同一个资产请使用此方法初始化
-(instancetype)initWithAsset:(AVURLAsset *)asset;
//播放
-(void)play;
//暂停
-(void)pause;
//停止 （移除当前视频播放下一个或者销毁视频，需调用Stop方法）
-(void)stop;

/**
 退出全屏
 */
- (void)outFullScreen;
//▶️🎵⏪15s
- (void)palyerGoBack;
//▶️🎵前进15s
- (void)palyerGoFowars;

@end
