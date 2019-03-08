//
//  AppDelegate.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "WQTabBarViewController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
//share SDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
//#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <AlipaySDK/AlipaySDK.h>

#import "XTGuidePagesViewController.h"
#import "CALayer+Transition.h"
//#import "AFAppDotNetAPIClient.h"


#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#import <UserNotifications/UserNotifications.h>

#import "MessageDetailViewController.h"
#import "ConversationViewController.h"
#import "IconBadgeManager.h"

//淘宝百川
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "ExamineVetsion.h"

#import "DredgeViewController.h"

#import "BaiduMobStat.h"

@interface AppDelegate ()<selectDelegate,WXApiDelegate,JPUSHRegisterDelegate,RCIMUserInfoDataSource>
{
    //后台播放任务Id
    UIBackgroundTaskIdentifier _bgTaskId;
}
@property (nonatomic,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) BMKMapManager *mapManager;

@property (nonatomic ,strong) WQTabBarViewController *rootViewController;


@end

@implementation AppDelegate

+(instancetype)sharedAppDelegate{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ISVipManager getIsOpenVip:^(NSString *isOpen) {
        [ISVipManager setIsOpenVip:isOpen];
    }];
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"e89539acd6"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    //注册appid
    [WXApi registerApp:@"wxaf103657968f1a62"];
    [self configureWithOptions:launchOptions];
    
    
    
    NSArray *images = @[@"welcome1", @"welcome2", @"welcome3"];
    BOOL y = [XTGuidePagesViewController isShow];
    if (y) {
        XTGuidePagesViewController *xt = [[XTGuidePagesViewController alloc] init];
        xt.delegate = self;
        [xt guidePageControllerWithImages:images];

        self.window.rootViewController = xt;
        [self.window makeKeyAndVisible];

    }else{
        [self clickEnter];
    }
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    if (launchOptions) {
        if([self dealPushMessageWithUserInfo:launchOptions]){
            
        }else if([[launchOptions objectForKey:@"rc"] objectForKey:@"fId"]){
            NSString *fid = [[launchOptions objectForKey:@"rc"] objectForKey:@"fId"];
            if(fid.length){
            [self pushToConversationViewControllerWithFromID:fid];
            }
            
        }

    }
    return YES;
}
- (void)clickEnter{
    [self  setRootController];


}

