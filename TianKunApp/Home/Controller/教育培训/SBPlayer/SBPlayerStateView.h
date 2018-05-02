//
//  SBPlayerStateView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SBPlayerStateViewDelegat <NSObject>
- (void)playerStateViewclickPlayButton;


@end

@interface SBPlayerStateView : UIView

@property (nonatomic,weak) id<SBPlayerStateViewDelegat> delegate;

- (void)showBaceViewWithImageUrlStr:(NSString*)imageUrlStr;

- (void)hiddenStateView;



@end
