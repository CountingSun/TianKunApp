//
//  PlayViewAuthorCollectionViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PlayViewAuthorCollectionViewCell.h"
#import "DocumentInfo.h"

@implementation PlayViewAuthorCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_lookAllButton addTarget:self action:@selector(lookAllButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _introctLabel.textColor = COLOR_TEXT_LIGHT;
    [_lookAllButton setTitleColor:COLOR_THEME forState:0];
}
- (void)setDocumentInfo:(DocumentInfo *)documentInfo{
    _documentInfo = documentInfo;
    NSString *url = [_documentInfo.author_picture_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];

    [_headImageView sd_imageWithUrlStr:url placeholderImage:@"头像"];
    _nameLabel.text = _documentInfo.author;
    _introctLabel.text = _documentInfo.author_introduce;

    _headImageView.frame = CGRectMake(15, 10, 60, 60);
    _nameLabel.frame =CGRectMake(CGRectGetMaxX(_headImageView.frame)+10, 10, SCREEN_WIDTH-CGRectGetMaxX(_headImageView.frame)-10-15, 60);

    _introctLabel.text = documentInfo.author_introduce;
    
    CGSize textSize = [documentInfo.author_introduce boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)];
    
    if (textSize.height>34.0f) {
        if (_isShowAll) {
            _lookAllButton.hidden = YES;
            _introctLabel.frame = CGRectMake(15, 80, SCREEN_WIDTH-30, textSize.height);
        }else{
            _lookAllButton.hidden = NO;
            _lookAllButton.frame = CGRectMake(SCREEN_WIDTH-60-15, 97, 60, 17);
            _introctLabel.frame = CGRectMake(15, 80, SCREEN_WIDTH-30, 34);
            [self.contentView bringSubviewToFront:_lookAllButton];
        }
    }else{
        _lookAllButton.hidden = YES;
        _introctLabel.frame = CGRectMake(15, 80, SCREEN_WIDTH-30, textSize.height);
    }

    [self layoutIfNeeded];
    
}
+ (CGSize)getCellHeightWithDocumentInfo:(DocumentInfo *)documentInfo isShowAll:(BOOL)isShowAll{
    CGSize textSize = [documentInfo.author_introduce boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)];
    CGFloat otherH = 90;
    
    if (textSize.height>34.0f) {
        if (isShowAll) {
            return CGSizeMake(SCREEN_WIDTH, textSize.height+otherH);
        }else{
            return CGSizeMake(SCREEN_WIDTH, 34+otherH);
        }
    }else{
        return CGSizeMake(SCREEN_WIDTH, textSize.height+otherH);
    }
}
- (void)setIsShowAll:(BOOL)isShowAll{
    _isShowAll = isShowAll;
}
- (void)lookAllButtonClick{
    _lookAllButton.hidden = YES;
    if (_reloadCellBlock) {
        _reloadCellBlock();
    }
    
    
}
@end
