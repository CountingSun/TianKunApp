//
//  DetailListViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class CompanyInfo,BlackListInfo,ProjectInfo,ChangeInfo,SpecialBehaviorInfo,AptitudeInfo,PeopleInfo;

@interface DetailListViewController : WQBaseViewController
@property (nonatomic ,strong) CompanyInfo *companyInfo;
@property (nonatomic ,strong) BlackListInfo *blackListInfo;
@property (nonatomic ,strong) ProjectInfo *projectInfo;
@property (nonatomic ,strong) ChangeInfo *changeInfo;
@property (nonatomic ,strong) SpecialBehaviorInfo *specialBehaviorInfo;
@property (nonatomic ,strong) AptitudeInfo *aptitudeInfo;
@property (nonatomic ,strong) PeopleInfo *peopleInfo;

@property (nonatomic, copy) NSString *viewTitle;
@end
