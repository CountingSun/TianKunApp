//
//  JobIntroduceViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface JobIntroduceViewController : WQBaseViewController

@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);
@property (nonatomic, copy) NSString *textStr;
@end
