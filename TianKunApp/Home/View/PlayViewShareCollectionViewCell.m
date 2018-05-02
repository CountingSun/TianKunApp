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
    CGSize textSize = [documentInfo.data_title boundingRectWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)];
    
    _titleLabel.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, textSize.height);

}
+ (CGSize)getCellHeightWithDocumentInfo:(DocumentInfo *)documentInfo {
    CGSize textSize = [documentInfo.data_title boundingRectWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)];

    return CGSizeMake(SCREEN_WIDTH, textSize.height+60);
}
- (IBAction)shareButtonClock:(id)sender {
    [AppShared shared];
}
@end
