//
//  BusinessLicenseViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

typedef void(^succeedBlock)(NSString *urlStr);

@interface BusinessLicenseViewController : WQBaseViewController
@property (nonatomic, copy) succeedBlock succeedBlock;
- (instancetype)initWithImageUrl:(NSString *)imageUrl succeedBlock:(succeedBlock)succeedBlock;
- (instancetype)initWithUserInfo:(UserInfo *)userInfo succeedBlock:(succeedBlock)succeedBlock;

@property (nonatomic ,assign) BOOL canEdit;
@end
