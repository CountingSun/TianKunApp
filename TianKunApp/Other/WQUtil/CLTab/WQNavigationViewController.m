//
//  WQNavigationViewController.m
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/9.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "WQNavigationViewController.h"
#import "UIBarButtonItem+Addition.h"

@interface WQNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WQNavigationViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return YES; //YES：允许右滑返回  NO：禁止右滑返回
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = COLOR_WHITE;
    //导航栏标题文字属性
    NSMutableDictionary *textAttributesDict = [NSMutableDictionary dictionary];
    // 文字颜色
    textAttributesDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // 文字大小
    textAttributesDict[NSFontAttributeName] = [UIFont systemFontOfSize:18.f];
    [self.navigationBar setTitleTextAttributes:textAttributesDict];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSString *title = @"";
    if (self.viewControllers.count > 0) {
        if(self.viewControllers.count == 1) {
            title = self.childViewControllers[0].title;
        }
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" imageName:@"返回" target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back {
    [self popViewControllerAnimated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
