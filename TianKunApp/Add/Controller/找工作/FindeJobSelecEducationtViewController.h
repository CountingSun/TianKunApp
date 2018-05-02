//
//  FindeJobSelecEducationtViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"
@class MenuInfo;

@interface FindeJobSelecEducationtViewController : WQBaseViewController

@property (nonatomic, copy) void(^selectSucceedBlock)(MenuInfo *menuInfo);

@end
