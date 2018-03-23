//
//  WQBaseViewController.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQBaseViewController.h"
#import "SVProgressHUD.h"

@interface WQBaseViewController ()<UINavigationControllerDelegate>

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
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
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

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
-(void)dealloc{
    
    WQLog(@"dealloc");
    
}
@end
