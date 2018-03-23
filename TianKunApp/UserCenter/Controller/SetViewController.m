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

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (weak, nonatomic) IBOutlet UIButton *loginoutButton;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}
- (void)setupUI{
    
    _arrMenu = [UserCenterViewModel arrMenu];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    _tableView.tableFooterView = self.footView;

    [_loginoutButton setBackgroundColor:COLOR_TEXT_ORANGE];
    _loginoutButton.layer.masksToBounds = YES;
    _loginoutButton.layer.cornerRadius = 20;
    
    [self.tableView reloadData];
    
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
        
        
        
    }
    cell.imageView.image = [UIImage imageNamed:menuInfo.menuIcon];
    cell.textLabel.text = menuInfo.menuName;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (IBAction)loginoutButtonClickEvent:(id)sender {
    
    [WQAlertController showAlertControllerWithTitle:@"提示" message:@"您确定要退出登录吗？" sureButtonTitle:@"确定" cancelTitle:@"取消" sureBlock:^(UIAlertAction *action) {
        [UserInfoEngine setUserInfo:nil];
        [[AppDelegate sharedAppDelegate] setRootController];

    } cancelBlock:^(UIAlertAction *action) {
        
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
