//
//  CommentTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_commentButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setCommentInfo:(CommentInfo *)commentInfo{
    _commentInfo = commentInfo;
    
}
- (void)buttonClick{
    if (_clickButtonBlock) {
        _clickButtonBlock(_commentInfo);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
