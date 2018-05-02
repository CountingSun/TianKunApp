//
//  CollectionListViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/18.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

typedef NS_ENUM(NSInteger,ViewType) {
    viewTypeNotice,
    viewTypePublic,
    viewTypeWork,
    viewTypePeople,
    viewTypeInteraction,
    viewTypeEducation,
    viewTypeCompany

};

@interface CollectionListViewController : WQBaseViewController

- (instancetype)initWithViewType:(ViewType)viewType;
- (void)beginEditWithEditButton:(UIButton *)editButton FinishBlock:(dispatch_block_t)block;


@end
