//
//  FilterTableView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterInfo;

@interface FilterTableView : UITableView
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic, copy) void(^selectTableViewBlock)(FilterInfo *filterInfo);

@end
