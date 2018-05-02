//
//  EditPhoneViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface EditPhoneViewController : WQBaseViewController

@property (nonatomic, copy) dispatch_block_t succeedBlock;
/**
 <#Description#>

 @param type 1 旧手机号验证   2  绑定新手机号
 @return <#return value description#>
 */
- (instancetype)initWithType:(NSInteger)type userTel:(NSString *)userTel;

@end
