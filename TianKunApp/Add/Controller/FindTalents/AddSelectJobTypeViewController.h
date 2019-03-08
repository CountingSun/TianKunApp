//
//  AddSelectJobTypeViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class ClassTypeInfo;

@interface AddSelectJobTypeViewController : WQBaseViewController

@property (nonatomic, copy) void(^selectSucceedBlock)(ClassTypeInfo *classTypeInfo);
- (instancetype)initWithClassTypeInfo:(ClassTypeInfo *)classTypeInfo;


@end
