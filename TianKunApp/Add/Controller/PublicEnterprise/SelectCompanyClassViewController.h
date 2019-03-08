//
//  SelectCompanyClassViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class CompanyClassInfo;

@interface SelectCompanyClassViewController : WQBaseViewController

@property (nonatomic, copy) NSMutableArray *arrData;
@property (nonatomic, copy) void(^selectSucceedBlock)(CompanyClassInfo *companyClassInfo);
@end
