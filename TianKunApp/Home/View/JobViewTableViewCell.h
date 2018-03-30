//
//  JobViewTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JobInfo;

@interface JobViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *jonImageView;
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotherLabel;
@property (nonatomic ,strong) JobInfo *jobInfo;
@end
