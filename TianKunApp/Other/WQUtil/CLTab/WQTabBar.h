//
//  WQTabBar.h
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/9.
//  Copyright © 2017年 seek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQTabBar : UITabBar
@property (copy, nonatomic) void (^composeButtonClick)(void);

@end
