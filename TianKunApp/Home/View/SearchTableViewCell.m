//
//  SearchTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = COLOR_VIEW_BACK;
        
        [self initCellView];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLab.text = dataDic[@"KeyWord"];
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.liShiImg];
    [self.contentView addSubview:self.deleBtn];
    
    [self.liShiImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_offset(16);
        make.height.mas_offset(16);

    }];
    [self.deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(15);
        make.width.mas_offset(12);
        make.height.mas_offset(12);
        
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(15);

        make.height.mas_offset(14);
        
    }];

}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = COLOR_TEXT_BLACK;
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}
- (UIImageView *)liShiImg {
    if (!_liShiImg) {
        _liShiImg = [UIImageView new];
        _liShiImg.image = [UIImage imageNamed:@"lishi"];
    }
    return _liShiImg;
}
- (UIButton *)deleBtn {
    if (!_deleBtn) {
        _deleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleBtn setImage:[UIImage imageNamed:@"closez"] forState:UIControlStateNormal];
        [_deleBtn setTintColor:COLOR_TEXT_BLACK];
        _deleBtn.hidden = YES;
    }
    return _deleBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
