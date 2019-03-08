//
//  MyPublicCooperationTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublicCooperationTableViewCell.h"
#import "CooperationInfo.h"

@implementation MyPublicCooperationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_editButton setImagePosition:QMUIButtonImagePositionLeft];
    [_editButton setImage:[UIImage imageNamed:@"user_center_edit"] forState:0];
    [_editButton setSpacingBetweenImageAndTitle:5];
    
    [_detailButton setImagePosition:QMUIButtonImagePositionLeft];
    [_detailButton setImage:[UIImage imageNamed:@"删除"] forState:0];
    [_detailButton setSpacingBetweenImageAndTitle:5];

    
}
- (IBAction)editButtonClick:(id)sender {
    
    if (_delegate) {
        [_delegate clickEditButtonWithIndexPath:_indexPath cooperationInfo:_cooperationInfo];
    }
}
- (IBAction)detailButtonClick:(id)sender {
    if (_delegate) {
        [_delegate clickDeleteButtonWithIndexPath:_indexPath cooperationInfo:_cooperationInfo];
    }

}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
}
- (void)setCooperationInfo:(CooperationInfo *)cooperationInfo{
    _cooperationInfo = cooperationInfo;
    _titleLabel.text = cooperationInfo.initiator;
    _detailLabel.text= cooperationInfo.content;

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
