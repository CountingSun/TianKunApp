//
//  MyVipCertificateTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVipCertificateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *certificateTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateTypeDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;

@property (nonatomic, copy) dispatch_block_t block;



@end
