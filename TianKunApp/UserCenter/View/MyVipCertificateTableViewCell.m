//
//  MyVipCertificateTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyVipCertificateTableViewCell.h"

@implementation MyVipCertificateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)lookMallButtonClick:(id)sender {
    if (_block) {
        _block();
    }
}

@end
