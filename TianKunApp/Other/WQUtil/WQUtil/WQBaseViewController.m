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


@interface WQBaseViewController ()<UINavigationControllerDelegate>
@property (nonatomic ,strong) LoadingView *loadingView;
@property (nonatomic, copy) dispatch_block_t reloadBlock;
@end
@implementation WQBaseViewController

-(void)setIsHiddenNav:(BOOL)isHiddenNav{
    
    if (isHiddenNav) {
        self.navigationController.delegate = self;
        
    }
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

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

//- (void)
- (void)dealloc{
    _loadingView = nil;
    WQLog(@"dealloc");
}

@end
