//
//  MessageViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MessageViewController.h"
#import "TKMessageListInfo.h"
#import "MesssageViewModel.h"
#import "MessageListTableViewCell.h"
#import "SystemMessageViewController.h"
#import "RecommendMessageViewController.h"
#import "RemindMessageViewController.h"
#import "ExpertMessageViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    
    
}
- (void)setupUI{
    _arrMenu = [MesssageViewModel arrMenu];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"MessageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageListTableViewCell"];
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrMenu.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListTableViewCell" forIndexPath:indexPath];
    TKMessageListInfo *info = _arrMenu[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:info.listImage];
    cell.titleLabel.text = info.listTitle;
    cell.detailLabel.text = info.listDetail;
    cell.unReadCount = info.listUnReadNum;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TKMessageListInfo *info = _arrMenu[indexPath.row];

    switch (info.listID) {
        case 0:
            {
                SystemMessageViewController *systemMessageViewController = [SystemMessageViewController new];
                systemMessageViewController.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:systemMessageViewController animated:YES];
                
            }
            break;
        case 1:
        {
            RecommendMessageViewController *viewController = [RecommendMessageViewController new];

            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
            break;
        case 2:{
            
            RemindMessageViewController *viewController = [RemindMessageViewController new];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];

        }
            break;
        case 3:{
            
            ExpertMessageViewController *viewController = [ExpertMessageViewController new];
            
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
