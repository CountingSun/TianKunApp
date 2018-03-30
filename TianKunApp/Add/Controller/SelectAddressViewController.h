//
//  SelectAddressViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"
@class FilterInfo;

@interface SelectAddressViewController : WQBaseViewController

@property (nonatomic, copy) void(^ selectSucceedBlock)(FilterInfo *provinceInfo,FilterInfo *cityInfo);
@end
