//
//  MyPublicInteractionListTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/14.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublicInteractionListTableViewCell.h"
#import "InteractionInfo.h"

@implementation MyPublicInteractionListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setInteractionInfo:(InteractionInfo *)interactionInfo{
    _interactionInfo = interactionInfo;
    
    self.titleLabel.text = interactionInfo.title;
    self.contentLabel.text = interactionInfo.content;
    self.timeLabel.text = [NSString timeReturnDateString:interactionInfo.create_date formatter:@"MM-dd"];
    self.lookLabel.text = [NSString stringWithFormat:@"%@",@(interactionInfo.hits_show)];
    self.commentLabel.text = [NSString stringWithFormat:@"%@",@(interactionInfo.hfnum)];

}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
}
- (IBAction)deleButtonClick:(id)sender {
    if (_delegate) {
        [_delegate deleteInteractionWithInteractionInfo:_interactionInfo indexPath:_indexPath];
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
