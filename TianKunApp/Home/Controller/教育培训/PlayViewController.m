//
//  PlayViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PlayViewController.h"
#import "SBPlayer.h"
#import "AppDelegate.h"

@interface PlayViewController ()<SBPlayerDelegate>

@property (nonatomic,strong) SBPlayer *player;

@end


@implementation PlayViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate sharedAppDelegate].allowRotation = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppDelegate sharedAppDelegate].allowRotation = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player stop];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //纯代码请用此种方法
    //http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8 直播网址
    //初始化播放器
    self.player = [[SBPlayer alloc]initWithUrl:[NSURL URLWithString:@"http://download.3g.joy.cn/video/236/60236937/1451280942752_hd.mp4"]];
    self.player.delegate = self;
    
    //设置标题
    [self.player setTitle:@"这是一个长标题题题题题题题题题题题题题题题题题题题题题题题题题题题题题题题题题题题题"];
    //设置播放器背景颜色
    self.player.backgroundColor = [UIColor blackColor];
    //设置播放器填充模式 默认SBLayerVideoGravityResizeAspectFill，可以不添加此语句
    self.player.mode = SBLayerVideoGravityResizeAspectFill;
    //添加播放器到视图
    [self.view addSubview:self.player];
    self.player.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9);
}
- (void)clickBakcButton{
    if (_player.isFullScreen) {
        [_player outFullScreen];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
