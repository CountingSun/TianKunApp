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
#import "DredgeViewController.h"
#import "ConversationViewController.h"
#import "IconBadgeManager.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) UnreadMessageModel *unreadMessageModel;
@property (nonatomic ,assign) NSInteger isVIP;
@property (nonatomic ,assign) NSInteger nameunreadMsgCount;
@property (nonatomic, copy) NSString *webName;
@property (nonatomic, copy) NSString *webID;

@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
        [self reloadUnRead];

        
//    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    _isVIP = 3;
    if ([UserInfoEngine getUserInfo].userID) {
        [self getIsVipWithIsShowAlearn:NO block:nil];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUnRead) name:RCIMReceiveMessageNotice object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUnRead) name:NOTIFICATION_CHANGE_KEY object:nil];


    
}
- (void)getData{
    
    NSString *urlStr = @"";
    if ([UserInfoEngine getUserInfo].userID.length) {
        urlStr = BaseUrl(@"find.message.count.by.userId?userId=");
        urlStr = [urlStr stringByAppendingString:[UserInfoEngine getUserInfo].userID];
    }else{
        urlStr = BaseUrl(@"find.message.count.by.userId");
    }
    
    [self.netWorkEngine getWithUrl:urlStr succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _unreadMessageModel = [UnreadMessageModel mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            
            NSInteger count = _unreadMessageModel.recommendation_message + _unreadMessageModel.system_message + _unreadMessageModel.personal_certificate_message +_unreadMessageModel.datum_certificate_message;
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",@(count)] forKey:NOTICE_BADGE_KEY];
            
            
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
            cell.unReadCount = [IconBadgeManager getSystemMessagCount];
            break;
        case 1:
            cell.unReadCount = [IconBadgeManager getRecomendMessagCount];
            break;
        case 2:
            cell.unReadCount = 0;
            break;
        case 3:
            cell.unReadCount = 0;
            break;

        default:
//            cell.unReadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:[UserInfoEngine getUserInfo].vip_webid];
            cell.unReadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:@"819750023"];

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
            if ([UserInfoEngine isLogin]) {
                RemindMessageViewController *viewController = [RemindMessageViewController new];
                
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }

        }
            break;
        case 3:{
            if ([UserInfoEngine isLogin]) {

            ExpertMessageViewController *viewController = [ExpertMessageViewController new];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            }
        }
            break;
        case 4:{
            
            if ([UserInfoEngine isLogin]) {
                    [self showWithStatus:NET_WAIT_TOST];
                    [self getIsVipWithIsShowAlearn:YES block:^(NSString *errorMsg) {
                        if (!errorMsg.length) {
                            if (_isVIP == 1) {
                                [self pushToChartController];
                            }else{
                                [WQAlertController showAlertControllerWithTitle:@"提示" message:@"只有VIP会员才可以使用VIP客服功能" sureButtonTitle:@"去开通" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
                                    DredgeViewController *vc = [[DredgeViewController alloc] init];
                                    vc.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:vc animated:YES];
                                    
                                } cancelBlock:^(QMUIAlertAction *action) {
                                    
                                }];

                            }
                        }else {
                            [self showErrorWithStatus:errorMsg];
                        }
                    }];
            }
                    
        }
            break;

        default:
            break;
    }
    
}
- (void)pushToChartController{
    [[IQKeyboardManager sharedManager] setEnable:NO];
    //新建一个聊天会话View Controller对象,建议这样初始化
    ConversationViewController *chat = [[ConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:_webID];
    //设置聊天会话界面要显示的标题
    chat.title = _webName;
    chat.custonName = _webName;
    chat.displayUserNameInCell = NO;
    
    
    chat.hidesBottomBarWhenPushed = YES;
    
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];

}
- (void)getIsVipWithIsShowAlearn:(BOOL)isShow block:(void(^)(NSString *errorMsg))block{
    
    [self.netWorkEngine postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"payment/userdetail.action") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _isVIP = [[[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"vip_status"] integerValue];
            _webName = [[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"webname"];
            
            @try {
                _webID = [[[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"vip_webid"] stringValue];

            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
            UserInfo *userInfo = [UserInfoEngine getUserInfo];
            userInfo.vip_webid = [NSString stringWithFormat:@"%@",_webID];
            [UserInfoEngine setUserInfo:userInfo];
            
            if (block) {
                block(@"");
            }
            [self dismiss];
            
        }else{
            if (isShow) {
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            }
            if (block) {
                block([responseObject objectForKey:@"msg"]);
            }

        }
    } errorBlock:^(NSError *error) {
        if (isShow) {
            if (block) {
                block(NET_ERROR_TOST);
            }
            

        [self showErrorWithStatus:NET_ERROR_TOST];
        }
    }];
    
}

- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
        
    }
    return _netWorkEngine;
}
- (void)reloadUnRead{
    [self.tableView reloadData];
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
