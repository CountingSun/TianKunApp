//
//  FindTalentsViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"
@class JobInfo;

typedef void(^succeedBlock)(JobInfo *jobInfo);
@interface FindTalentsViewController : WQBaseViewController

@property (nonatomic, copy) succeedBlock succeedBlock;
- (instancetype)initWithJobInfo:(JobInfo *)jobInfo succeedBlock:(succeedBlock)succeedBlock;

@end
