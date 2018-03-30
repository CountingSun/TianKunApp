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
#import "AppDelegate.h"

@interface WQTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic ,assign) NSInteger index;
@end

@implementation WQTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    // 自定义TabBar
    WQTabBar *tabBar = [[WQTabBar alloc] init];
    
    tabBar.composeButtonClick = ^{
        NSLog(@"点击按钮,弹出菜单");
        AddViewController *addViewController = [[AddViewController alloc] init];
    
        WQNavigationViewController *navController = [[WQNavigationViewController alloc] initWithRootViewController:addViewController];
//        [self presentViewController:navController animated:NO completion:^{
//
//        }];

        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        appdelegate.window.rootViewController.definesPresentationContext = YES;
        
        navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [appdelegate.window.rootViewController presentViewController:navController animated:YES completion:^{
            
            navController.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:236/255.0 blue:244/255.0 alpha:0];
            
        }];
        
    };
    
    [self setValue:tabBar forKey:@"tabBar"];
    
    [self addChildViewController];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed) name:LOGIN_SUCCEED_NOTICE object:nil];
    
}
- (void)loginSucceed{
    if (_index == 3) {
        self.selectedIndex = 3;
    }
    
}
- (void)addChildViewController {
    [self addChildViewControllerWithClassName:@"HomeViewController" title:@"首页" imageName:@"首页" selectedImage:@"首页-点击"];
    [self addChildViewControllerWithClassName:@"FindViewController" title:@"发现" imageName:@"发现" selectedImage:@"发现-点击"];
    [self addChildViewControllerWithClassName:@"MessageViewController" title:@"消息" imageName:@"消息" selectedImage:@"消息-点击"];
    [self addChildViewControllerWithClassName:@"UserCenterViewController" title:@"我的" imageName:@"我的" selectedImage:@"我的-点击"];
}

- (void)addChildViewControllerWithClassName:(NSString *)className title:(NSString *)title imageName:(NSString *)imageName  selectedImage:(NSString *)selectedImage{
    Class Clz = NSClassFromString(className);
    UIViewController *vController = [[Clz alloc] init];
    vController.title = title;
    vController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0,0, 0);
    
    
    [vController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : COLOR_TEXT_GENGRAL } forState:UIControlStateNormal];
    [vController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : COLOR_THEME } forState:UIControlStateSelected];

    QMUINavigationController *navController = [[QMUINavigationController alloc] initWithRootViewController:vController];
    navController.navigationBar.tintColor = COLOR_TEXT_GENGRAL;

    
    
    [self addChildViewController:navController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    _index = [tabBarController.viewControllers indexOfObject:viewController];
    
    if (_index == 3) {
        if ([UserInfoEngine isLogin]) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
    
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