- (void)setRootController{
    self.window.rootViewController =  self.rootViewController;
    self.rootViewController.selectedIndex = 0;

    [self.window makeKeyAndVisible];
    [self.window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromTop curve:TransitionCurveEaseIn duration:1.0f];

    
}
-(WQTabBarViewController *)rootViewController{
    
    _rootViewController = [[WQTabBarViewController alloc] init];
    return _rootViewController;
}
-(void)netWorkChangeMonitoring{
    
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    [_netWorkEngine monitoringnetWorkChangeWithBaseUrl:@"http://baidu.com" networkReachabilityStatusBlock:^(NetworkReachabilityStatus networkReachabilityStatus) {
        
        self.netWorkStates = networkReachabilityStatus;
        
    }];
    
    
}
#pragma mark- configure
- (void)configureLocation{
    
    [[LocationManager manager] requestWithReturnBlock:^(double latitude, double longitude) {
        
    } cityInfoFinsisBlock:^(NSString *country, NSString *locality, NSString *subLocality, NSString *thoroughfare, NSString *name) {
        
    } locationErrorBlock:^(NSError *error) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"IS_ALOWAYS_SHOW_LOCATION_ALEARN"];
        if ([str isEqualToString:@"1"]) {
            
        }else{
            [WQAlertController showAlertControllerWithTitle:@"提示" message:@"请在设置中打开定位" sureButtonTitle:@"打开定位" cancelTitle:@"不再提示" sureBlock:^(QMUIAlertAction *action) {
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication]openURL:settingURL];
            } cancelBlock:^(QMUIAlertAction *action) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"IS_ALOWAYS_SHOW_LOCATION_ALEARN"];
            }];

        }
        
    }];
}
- (void)configureWithOptions:(NSDictionary *)launchOptions{
    //检查新版本
    if ([ISVipManager isOpenVip]) {
        [ExamineVetsion examineVetsion];

    }else{
        
    }
    [self configureLocation];
    [SVProgressHUD setBackgroundColor:COLOR_TEXT_BLACK];
    [SVProgressHUD setForegroundColor:COLOR_WHITE];
    

    // 分享
    /**初始化ShareSDK应用
     
     @param activePlatforms
     
     使用的分享平台集合
     
     @param importHandler (onImport)
     
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     
     @param configurationHandler (onConfiguration)
     
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     
     */
    
    [ShareSDK registerActivePlatforms:@[
                                        //                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
                 //             case SSDKPlatformTypeSinaWeibo:
                 //                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 //                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxaf103657968f1a62"
                                       appSecret:@"3490c1c230f8d28a6fbb3ea3d04532ea"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106797746"
                                      appKey:@"vKUs2SVUiRlk54qp"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];

    if (IS_OPEN_RongCloud) {
#ifdef DEBUG

//        [[RCIM sharedRCIM] initWithAppKey:@"pwe86ga5pvv16"];
        [[RCIM sharedRCIM] initWithAppKey:@"4z3hlwrv4ooct"];

#else
        [[RCIM sharedRCIM] initWithAppKey:@"4z3hlwrv4ooct"];
//        [[RCIM sharedRCIM] initWithAppKey:@"pwe86ga5pvv16"];


#endif
            [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
        //设置接收消息代理
        [RCIM sharedRCIM].receiveMessageDelegate = self;
        //  设置头像为圆形
        [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
        //   设置优先使用WebView打开URL
        //    [RCIM sharedRCIM].embeddedWebViewPreferred = YES;
        //开启输入状态监听
        [RCIM sharedRCIM].enableTypingStatus = YES;
        //    [RCIM sharedRCIM].userInfoDataSource = self;
        
        
        [[RCIM sharedRCIM] connectWithToken:[UserInfoEngine getUserInfo].token     success:^(NSString *userId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:[UserInfoEngine getUserInfo].nickname portrait:[UserInfoEngine getUserInfo].headimg];
                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
                [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
                
            });
            
        } error:^(RCConnectErrorCode status) {
        } tokenIncorrect:^{
        }];

    }
    

    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    [_mapManager start:@"WcKHtS5ZNEUxD73CjpCyIFlVunIehuzt"  generalDelegate:nil];
    
    
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        
    } failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];
//    [[AlibcTradeSDK sharedInstance] setISVCode:@"建筑一秘"];
//    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
    
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];


}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    
    if ([UserInfoEngine getUserInfo].userID) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:[UserInfoEngine getUserInfo].userID name:[UserInfoEngine getUserInfo].nickname portrait:[UserInfoEngine getUserInfo].headimg];
        completion(userInfo);
        
    }
}

#pragma mark - 屏幕旋转相关设置
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
        application.applicationIconBadgeNumber = [IconBadgeManager getAllUnReadCount];  // 根据逻辑设置
    

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
    

}
//实现一下backgroundPlayerID:这个方法:
+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//-(void)setSDImage{
//
//    NSString *userAgent = @"";
//    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
//
//    if (userAgent) {
//        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
//            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
//            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
//                userAgent = mutableUserAgent;
//            }
//        }
//        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
//    }
//
//
//}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if (![[AlibcTradeSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
        
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if (_aliPayFinishBlock) {
                _aliPayFinishBlock(resultDic);
                
            }
            WQLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if (@available(iOS 9.0, *)) {
        if (![[AlibcTradeSDK sharedInstance] application:app openURL:url options:options]) {
            
        }
    } else {
        // Fallback on earlier versions
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if (_aliPayFinishBlock) {
                _aliPayFinishBlock(resultDic);
                
            }

            WQLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
    }else if ([url.host isEqualToString:@"jianzhuyimi"]){

        
    }
        [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}
#pragma mark ---微信
//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    
    if (_wexinPayFinishBlock) {
        _wexinPayFinishBlock(resp.errCode,[NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr]);
        
    }
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

