//
//  CompanyDetailViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"
@class CompanyInfo;

@interface CompanyDetailViewController : WQBaseViewController

/**
 <#Description#>

 @param companyID <#companyID description#>
 @param type 2 是带图片的
 @return <#return value description#>
 */
- (instancetype)initWithCompanyID:(NSInteger)companyID type:(NSInteger)type;
- (instancetype)initWithCompanyID:(NSInteger)companyID;


@end
