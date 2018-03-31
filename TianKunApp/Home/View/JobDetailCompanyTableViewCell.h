//
//  JobDetailCompanyTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyInfo;

@interface JobDetailCompanyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeDeaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic ,strong) CompanyInfo *companyInfo;
@property (nonatomic, copy) void(^clickPhoneLabelBlock)(NSString *phoneNumber);

@end
