//
//  UserInfoEditTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UserInfoEditTableViewCell.h"

@implementation UserInfoEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textField addTarget:self action:@selector(editChange) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)setEditBlock:(editBlock)editBlock{
    _editBlock = editBlock;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (void)editChange{
    if (_editBlock) {
        _editBlock(_textField.text,_indexPath);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
