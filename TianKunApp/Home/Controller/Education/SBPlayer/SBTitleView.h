//
//  SBTitleView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface SBTitleView : UIView
@property (nonatomic ,strong) MarqueeLabel *titleLabel;
@property (nonatomic ,strong) QMUIButton *backButton;
@property (nonatomic, copy) dispatch_block_t backBlcok;
@end
