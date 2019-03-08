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
    _loopScrollView1 = [FSLoopScrollView loopTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-95, _baseView.qmui_height/2) isTitleView:YES titleImgArr:nil];
    __weak typeof(self) weakSelf = self;
//    _loopScrollView1.titlesArr = @[@""];

    _loopScrollView1.tapClickBlock = ^(FSLoopScrollView *loopView) {
        
        
        if (weakSelf.clickWithIndexBlock) {
            weakSelf.clickWithIndexBlock(loopView.currentIndex);
        }
    };
    
    [_baseView addSubview:_loopScrollView1];
    
    _loopScrollView2 = [FSLoopScrollView loopTitleViewWithFrame:CGRectMake(0, _baseView.qmui_height/2, SCREEN_WIDTH-95, _baseView.qmui_height/2) isTitleView:YES titleImgArr:nil];
    _loopScrollView2.tapClickBlock = ^(FSLoopScrollView *loopView) {
        if (weakSelf.clickWithIndexBlock) {
            NSInteger idx = 0;
            
            if (loopView.currentIndex == _arrData.count-1) {
                idx =  0;
            }else{
                idx = loopView.currentIndex+1;
            }
            weakSelf.clickWithIndexBlock(idx);
        }
    };
    
//    _loopScrollView2.titlesArr = @[@""];

    [_baseView addSubview:_loopScrollView2];

    
    _mainImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMainImage)];
    [_mainImageView addGestureRecognizer:tap];
    
    
    

}
- (void)tapMainImage{
 
    if (_clickMainImageBlock) {
        _clickMainImageBlock();
    }
}
- (void)setArrData:(NSMutableArray *)arrData{
    
    if (arrData.count) {
        _loopScrollView1.hidden = NO;
        _loopScrollView2.hidden = NO;

        _arrData = arrData;
        _loopScrollView1.titlesArr = _arrData;
        
        NSMutableArray *arr2 = [_arrData mutableCopy];
        id objc = [arr2 firstObject];
        [arr2 removeObjectAtIndex:0];
        [arr2 addObject:objc];
        _loopScrollView2.titlesArr = arr2;

    }else{
        _loopScrollView1.hidden = YES;
        _loopScrollView2.hidden = YES;
        
    }
        

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
