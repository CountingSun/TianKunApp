//
//  CompanyInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CompanyInfo.h"
#import "CompanyClassInfo.h"

@implementation CompanyInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{
      @"companyID":@"id",
      @"companySocialNum":@"social_credit_number",
      @"companyName":@"company_name",
      @"companyLegalRepresentative":@"legal_representative",
      @"companyType":@"company_type",
      @"companyAddress":@"business_address",
      @"companyCertification":@"company_certification",
      @"companyProject":@"engineering_project",

      };
    
}
-(CompanyClassInfo *)companyClassInfo{
    if (!_companyClassInfo) {
        _companyClassInfo = [[CompanyClassInfo alloc]init];
    }
    return _companyClassInfo;
}
@end

