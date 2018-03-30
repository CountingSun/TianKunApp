//
//  SelectJobTypeViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/30.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"
@class FilterInfo;

@interface SelectJobTypeViewController : WQBaseViewController
@property (nonatomic, copy) void(^selectJobSucceedBlock)(FilterInfo *first,FilterInfo *second);
@end
