//
//  ExpertTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpertMessageInfo;


@interface ExpertTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *detailLabel;
@property (strong, nonatomic)  UIButton *lookAllButton;
@property (nonatomic ,strong) NSIndexPath *cellIndexPath;
@property (nonatomic ,strong) ExpertMessageInfo *messageInfo;
@property (nonatomic, copy) void(^clickLookAllButtonBlock)(NSIndexPath *cellIndexPath);

+(CGFloat)getCellHeightWithExpertMessageInfo:(ExpertMessageInfo *)expertMessageInfo;

@end
