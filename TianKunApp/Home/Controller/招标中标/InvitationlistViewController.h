//
//  InvitationlistViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"
@class ClassTypeInfo;

@interface InvitationlistViewController : WQBaseViewController

/**
 <#Description#>

 @param classTypeInfo <#classTypeInfo description#>
 @param type 1招标2中标
 @return <#return value description#>
 */
- (instancetype)initWithClassTypeInfo:(ClassTypeInfo *)classTypeInfo type:(NSInteger)type;

@end
