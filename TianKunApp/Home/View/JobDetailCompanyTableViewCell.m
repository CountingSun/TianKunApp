//
//  JobDetailCompanyTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "JobDetailCompanyTableViewCell.h"
#import "CompanyInfo.h"
#import "UIView+AddTapGestureRecognizer.h"
@implementation JobDetailCompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCompanyInfo:(CompanyInfo *)companyInfo{
    _companyInfo = companyInfo;
    _nameLabel.text = companyInfo.companyName;
    _addressLabel.text = companyInfo.companyAddress;
    _contentLabel.text = [NSString stringWithFormat:@"%@:",companyInfo.contacts];
    _phoneLabel.text = companyInfo.phone;

    _typeLabel.text = _companyInfo.firstTypeName;
    _typeDeaiLabel.text = _companyInfo.secondTypeName;
    _phoneLabel.userInteractionEnabled = YES;
    [_contentImageView sd_imageDef11WithUrlStr:companyInfo.picture_url];
    [_phoneLabel addTapGestureRecognizerWithActionBlock:^{
        if (_clickPhoneLabelBlock) {
            _clickPhoneLabelBlock(companyInfo.phone);
            
        }
    }];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
