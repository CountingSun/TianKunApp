//
//  EducationTextTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DocumentInfo;

@interface EducationTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic ,strong) DocumentInfo *documentInfo;

@end
