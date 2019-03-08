//
//  FileSearchViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"
typedef NS_ENUM(NSInteger,FileSearchType) {
    FileSearchTypePublic,
    FileSearchTypeNotice,
    FileSearchTypeInvitation,
    FileSearchTypeWin,
    FileSearchTypeIndustry

    

};
@interface FileSearchViewController : WQBaseViewController
- (instancetype)initWithFromType:(FileSearchType)fileSearchType;
@end
