//
//  FilterView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView

@property (nonatomic ,strong) NSMutableArray *arrData1;
@property (nonatomic ,strong) NSMutableArray *arrData2;

/**
 用来处理当前的点击状态 隐藏的时候是4
 */
@property (nonatomic ,assign) NSInteger state;
- (void)showFilterView;
- (void)hiddenFilterView;
- (BOOL)isShow;
- (BOOL)isShowWithAction;
- (void)reloadWithKey:(NSString *)key;

@end
