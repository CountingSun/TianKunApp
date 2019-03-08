//
//  PlayerTryWatchFinishView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/11.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerTryWatchFinishViewDelegate <NSObject>

- (void)replyButtonClick:(QMUIButton *)button;
- (void)buyVipButtonClick:(QMUIButton *)button;
- (void)buyButtonClick:(QMUIButton *)button;
- (void)backButtonClick:(QMUIButton *)button;


@end;


@interface PlayerTryWatchFinishView : UIView
@property (weak, nonatomic) IBOutlet UILabel *introctLabel;

@property (weak, nonatomic) IBOutlet QMUIButton *replayButton;
@property (weak, nonatomic) IBOutlet QMUIButton *buyVipButton;
@property (weak, nonatomic) IBOutlet QMUIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, weak) id<PlayerTryWatchFinishViewDelegate> delegate;


@end
