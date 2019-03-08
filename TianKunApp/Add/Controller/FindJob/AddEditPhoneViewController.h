//
//  AddEditPhoneViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/16.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface AddEditPhoneViewController : WQBaseViewController


@property (nonatomic, copy) void(^succeedBlock)(NSString *phone);
@end
