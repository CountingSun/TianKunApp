//
//  MessageListTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MessageListTableViewCell.h"

@implementation MessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _unReadPoint.layer.masksToBounds = YES;
    _unReadPoint.layer.cornerRadius =  _unReadPoint.qmui_width/2;
}
- (void)setUnReadCount:(NSInteger)unReadCount{
    if (unReadCount == 0) {
        _unReadPoint.hidden = YES;
    }else{
        _unReadPoint.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
