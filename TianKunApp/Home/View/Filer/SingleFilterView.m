//
//  SingleFilterView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/17.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SingleFilterView.h"
#import "FilterInfo.h"
#import "UIView+Extension.h"
#import "UIView+AddTapGestureRecognizer.h"

@interface SingleFilterView()<UIGestureRecognizerDelegate>


@end

@implementation SingleFilterView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorMask;
        [self setupUI];
    }
    return self;
    
}
- (void)setupUI{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenFilterView)];
    tap.delegate=self;//这句不要漏掉
    [self addGestureRecognizer:tap];
    
    _firsetTableView = [[FilterTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.qmui_height) style:UITableViewStylePlain];
    [self addSubview:_firsetTableView];
    
    __weak typeof(self) weakSelf = self;
    
    _firsetTableView.selectTableViewBlock = ^(FilterInfo *filterInfo) {
        if(weakSelf.firseSelectBlock){
            weakSelf.firseSelectBlock(filterInfo);
        }
    };
    
    
    
}
- (void)showFilterView{
    self.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat h = NavigationBarHeight;
        self.height = SCREEN_HEIGHT-h-40;

        _firsetTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-h-40);
        
    } completion:^(BOOL finished) {
    }];
    
}
- (void)hiddenFilterView{
    _state = 4;
    [UIView animateWithDuration:0.3 animations:^{
        self.height = 0;
        _firsetTableView.frame = CGRectMake(0, 0,SCREEN_WIDTH, 0);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (BOOL)isShow{
    if (self.hidden ||self.height == 0) {
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)isShowWithAction{
    if (self.hidden) {
        [self showFilterView];
        return NO;
    }else{
        [self hiddenFilterView];
        return YES;
        
    }
    
}
- (void)setArrData1:(NSMutableArray *)arrData1{
    _firsetTableView.arrData = arrData1;
}
#pragma mark-手势代理，解决和tableview点击发生的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

@end
