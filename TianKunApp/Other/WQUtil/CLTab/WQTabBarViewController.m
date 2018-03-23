//
//  WQTabBarViewController.m
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/9.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "WQTabBarViewController.h"
#import "WQNavigationViewController.h"
#import "WQTabBar.h"
#import "AddViewController.h"

@interface WQTabBarViewController ()

@end

@implementation WQTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义TabBar
    WQTabBar *tabBar = [[WQTabBar alloc] init];
    
    tabBar.composeButtonClick = ^{
        NSLog(@"点击按钮,弹出菜单");
        AddViewController *addViewController = [[AddViewController alloc] init];
    
        WQNavigationViewController *navController = [[WQNavigationViewController alloc] initWithRootViewController:addViewController];
        [self presentViewController:navController animated:NO completion:^{
            
        }];

    };
    
    [self setValue:tabBar forKey:@"tabBar"];
    
    [self addChildViewController];
}

- (void)addChildViewController {
    [self addChildViewControllerWithClassName:@"HomeViewController" title:@"首页" imageName:@"TabBar0_45x45_" selectedImage:@"TabBar0Sel_45x45_"];
    [self addChildViewControllerWithClassName:@"LookScheduleViewController" title:@"查档" imageName:@"TabBar1_45x45_" selectedImage:@"TabBar1Sel_45x45_"];
    [self addChildViewControllerWithClassName:@"CircleViewController" title:@"朋友圈" imageName:@"TabBar3_45x45_" selectedImage:@"TabBar3Sel_45x45_"];
    [self addChildViewControllerWithClassName:@"UserCenterViewController" title:@"我的" imageName:@"TabBar4_45x45_" selectedImage:@"TabBar4Sel_45x45_"];
}

- (void)addChildViewControllerWithClassName:(NSString *)className title:(NSString *)title imageName:(NSString *)imageName  selectedImage:(NSString *)selectedImage{
    Class Clz = NSClassFromString(className);
    UIViewController *vController = [[Clz alloc] init];
    vController.title = title;
    vController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0,0, 0);
    
    
    [vController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] } forState:UIControlStateNormal];
    [vController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [WQAppInfo themColor] } forState:UIControlStateSelected];

    WQNavigationViewController *navController = [[WQNavigationViewController alloc] initWithRootViewController:vController];
    
    [self addChildViewController:navController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