#pragma mark- 极光
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];

}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];

}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)(void))completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)(void))completionHandler {
    
}
#endif


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    //    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    NSString *fid = [[userInfo objectForKey:@"rc"] objectForKey:@"fId"];
    if(!fid.length){
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
            
            if([self dealPushMessageWithUserInfo:userInfo]){
                
            }else{
                NSString *fid = [[userInfo objectForKey:@"rc"] objectForKey:@"fId"];
                if(fid.length){
                    //                [self pushToConversationViewControllerWithFromID:fid];
                }
                
            }
            
        }

    });
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSString *fid = [[userInfo objectForKey:@"rc"] objectForKey:@"fId"];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if([self dealPushMessageWithUserInfo:userInfo]){
//            NSString *messageID = [userInfo objectForKey:@"message_id"];
//            [self pushToViewControllerWhenClickPushMessageWithMessageID:messageID];
            

        }else{
            NSString *fid = [[userInfo objectForKey:@"rc"] objectForKey:@"fId"];
            if(fid.length){
//                [self pushToConversationViewControllerWithFromID:fid];
            }
        }

    }
    else {
        // 判断为本地通知

        if(fid.length){
//            [self pushToConversationViewControllerWithFromID:fid];
        }

    }

    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        if([self dealPushMessageWithUserInfo:userInfo]){
            NSString *messageID = [userInfo objectForKey:@"message_id"];
            NSInteger messageType = [[userInfo objectForKey:@"message_type"] integerValue];

            [self pushToViewControllerWhenClickPushMessageWithMessageID:messageID messageTpe:messageType];
        }else{
            NSString *fid = [[userInfo objectForKey:@"rc"] objectForKey:@"fId"];
            if(fid.length){
                [self pushToConversationViewControllerWithFromID:fid];
            }

        }
        
        
    }
    else {
        NSString *fid = [[userInfo objectForKey:@"rc"] objectForKey:@"fId"];
        if(fid.length){
        }

    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

-(void)pushToViewControllerWhenClickPushMessageWithMessageID:(NSString *)messageID messageTpe:(NSInteger)messageTpe{
    if (messageTpe == 3) {
        _rootViewController = (WQTabBarViewController *)self.window.rootViewController;
        _rootViewController.selectedIndex = 3;
        DredgeViewController *viewController = [[DredgeViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        QMUINavigationController *navigationController = _rootViewController.viewControllers[3];
        UIViewController *vc = navigationController.viewControllers.firstObject;
        [vc.navigationController pushViewController:viewController animated:YES];

    }else{
        _rootViewController = (WQTabBarViewController *)self.window.rootViewController;
        _rootViewController.selectedIndex = 2;
        MessageDetailViewController *messageDetailViewController = [[MessageDetailViewController alloc] initWithMessageID:[messageID integerValue] isRead:0];
        messageDetailViewController.hidesBottomBarWhenPushed = YES;
        QMUINavigationController *navigationController = _rootViewController.viewControllers[2];
        UIViewController *vc = navigationController.viewControllers.firstObject;
        [vc.navigationController pushViewController:messageDetailViewController animated:YES];

    }
    

}
- (void)pushToConversationViewControllerWithFromID:(NSString *)formID{
    _rootViewController = (WQTabBarViewController *)self.window.rootViewController;
    _rootViewController.selectedIndex = 2;
    ConversationViewController *viewController = [[ConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:formID];
    viewController.hidesBottomBarWhenPushed = YES;
    QMUINavigationController *navigationController = _rootViewController.viewControllers[2];
    UIViewController *vc = navigationController.viewControllers.firstObject;
    [vc.navigationController pushViewController:viewController animated:YES];

}
#pragma mark- 融云代理
- (void)onConnectionStatusChanged:(RCConnectionStatus)status{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [WQAlertController showAlertControllerWithTitle:@"提示"
                                                message:@"您的帐号在别的设备上登录，您被迫下线！"
                                        sureButtonTitle:@"知道了"
                                            cancelTitle:@""
                                              sureBlock:^(QMUIAlertAction *action) {
                                                  [UserInfoEngine loginOut];
                                                  [[AppDelegate sharedAppDelegate] setRootController];
                                                  
                                                  
                                              }
                                            cancelBlock:^(QMUIAlertAction *action) {
                                                
                                            }];
        
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
    } else if (status == ConnectionStatus_DISCONN_EXCEPTION) {
        [[RCIMClient sharedRCIMClient] disconnect];
        [WQAlertController showAlertControllerWithTitle:@"提示"
                                                message:@"您的帐号被封禁"
                                        sureButtonTitle:@"知道了"
                                            cancelTitle:@""
                                              sureBlock:^(QMUIAlertAction *action) {
                                                  [UserInfoEngine loginOut];

                                                  [[AppDelegate sharedAppDelegate] setRootController];
                                                  
                                                  
                                              }
                                            cancelBlock:^(QMUIAlertAction *action) {
                                                
                                            }];
    }
    
}
- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName {
    //群组通知不弹本地通知
    return NO;
}
- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message {
//    当应用处于前台运行，收到消息不会有提示音。
      return NO;
}
- (BOOL)interceptMessage:(RCMessage *)message{
    return NO;
    
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    [[NSNotificationCenter defaultCenter] postNotificationName:RCIMReceiveMessageNotice object:nil];
}


- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [WQAlertController showAlertControllerWithTitle:@"提示"
                                                message:@"您的帐号在别的设备上登录，您被迫下线！"
                                        sureButtonTitle:@"知道了"
                                            cancelTitle:@""
                                              sureBlock:^(QMUIAlertAction *action) {
                                                  [UserInfoEngine loginOut];
                                                  [[AppDelegate sharedAppDelegate] setRootController];
                                                  
                                                  
                                              }
                                            cancelBlock:^(QMUIAlertAction *action) {
                                                
                                            }];
        
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
    } else if (status == ConnectionStatus_DISCONN_EXCEPTION) {
        [[RCIMClient sharedRCIMClient] disconnect];
        [WQAlertController showAlertControllerWithTitle:@"提示"
                                                message:@"您的帐号被封禁"
                                        sureButtonTitle:@"知道了"
                                            cancelTitle:@""
                                              sureBlock:^(QMUIAlertAction *action) {
                                                  [UserInfoEngine loginOut];
                                                  
                                                  [[AppDelegate sharedAppDelegate] setRootController];
                                                  
                                                  
                                              }
                                            cancelBlock:^(QMUIAlertAction *action) {
                                                
                                            }];
    }

}
- (BOOL)dealPushMessageWithUserInfo:(NSDictionary *)userInfo{
    NSString *messageID = [userInfo objectForKey:@"message_id"];
//    消息类型（1今日推荐，2系统消息）
    NSInteger messageType = [[userInfo objectForKey:@"message_type"] integerValue];
    
    if (!messageID.length) {
        return NO;
    }else{
        if (messageType == 1) {
            [IconBadgeManager addRecomendUnReadMessageWithMessageID:messageID];

        }else if(messageType == 2){
            [IconBadgeManager addSystemUnReadMessageWithMessageID:messageID];

        }else{
            [IconBadgeManager addVIPUnReadMessageWithMessageID:messageID];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_KEY object:nil];
        return YES;
    }
}
#pragma mark - 接收到远程控制事件

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type==UIEventTypeRemoteControl)
    {
        NSInteger order=-1;
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                order=UIEventSubtypeRemoteControlPause;
                break;
            case UIEventSubtypeRemoteControlPlay:
                order=UIEventSubtypeRemoteControlPlay;
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                order=UIEventSubtypeRemoteControlNextTrack;
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                order=UIEventSubtypeRemoteControlPreviousTrack;
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                order=UIEventSubtypeRemoteControlTogglePlayPause;
                break;
            default:
                order=-1;
                break;
        }
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kAppDidReceiveRemoteControlNotification object:nil userInfo:nil];
    }
}

@end
