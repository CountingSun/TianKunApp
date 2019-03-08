//
//  EducationTextListViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class DocumentPropertyInfo;

@interface EducationTextListViewController : WQBaseViewController
- (void)reloadWithDocumentPropertyInfo:(DocumentPropertyInfo *)documentPropertyInfo;

@end
