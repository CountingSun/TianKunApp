//
//  ExpertTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ExpertTableViewCell.h"
#import "ExpertMessageInfo.h"

@implementation ExpertTableViewCell

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _cellIndexPath = indexPath;
    
}
- (void)setMessageInfo:(ExpertMessageInfo *)messageInfo{
    
    _messageInfo = messageInfo;
    if (_messageInfo.isOpen) {
        _lookAllButton.hidden = YES;
        _detailLabel.numberOfLines = 0;
        
    }else{
        _lookAllButton.hidden = NO;
        _detailLabel.numberOfLines = 2;

    }
    _detailLabel.text = messageInfo.messageDetail;
    _titleLabel.text = messageInfo.messageTitle;
    _timeLabel.text = messageInfo.messageTime;
    

}
- (void)awakeFromNib {
    [super awakeFromNib];
    _detailLabel.textColor = COLOR_TEXT_LIGHT;
    self.contentView.backgroundColor = COLOR_VIEW_BACK;
    [_lookAllButton setTitleColor:COLOR_THEME forState:0];
}
- (IBAction)lookAllButtonClick:(UIButton *)sender {
    if (_clickLookAllButtonBlock) {
        _messageInfo.isOpen = YES;
        _clickLookAllButtonBlock (_cellIndexPath);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
