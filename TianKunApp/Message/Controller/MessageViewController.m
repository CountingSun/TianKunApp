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
#import <RongIMKit/RongIMKit.h>
#import "UnreadMessageModel.h"
#import "IQKeyboardManager.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) UnreadMessageModel *unreadMessageModel;
@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];

    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取当前应用程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    
    // iOS 8 系统要求设置通知的时候必须经过用户许可。
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    
    [app registerUserNotificationSettings:settings];
    
    // 设置应用程序右上角的"通知图标"Badge
    app.applicationIconBadgeNumber = 0;  // 根据逻辑设置

    [self setupUI];
//    self.tabBarItem.badgeValue = @"1";
    [self getData];
    

    
}
- (void)getData{
    
    NSString *urlStr = BaseUrl(@"find.message.count.by.userId?userId=");
    urlStr = [urlStr stringByAppendingString:[UserInfoEngine getUserInfo].userID];
    
    [self.netWorkEngine getWithUrl:urlStr succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _unreadMessageModel = [UnreadMessageModel mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            [self.tableView reloadData];
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
    
    
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
//    cell.unReadCount = info.listUnReadNum;
    switch (indexPath.row) {
        case 0:
            cell.unReadCount = _unreadMessageModel.system_message;
            break;
        case 1:
            cell.unReadCount = _unreadMessageModel.recommendation_message;
            break;
        case 2:
            cell.unReadCount = _unreadMessageModel.personal_certificate_message;
            break;
        case 3:
            cell.unReadCount = _unreadMessageModel.datum_certificate_message;
            break;

        default:
            cell.unReadCount = 0;
            break;
    }
    
    
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
        case 4:{
            [[IQKeyboardManager sharedManager] setEnable:NO];

            //新建一个聊天会话View Controller对象,建议这样初始化
            RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE
        targetId:@"12"];
            //设置聊天会话界面要显示的标题
            chat.title = @"VIP客服";
            chat.hidesBottomBarWhenPushed = YES;
            //显示聊天会话界面
            [self.navigationController pushViewController:chat animated:YES];

        }
            break;

        default:
            break;
    }
    
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
        
    }
    return _netWorkEngine;
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
