//
//  FilterView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FilterView.h"
#import "FilterTableView.h"
#import "FilterInfo.h"
#import "UIView+Extension.h"
#import "UIView+AddTapGestureRecognizer.h"
@interface FilterView()<UIGestureRecognizerDelegate>

@property (nonatomic ,strong) FilterTableView *firsetTableView;
@property (nonatomic ,strong) FilterTableView *secondTableView;

@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(1, 1, 1, 0.3);
        [self setupUI];
    }
    return self;
    
}
- (void)getData1{
    if (!_arrData1) {
        _arrData1 = [NSMutableArray array];
    }
    [_arrData1 removeAllObjects];
    
    for (NSInteger i = 1; i<5+arc4random() % 10; i++) {
        FilterInfo *filterInfo = [[FilterInfo alloc]init];
        filterInfo.propertyName = [NSString stringWithFormat:@"一级属性%@",@(i)];
        filterInfo.propertyID = [NSString stringWithFormat:@"%@",@(i)];
        [_arrData1 addObject:filterInfo];
        
    }
    
    [self getData2];
    

}
- (void)getData2{
    if (!_arrData2) {
        _arrData2 = [NSMutableArray array];
    }
    
    [_arrData2 removeAllObjects];
    
    for (NSInteger i = 1; i<3+arc4random() % 5; i++) {
        FilterInfo *filterInfo = [[FilterInfo alloc]init];
        filterInfo.propertyName = [NSString stringWithFormat:@"二级属性%@",@(i)];
        filterInfo.propertyID = [NSString stringWithFormat:@"%@",@(i)];
        [_arrData2 addObject:filterInfo];
        
    }
    _firsetTableView.arrData = _arrData1;
    _secondTableView.arrData = _arrData2;
    
    
}

- (void)setupUI{
    [self getData1];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenFilterView)];
    tap.delegate=self;//这句不要漏掉
    [self addGestureRecognizer:tap];

    
    
    _firsetTableView = [[FilterTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, self.qmui_height) style:UITableViewStylePlain];
    [self addSubview:_firsetTableView];
    _firsetTableView.selectTableViewBlock = ^(FilterInfo *filterInfo) {
        
    };
    
    _firsetTableView.arrData = _arrData1;
    
    
    _secondTableView = [[FilterTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, self.qmui_height) style:UITableViewStylePlain];
    _secondTableView.arrData = _arrData2;
    [self addSubview:_secondTableView];

    __weak typeof(self) weakSelf = self;
    
    _secondTableView.selectTableViewBlock = ^(FilterInfo *filterInfo) {
        [weakSelf hiddenFilterView];
    };


}
- (void)showFilterView{
    self.hidden = NO;

    [UIView animateWithDuration:0.3 animations:^{
        self.height = SCREEN_HEIGHT-40;
        _firsetTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT-40);
        _secondTableView.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT-40);

    } completion:^(BOOL finished) {
    }];
    
}
- (void)hiddenFilterView{
    _state = 4;
    [UIView animateWithDuration:0.3 animations:^{
        self.height = 0;
        _firsetTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 0);
        _secondTableView.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 0);

    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (BOOL)isShow{
    if (self.hidden) {
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
#pragma mark-手势代理，解决和tableview点击发生的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

- (void)reloadWithKey:(NSString *)key{
    [self getData1];
    
}

@end
