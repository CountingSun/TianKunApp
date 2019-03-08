//
//  ExpertTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ExpertTableViewCell.h"
#import "ExpertMessageInfo.h"

#define TimeLabelHeight 40

@implementation ExpertTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TimeLabelHeight)];
    _timeLabel.textColor = COLOR_TEXT_LIGHT;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_timeLabel];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = COLOR_TEXT_BLACK;
    _titleLabel.font = [UIFont systemFontOfSize:17];

    [self.contentView addSubview:_titleLabel];
    
    
    
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 138)];
    _detailLabel.textColor = COLOR_TEXT_LIGHT;
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:_detailLabel];
    
    _lookAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_lookAllButton];
    [_lookAllButton setBackgroundColor:[UIColor whiteColor]];
    [_lookAllButton setTitleColor:COLOR_THEME forState:0];
    _lookAllButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_lookAllButton setTitleColor:COLOR_THEME forState:0];
    [_lookAllButton addTarget:self action:@selector(lookAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _cellIndexPath = indexPath;
    
}
- (void)setMessageInfo:(ExpertMessageInfo *)messageInfo{
    
    _messageInfo = messageInfo;

    _detailLabel.text = messageInfo.messageDetail;
    _titleLabel.text = messageInfo.messageTitle;
    _timeLabel.text = [NSString timeReturnDateString:messageInfo.messageTime formatter:@"yyyy-MM-dd HH:mm"];
    
    
    CGSize titleSize = [messageInfo.messageTitle boundingRectWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)];
    
    CGFloat contentHeght = 0.0;
    
    CGSize contentSize = [messageInfo.messageDetail boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)];
    if (messageInfo.isOpen) {
        contentHeght = contentSize.height;
    }else{
        if (contentSize.height <= 33.5) {
            contentHeght = contentSize.height;
            _lookAllButton.hidden = YES;
        }else{
            contentHeght = 33.5;
        }
    }
    
    _titleLabel.frame = CGRectMake(10, TimeLabelHeight+10, SCREEN_WIDTH-20, titleSize.height);
    
    _detailLabel.frame = CGRectMake(10, CGRectGetMaxY(_titleLabel.frame)+10, SCREEN_WIDTH-20, contentHeght);
    if (_messageInfo.isOpen) {
        [_lookAllButton setTitle:@"收起" forState:0];
        _detailLabel.numberOfLines = 0;
        _lookAllButton.frame = CGRectMake(SCREEN_WIDTH - 90 - 10, CGRectGetMaxY(_detailLabel.frame)+5, 90, 20);
        
        
    }else{
        [_lookAllButton setTitle:@"查看全部" forState:0];
        _detailLabel.numberOfLines = 2;
        _lookAllButton.frame = CGRectMake(SCREEN_WIDTH - 90 - 10, CGRectGetMaxY(_detailLabel.frame)-17, 90, 20);

    }



}
- (void)lookAllButtonClick:(UIButton *)sender {
    _messageInfo.isOpen =! _messageInfo.isOpen;
    
    if (_clickLookAllButtonBlock) {
        _clickLookAllButtonBlock (_cellIndexPath);
    }
    
}

+ (CGFloat)getCellHeightWithExpertMessageInfo:(ExpertMessageInfo *)expertMessageInfo{
    
    CGSize titleSize = [expertMessageInfo.messageTitle boundingRectWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)];
    
    CGFloat contentHeght = 0.0;
    
    CGSize contentSize = [expertMessageInfo.messageDetail boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)];
    if (expertMessageInfo.isOpen) {
        contentHeght = contentSize.height +25;
    }else{
        if (contentSize.height <= 33.5) {
            contentHeght = contentSize.height;
        }else{
            contentHeght = 33.5;
        }
    }
    return TimeLabelHeight + titleSize.height + contentHeght+ 30;
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
