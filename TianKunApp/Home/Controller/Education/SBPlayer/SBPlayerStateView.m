//
//  SBPlayerStateView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SBPlayerStateView.h"
@interface SBPlayerStateView()

@property (nonatomic ,strong) UIImageView *backImageView;


@end

@implementation SBPlayerStateView

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    
    _backImageView = [[UIImageView alloc]init];
    _backImageView.userInteractionEnabled = YES;
    [self addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:_playButton];
    [_playButton setImage:[UIImage imageNamed:@"player_state_play"] forState:0];
    _playButton.showsTouchWhenHighlighted = YES;
    [_playButton addTarget:self action:@selector(clickPlayButton) forControlEvents:UIControlEventTouchUpInside];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(40);
        make.centerX.offset(self.center.x);
        make.centerY.offset(self.center.y);
    }];
    
    
    
}

- (void)showBaceViewWithImageUrlStr:(NSString*)imageUrlStr{
    self.hidden = NO;
    [_backImageView sd_imageWithUrlStr:imageUrlStr placeholderImage:@"default21_fail_image"];
}
- (void)hiddenStateView{
    self.hidden = YES;
    
}

- (void)clickPlayButton{
 
    if(_delegate){
        [_delegate playerStateViewclickPlayButton];
        
    }
}







@end
