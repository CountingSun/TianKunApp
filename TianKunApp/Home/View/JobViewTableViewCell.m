//
//  JobViewTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "JobViewTableViewCell.h"
#import "JobInfo.h"

@implementation JobViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setJobInfo:(JobInfo *)jobInfo{
    _jobInfo = jobInfo;
    
    [_jonImageView sd_setImageWithURL:[NSURL URLWithString:jobInfo.imageurl] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_11]];
    _jobNameLabel.text = jobInfo.name;
    _addressLabel.text = jobInfo.address;
    _typeLabel.text = [NSString stringWithFormat:@"%@|%@",_jobInfo.firstTypeName,_jobInfo.secondTypeName];
    _anotherLabel.text = [NSString stringWithFormat:@"正在招聘其他%@个职位",jobInfo.count];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
