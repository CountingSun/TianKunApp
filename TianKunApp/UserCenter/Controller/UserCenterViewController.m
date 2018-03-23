//
//  UserCenterViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterViewModel.h"
#import "MenuInfo.h"
#import "SetViewController.h"
#import "HistoryViewController.h"

@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *vipButton;
@property (weak, nonatomic) IBOutlet QMUIButton *recordButton;
@property (weak, nonatomic) IBOutlet QMUIButton *pointButton;
@property (weak, nonatomic) IBOutlet QMUIButton *publicButton;

@property (nonatomic ,strong) NSMutableArray *arrMenu;
@end

@implementation UserCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}
- (void)setupUI{
    
    _arrMenu = [UserCenterViewModel arrMenu];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headView;
    _tableView.rowHeight = 45;
    _tableView.tableFooterView = [UIView new];
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.qmui_width/2;
    [self.tableView reloadData];
    
    [_vipButton setImagePosition:QMUIButtonImagePositionTop];
    [_vipButton setSpacingBetweenImageAndTitle:5];
    
    [_recordButton setImagePosition:QMUIButtonImagePositionTop];
    [_recordButton setSpacingBetweenImageAndTitle:5];
    
    [_pointButton setImagePosition:QMUIButtonImagePositionTop];
    [_pointButton setSpacingBetweenImageAndTitle:5];
    
    [_publicButton setImagePosition:QMUIButtonImagePositionTop];
    [_publicButton setSpacingBetweenImageAndTitle:5];


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

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = _arrMenu[indexPath.row];

    switch (menuInfo.menuID) {
        case 0:
            {
                
            }
            break;
        case 1:{
            
            
            HistoryViewController *viewController = [[HistoryViewController alloc]init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];

        }
            break;
        case 2:{
            SetViewController *viewController = [[SetViewController alloc]init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
