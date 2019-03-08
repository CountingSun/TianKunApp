//
//  AddBusinessCooperationViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class CooperationInfo;

typedef void(^EditCooperationInfoSucceedBlock)(CooperationInfo *cooperationInfo);
@interface AddBusinessCooperationViewController : WQBaseViewController

@property (nonatomic, copy) EditCooperationInfoSucceedBlock succeedBlock;
- (instancetype)initWithCooperationInfo:(CooperationInfo *)cooperationInfo succeedBlock:(EditCooperationInfoSucceedBlock)succeedBlock;

@end
