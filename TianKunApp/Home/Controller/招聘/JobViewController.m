//
//  JobViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "JobViewController.h"
#import "FilterView.h"
#import "UIView+Extension.h"
@interface JobViewController ()
@property (weak, nonatomic) IBOutlet QMUIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet QMUIButton *thirdButton;
@property (nonatomic ,strong) FilterView *filterView;

/**
 3个按钮的标记 分别对应123点击 4的时候代表都未点击
 */
@property (nonatomic ,assign) NSInteger currectType;;

@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"招聘"];
//    QMUIEmptyView *emptyView = [[QMUIEmptyView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_firstButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(_firstButton.frame))];
//    emptyView.imageView.image = [UIImage imageNamed:@"钉钉"];
//    emptyView.textLabel.text = @"11111";
//    emptyView.detailTextLabel.text = @"2222";
//    [self.view addSubview:emptyView];
//        [self showEmptyViewWithImage:[UIImage imageNamed:@"钉钉"] text:@"1111111" detailText:@"1111111" buttonTitle:@"1111111" buttonAction:@selector(aaa)];

//    self.emptyView.backgroundColor = [UIColor redColor];
}

#pragma makr- button click
- (IBAction)firstButtonClick:(id)sender {
    if (_currectType == 1) {
        [self.filterView hiddenFilterView];
        _currectType = 4;
        return;
    }
    if ([self.filterView isShow]) {
        [self.filterView reloadWithKey:@""];
    }else{
        [self.filterView showFilterView];
        
    }
    _currectType = 1;
    
}
- (IBAction)secondButtonClick:(id)sender {
    if (_currectType == 2) {
        [self.filterView hiddenFilterView];
        _currectType = 4;
        return;
    }

    if ([self.filterView isShow]) {
        [self.filterView reloadWithKey:@""];
    }else{
        [self.filterView showFilterView];
        
    }
    _currectType = 2;

}
- (IBAction)thirdButtonClick:(id)sender {
    if (_currectType == 3) {
        [self.filterView hiddenFilterView];
        _currectType = 4;
        return;
    }

    if ([self.filterView isShow]) {
        [self.filterView reloadWithKey:@""];
    }else{
        [self.filterView showFilterView];
        
    }
    _currectType = 3;

}

#pragma mark- lazy init
- (FilterView *)filterView{
    if (!_filterView) {
        _filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0)];
        [self.view addSubview:_filterView];
        _filterView.hidden = YES;
    }
    return _filterView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
