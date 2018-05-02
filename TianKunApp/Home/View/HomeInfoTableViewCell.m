//
//  HomeInfoTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeInfoTableViewCell.h"

@implementation HomeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _ccpView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-95, _baseView.qmui_height/2)];
    
    _ccpView.titleFont = 14;
    
    _ccpView.titleColor = [UIColor blackColor];
    
    _ccpView.BGColor = [UIColor whiteColor];
    
    [_ccpView clickTitleLabel:^(NSInteger index,NSString *titleString) {
        
        if (_clickWithIndexBlock) {
            _clickWithIndexBlock(index);
        }
        
    }];
    
    [_baseView addSubview:_ccpView];
    
    [_ccpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_baseView);
        make.height.offset(_baseView.qmui_height/2);
    }];
    
    
    
    
    _ccpView2 = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, _baseView.qmui_height/2, SCREEN_WIDTH-95, _baseView.qmui_height/2)];

    
    _ccpView2.titleFont = 14;
    
    _ccpView2.titleColor = [UIColor blackColor];
    
    _ccpView2.BGColor = [UIColor whiteColor];

    [_ccpView2 clickTitleLabel:^(NSInteger index,NSString *titleString) {
        
        if (_clickWithIndexBlock) {
            _clickWithIndexBlock(index);
        }

    }];
    
    [_baseView addSubview:_ccpView2];
    [_ccpView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_baseView);
        make.height.offset(_baseView.qmui_height/2);
    }];


}
- (void)setArrData:(NSMutableArray *)arrData{
    _arrData = arrData;
    _ccpView.titleArray = _arrData;
    
    NSMutableArray *arr2 = [_arrData mutableCopy];
    id objc = [arr2 firstObject];
    [arr2 removeObjectAtIndex:0];
    [arr2 addObject:objc];
    _ccpView2.titleArray = arr2;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
