//
//  PlayViewIntroctCollectionViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PlayViewIntroctCollectionViewCell.h"

@implementation PlayViewIntroctCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setDetailString:(NSString *)detailString{
    CGSize size = [detailString boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 55, CGFLOAT_MAX)];
    _detailLabel.text = detailString;
    _detailLabel.frame = CGRectMake(40, CGRectGetMaxY(_iconImageView.frame)+10, SCREEN_WIDTH-55, size.height);
    _linLabel.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+10, 2, size.height);
    

}
+ (CGSize)getCellHeightWithDetailString:(NSString *)detailString{
    CGSize size = [detailString boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 55, CGFLOAT_MAX)];
    return CGSizeMake(SCREEN_WIDTH, size.height +55 );
}
@end
