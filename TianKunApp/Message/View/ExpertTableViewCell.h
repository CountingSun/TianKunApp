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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookAllButton;
@property (nonatomic ,strong) NSIndexPath *cellIndexPath;
@property (nonatomic ,strong) ExpertMessageInfo *messageInfo;
@property (nonatomic, copy) void(^clickLookAllButtonBlock)(NSIndexPath *cellIndexPath);
@end
