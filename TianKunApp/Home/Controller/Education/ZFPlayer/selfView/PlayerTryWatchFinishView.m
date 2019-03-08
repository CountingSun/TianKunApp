//
//  PlayerTryWatchFinishView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/11.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PlayerTryWatchFinishView.h"
#import "ZFPlayer.h"

@implementation PlayerTryWatchFinishView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = UIColorMask;
    
    _replayButton.layer.masksToBounds = YES;
    _replayButton.layer.cornerRadius =  _replayButton.qmui_height/2;
    [_replayButton setBackgroundColor:UIColorMask];
    
    _buyVipButton.layer.masksToBounds = YES;
    _buyVipButton.layer.cornerRadius =  _buyVipButton.qmui_height/2;
    [_buyVipButton setBackgroundColor:COLOR_THEME];
    [_backButton setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];

    
    

}
- (IBAction)replayButtonClick:(id)sender {
    if (_delegate) {
        [_delegate replyButtonClick:sender];
    }
}
- (IBAction)buyVipButtonClick:(id)sender {
    if (_delegate) {
        [_delegate buyVipButtonClick:sender];
    }
}

- (IBAction)buyButtonClick:(id)sender {
    if (_delegate) {
        [_delegate buyButtonClick:sender];
    }
}
- (IBAction)backButtonClick:(id)sender {
    if (_delegate) {
        [_delegate backButtonClick:sender];
    }

}

@end
