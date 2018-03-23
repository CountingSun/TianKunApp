//
//  HistoryBottomView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HistoryBottomView.h"

@implementation HistoryBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_selectButton setImagePosition:QMUIButtonImagePositionLeft];
    [_selectButton setSpacingBetweenImageAndTitle:5];
    [_selectButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [_selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectButton setTitle:@"取消全选" forState:UIControlStateSelected];

    [_clearnButton setBackgroundColor:COLOR_THEME];
}
@end
