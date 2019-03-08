//
//  HelpViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HelpViewController.h"
#import "MenuInfo.h"
#import "UserCenterViewModel.h"
#import "WebLinkViewController.h"
#import "FadebackViewController.h"
#import "SetInfoWebViewController.h"

@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *fadebackButton;
@property (nonatomic ,strong) NSMutableArray *arrMenu;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}
- (void)setupUI{
    [self.titleView setTitle:@"帮助与反馈"];
    _arrMenu = [UserCenterViewModel arrSetHelpMenu];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    
    _tableView.tableFooterView = self.footView;
    [_fadebackButton setBackgroundColor:COLOR_TEXT_ORANGE];
    _fadebackButton.layer.masksToBounds = YES;
    _fadebackButton.layer.cornerRadius = 20;
    
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
        cell.selectionStyle = 0;
        
        
        
    }
    cell.imageView.image = [UIImage imageNamed:menuInfo.menuIcon];
    cell.textLabel.text = menuInfo.menuName;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MenuInfo *menuInfo = _arrMenu[indexPath.row];
    NSString *path = [[NSBundle mainBundle] pathForResource:menuInfo.menuDetail ofType:@"html"];
    NSURL*Url = [NSURL fileURLWithPath:path];
    
    SetInfoWebViewController *viewController = [[SetInfoWebViewController alloc]initWithUrl:Url title:menuInfo.menuName];
    [self.navigationController pushViewController:viewController animated:YES];

}
- (IBAction)fadebackButtonClickEvent:(id)sender {
    [self.navigationController pushViewController:[FadebackViewController new] animated:YES];
    
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
