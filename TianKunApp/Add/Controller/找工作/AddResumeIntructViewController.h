//
//  AddResumeIntructViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/5.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface AddResumeIntructViewController : WQBaseViewController
@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);
@property (nonatomic, copy) NSString *textStr;
@property (nonatomic, copy) NSString *resumeID;

@end
