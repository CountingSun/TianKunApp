//
//  MyPublicJobTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublicJobTableViewCell.h"
#import "JobInfo.h"

@implementation MyPublicJobTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
}
- (IBAction)editButtonClick:(id)sender {
    
    if (_delegate) {
        [_delegate clickEditButtonWithIndexPath:_indexPath jobInfo:_jobInfo];
    }
}
- (IBAction)detailButtonClick:(id)sender {
    if (_delegate) {
        [_delegate clickDeleteButtonWithIndexPath:_indexPath jobInfo:_jobInfo];
    }
    
}
- (IBAction)makeTopButtonClick:(id)sender {
    if (_delegate) {
        [_delegate clickmakeTopButtonWithIndexPath:_indexPath jobInfo:_jobInfo];
    }

}
- (void)setJobInfo:(JobInfo *)jobInfo{
    _jobInfo = jobInfo;
    self.titleLabel.text = jobInfo.enterprisename;
    self.nameLabel.text = jobInfo.name;
    self.detailLabel.text= jobInfo.work_describe;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
