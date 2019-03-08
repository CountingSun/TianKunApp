//
//  EducationTextTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationTextTableViewCell.h"
#import "DocumentInfo.h"

@implementation EducationTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleImageView.layer.masksToBounds = YES;
    
}
- (void)setDocumentInfo:(DocumentInfo *)documentInfo{
    _documentInfo = documentInfo;
    _titleLabel.text = documentInfo.data_title;
    if (documentInfo.is_charge) {
        _moneyLabel.text = [NSString stringWithFormat:@"￥%@",@(documentInfo.money)];
        
    }else{
        _moneyLabel.text = @"免费";
    }
    if (![ISVipManager isOpenVip]) {
        _moneyLabel.hidden = YES;
    }

    NSString *urlStr = [documentInfo.video_image_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    [_titleImageView sd_imageDef21WithUrlStr:urlStr];
    
    _lookNumLabel.text = [NSString stringWithFormat:@"%@观看",@(documentInfo.hits_show)];
    _timeLabel.text = [NSString timeReturnDateString:documentInfo.create_date formatter:@"yyyy-MM-dd"];
    _detailLabel.text = documentInfo.synopsis;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
