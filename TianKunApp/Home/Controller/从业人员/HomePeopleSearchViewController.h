//
//  HomePeopleSearchViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface HomePeopleSearchViewController : WQBaseViewController
@property (nonatomic, copy) void (^sureButtonClickBlock)(NSString *nameStr,NSString *numStr,NSString *firsetStr,NSString *secondStr);
@end
