//
//  AddressTableView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableView : UITableView

/**
 地址数组
 */
@property (nonatomic ,strong) NSMutableArray  *arrData;
@property (nonatomic, copy) void(^selectSucceedBlock)(NSMutableArray *arrResult);

/**
 是否是单选
 */
@property (nonatomic ,assign) BOOL isSingSelect;
@end
