//
//  PlayViewShareCollectionViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PlayViewShareCollectionViewCell.h"
#import "DocumentInfo.h"
#import "AppShared.h"

@implementation PlayViewShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_shareButton setImagePosition:QMUIButtonImagePositionLeft];
    [_shareButton setSpacingBetweenImageAndTitle:5];
    [_collectButton setImagePosition:QMUIButtonImagePositionLeft];
    [_collectButton setSpacingBetweenImageAndTitle:5];
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];

    
}
- (void)setDocumentInfo:(DocumentInfo *)documentInfo{
    _documentInfo = documentInfo;

    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",@(_documentInfo.money)];
    CGSize moneySize = [_moneyLabel.text boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, CGFLOAT_MAX)];
    
    CGSize textSize = [_documentInfo.data_title boundingRectWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH-20-moneySize.width-10, CGFLOAT_MAX)];
    _titleLabel.frame = CGRectMake(10, 10, textSize.width, textSize.height);
    _moneyLabel.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, 10, moneySize.width, 20);

    _titleLabel.text = _documentInfo.data_title;
   _timeLabel.text = [NSString timeReturnDateString:_documentInfo.create_date formatter:@"MM月dd日"];
    if (_documentInfo.previous_format.length) {
        _publicLabel.text = [NSString stringWithFormat:@"发布者：%@",_documentInfo.previous_format];
        
    }
    if (_documentInfo.collectID) {
       _collectButton.selected = YES;
        
    }else{
       _collectButton.selected = NO;
    }

    
}
+ (CGSize)getCellHeightWithDocumentInfo:(DocumentInfo *)documentInfo {
    NSString *str = [NSString stringWithFormat:@"￥%@",@(documentInfo.money)];
    CGSize moneySize = [str boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, CGFLOAT_MAX)];
    
    CGSize textSize = [documentInfo.data_title boundingRectWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH-20-moneySize.width-10,CGFLOAT_MAX)];

    return CGSizeMake(SCREEN_WIDTH, textSize.height+60);
}
- (IBAction)shareButtonClock:(id)sender {
    NSString * imageUrlStr = [_documentInfo.video_image_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    id images;
    if (imageUrlStr.length) {
        images = @[imageUrlStr];
        
    } else {
        images = [UIImage imageNamed:@"AppIcon"];
    }

    [AppShared shareParamsByText:_documentInfo.synopsis images:images url:DEFAULT_SHARE_URL title:_documentInfo.data_title];
}
@end
