//
//  WQBaseViewController.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQBaseViewController.h"
#import "SVProgressHUD.h"
#import "LoadingView.h"


@interface WQBaseViewController ()
@property (nonatomic ,strong) LoadingView *loadingView;
@property (nonatomic, copy) dispatch_block_t reloadBlock;
@property (nonatomic ,strong) QMUIEmptyView *selfEmptyView;
@end
@implementation WQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_VIEW_BACK;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
    
}
- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view{
    return YES;
}
-(void)setBackButtonTitle:(NSString *)backButtonTitle{
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    
    backIetm.title =backButtonTitle;
    self.navigationItem.backBarButtonItem = backIetm;
    
    
}
-(void)showErrorWithStatus:(NSString *)status{
    
    [SVProgressHUD showErrorWithStatus:status];
}
-(void)showWithStatus:(NSString *)status{
    
    [SVProgressHUD showWithStatus:status];
}
-(void)showSuccessWithStatus:(NSString *)status{
    [SVProgressHUD showSuccessWithStatus:status];
    
}
-(void)dismiss{
    
    [SVProgressHUD dismiss];
    
}
- (void)showTipsWithText:(NSString *)text{
    QMUITips *tips = [[QMUITips alloc]initWithView:self.view];
    
    [tips showInfo:text hideAfterDelay:2];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)showLoadingView{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) loadingText:@"加载中..."];
    }
    [self.view addSubview:_loadingView];
}
- (void)showLoadingViewWithFrame:(CGRect)frame{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc]initWithFrame:frame loadingText:@"加载中..."];
    }
    [self.view addSubview:_loadingView];
}
- (void)hideLoadingView{
    if (_loadingView) {
        [_loadingView removeFromSuperview];
    }
    

}

- (void)showGetDataFailViewWithReloadBlock:(dispatch_block_t)reloadBlock{
    _reloadBlock = reloadBlock;
    [self showEmptyViewWithImage:[UIImage imageNamed:@"net_fail"] text:@"网络连接失败" detailText:@"" buttonTitle:@"重新加载" buttonAction:@selector(reloData)];
    self.emptyView.backgroundColor = COLOR_VIEW_BACK;

}
-(void)reloData{
    [self hideEmptyView];
    
    if (_selfEmptyView) {
        [_selfEmptyView removeFromSuperview];
    }
    if (_reloadBlock) {
        _reloadBlock();
    }
}
- (void)showGetDataNullWithReloadBlock:(dispatch_block_t)reloadBlock{
    _reloadBlock = reloadBlock;

    [self showEmptyViewWithImage:[UIImage imageNamed:@"net_fail"] text:@"暂无数据" detailText:@"" buttonTitle:@"重新加载" buttonAction:@selector(reloData)];
    self.emptyView.backgroundColor = COLOR_VIEW_BACK;

}
- (void)showGetDataErrorWithMessage:(NSString *)message reloadBlock:(dispatch_block_t)reloadBlock{
    _reloadBlock = reloadBlock;
    
    [self showEmptyViewWithImage:[UIImage imageNamed:@"net_fail"] text:message detailText:@"" buttonTitle:@"重新加载" buttonAction:@selector(reloData)];
    self.emptyView.backgroundColor = COLOR_VIEW_BACK;

}

- (QMUIEmptyView *)selfEmptyView{
    if (!_selfEmptyView) {
        _selfEmptyView = [[QMUIEmptyView alloc]init];
        _selfEmptyView.backgroundColor = COLOR_VIEW_BACK;
        [_selfEmptyView setLoadingViewHidden:YES];

    }
    return _selfEmptyView;
}
- (void)showGetDataNullEmptyViewInView:(UIView *)view reloadBlock:(dispatch_block_t)reloadBlock{
    _reloadBlock = reloadBlock;

    [self.selfEmptyView setImage:[UIImage imageNamed:@"net_fail"]];
    [self.selfEmptyView setActionButtonTitle:@"重新加载"];
    [self.selfEmptyView setTextLabelText:@"暂无数据"];
    [self.selfEmptyView.actionButton addTarget:self action:@selector(reloData) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.selfEmptyView];
    self.selfEmptyView.frame = CGRectMake(0, 0, view.qmui_width, view.qmui_height);
    
    
    
}
- (void)showGetDataFailEmptyViewInView:(UIView *)view reloadBlock:(dispatch_block_t)reloadBlock{
    _reloadBlock = reloadBlock;
    
    [self.selfEmptyView setImage:[UIImage imageNamed:@"net_fail"]];
    [self.selfEmptyView setActionButtonTitle:@"重新加载"];
    [self.selfEmptyView setTextLabelText:@"网络连接失败"];
    [self.selfEmptyView.actionButton addTarget:self action:@selector(reloData) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.selfEmptyView];
    self.selfEmptyView.frame = CGRectMake(0, 0, view.qmui_width, view.qmui_height);
    

}
- (void)showGetDataFailEmptyViewInView:(UIView *)view message:(NSString *)message reloadBlock:(dispatch_block_t)reloadBlock{
    _reloadBlock = reloadBlock;
    
    [self.selfEmptyView setImage:[UIImage imageNamed:@"net_fail"]];
    [self.selfEmptyView setActionButtonTitle:@"重新加载"];
    [self.selfEmptyView setTextLabelText:message];
    [self.selfEmptyView.actionButton addTarget:self action:@selector(reloData) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.selfEmptyView];
    self.selfEmptyView.frame = CGRectMake(0, 0, view.qmui_width, view.qmui_height);
    
    
}

- (void)hideSelfEmptyView{
    [self.selfEmptyView removeFromSuperview];

}
//- (void)
- (void)dealloc{
    _loadingView = nil;
    WQLog(@"dealloc");
}

@end
