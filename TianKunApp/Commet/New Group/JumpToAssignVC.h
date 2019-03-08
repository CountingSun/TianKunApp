//
//  JumpToAssignVC.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JumpToAssignVC : NSObject
+(void)jumpToAssignVCWithDataID:(NSString *)dataID dataType:(NSInteger)dataType documentType:(NSInteger)documentType;
+ (UIViewController *)topViewController ;

@end
