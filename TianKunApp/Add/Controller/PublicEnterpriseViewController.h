//
//  PublicEnterpriseViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class CompanyInfo;

@interface PublicEnterpriseViewController : WQBaseViewController

@property (nonatomic, copy) void(^EditSucceedBlock)(CompanyInfo *companyInfo);
@end
