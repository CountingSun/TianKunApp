//
//  FindJodDetailViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class ResumeInfo;

@interface FindJodDetailViewController : WQBaseViewController
//@property (nonatomic ,strong) ResumeInfo *resumeInfo;
- (instancetype)initWithResumeID:(NSString *)resumeID;

@property (nonatomic ,assign) NSInteger viewType;
@end
