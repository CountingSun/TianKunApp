//
//  SingleFilterView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/17.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTableView.h"

@class FilterInfo;

@interface SingleFilterView : UIView
@property (nonatomic ,strong) NSMutableArray *arrData1;
@property (nonatomic ,copy) void(^firseSelectBlock)(FilterInfo *filterInfo);
@property (nonatomic ,strong) FilterTableView *firsetTableView;
/**
 用来处理当前的点击状态 隐藏的时候是4
 */
@property (nonatomic ,assign) NSInteger state;
- (void)showFilterView;
- (void)hiddenFilterView;
- (BOOL)isShow;
- (BOOL)isShowWithAction;

@end
