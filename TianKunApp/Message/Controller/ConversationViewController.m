
//
//  ConversationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ConversationViewController.h"

@interface ConversationViewController ()
@property (nonatomic ,strong) RCUserInfo *targetInfo;
@property (nonatomic ,strong) RCUserInfo *userInfo;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
    if (self.chatSessionInputBarControl.pluginBoardView.allItems.count>2) {
        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    }
//    [[RCIM sharedRCIM]setUserInfoDataSource:self];
    

}
//- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent{
//
//    if ([messageContent isKindOfClass:[RCTextMessage class]]) {
//        RCTextMessage *message = (RCTextMessage *)messageContent;
//
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"fromUserId"];
//        [dict setObject:self.targetId forKey:@"toUserId"];
//        [dict setObject:message.content forKey:@"message"];
//
//        [self.netWorkEngine postWithDict:dict url:BaseUrl(@"rong/sendmessage.action") succed:^(id responseObject) {
//            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
//            if (code == 1) {
//
//            }else{
//
//            }
//        } errorBlock:^(NSError *error) {
//
//        }];
//
//    }else{
//        [super sendMessage:messageContent pushContent:pushContent];
//    }
//
//
//}
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
//
//    RCUserInfo *userinfo = [[RCUserInfo alloc]initWithUserId:@"" name:_custonName portrait:@""];
//
//    completion(userinfo);
//
//}
//

//- (NetWorkEngine *)netWorkEngine{
//    if (!_netWorkEngine) {
//        _netWorkEngine = [[NetWorkEngine alloc] init];
//    }
//    return _netWorkEngine;
//
//}
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
