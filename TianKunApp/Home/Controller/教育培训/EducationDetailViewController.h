//
//  EducationDetailViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"


@interface EducationDetailViewController : WQBaseViewController

@property (nonatomic, copy) NSString *urlStr;
- (instancetype)initWithDocumentID:(NSInteger)documentID;

@end
