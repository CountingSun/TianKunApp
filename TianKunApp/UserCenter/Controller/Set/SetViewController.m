//
//  SetViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SetViewController.h"
#import "MenuInfo.h"
#import "UserCenterViewModel.h"
#import "AppDelegate.h"

#import "MessageSetViewController.h"
#import "HelpViewController.h"
#import "AboutUsViewController.h"
#import "WebLinkViewController.h"
#import "ChangePasswordViewController.h"
#import "SetInfoWebViewController.h"
#import "ManagerAddressViewController.h"
#import "AssociationAccountViewController.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (weak, nonatomic) IBOutlet UIButton *loginoutButton;
@property (nonatomic, copy) NSString *appUrl;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed) name:LOGIN_SUCCEED_NOTICE object:nil];

    [self setupUI];
    

}
- (void)setupUI{
    [self.titleView setTitle:@"设置"];
    _arrMenu = [UserCenterViewModel arrSetMenu];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    
    if ([UserInfoEngine getUserInfo].userID) {
        _tableView.tableFooterView = self.footView;
    }
    [_loginoutButton setBackgroundColor:COLOR_TEXT_ORANGE];
    _loginoutButton.layer.masksToBounds = YES;
    _loginoutButton.layer.cornerRadius = 20;
    
    [self.tableView reloadData];
    
}
- (void)loginSucceed{
    _tableView.tableFooterView = self.footView;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = _arrMenu[indexPath.row];
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = 0;
        
        
        
    }
    cell.imageView.image = [UIImage imageNamed:menuInfo.menuIcon];
    cell.textLabel.text = menuInfo.menuName;
    if (indexPath.row== 1) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.text = [WQTools getTmpSize];
    }else{
        cell.detailTextLabel.text = @"";

        }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = _arrMenu[indexPath.row];

    switch (menuInfo.menuID) {
        case 0:
            {
                MessageSetViewController *viewController = [[MessageSetViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
                
            }
            break;
        case 1:{
            
            [WQAlertController showAlertControllerWithTitle:@"提示" message:@"是否要清除缓存" sureButtonTitle:@"确定" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
                [WQTools clearTmpPics];
                [self showSuccessWithStatus:@"清除缓存成功"];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } cancelBlock:^(QMUIAlertAction *action) {
                
            }];
            
            
        }
            break;
        case 2:{
            HelpViewController *viewController = [[HelpViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];

        }
            break;
        case 3:{
            AboutUsViewController *viewController = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];

        }
            break;
        case 4:{
            [self showWithStatus:NET_WAIT_TOST];
            [self updateVersion];
            
            
        }
            break;

        case 5:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"html"];
            NSURL*Url = [NSURL fileURLWithPath:path];

            SetInfoWebViewController *viewController = [[SetInfoWebViewController alloc]initWithUrl:Url title:@"使用协议"];
            [self.navigationController pushViewController:viewController animated:YES];

        }
            break;
        case 6:{
            if ([UserInfoEngine isLogin]) {
                ChangePasswordViewController *viewController = [[ChangePasswordViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
            }

        }
            
            break;
        case 7:{
            if ([UserInfoEngine isLogin]) {

            ManagerAddressViewController *viewController = [[ManagerAddressViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
            }

            
        }
            break;
        case 8:{
            
            if ([UserInfoEngine isLogin]) {
                
                AssociationAccountViewController *viewController = [[AssociationAccountViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
            }

        }
            break;
            
            
        default:
            break;
    }
}
- (IBAction)loginoutButtonClickEvent:(id)sender {
    
    [WQAlertController showAlertControllerWithTitle:@"提示" message:@"您确定要退出登录吗？" sureButtonTitle:@"确定" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
        [UserInfoEngine loginOut];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[AppDelegate sharedAppDelegate] setRootController];
        
        

    } cancelBlock:^(QMUIAlertAction *action) {
        
    }];
    
    
    
}
- (void)updateVersion{
    [[[NetWorkEngine alloc] init] postWithDict:@{@"type":@"1"} url:BaseUrl(@"UpdateVersionsController/selectupdateversionbytype.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self dismiss];
            NSString *version = [[responseObject objectForKey:@"value"] objectForKey:@"number"];
            _appUrl = [[responseObject objectForKey:@"value"] objectForKey:@"url"];

            if (![version isEqualToString:[WQTools appVersion]]) {
                [WQAlertController showAlertControllerWithTitle:@"提示" message:@"发现新版本，是否前去App Store更新？" sureButtonTitle:@"去更新" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
                    NSURL *url = [NSURL URLWithString:_appUrl];
                    
                    [[UIApplication sharedApplication] openURL:url];
                    

                } cancelBlock:^(QMUIAlertAction *action) {
                    
                }];
                
            }else{
                [QMUITips showInfo:@"当前已是最新版本"];
            }
            
            
            
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];

    }];
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
