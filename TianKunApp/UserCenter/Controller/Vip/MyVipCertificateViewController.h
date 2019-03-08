//
//  MyVipCertificateViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class CertificateInfo;

@interface MyVipCertificateViewController : WQBaseViewController
- (instancetype)initWithType:(NSInteger)type certificateInfo:(CertificateInfo *)certificateInfo;

@end
