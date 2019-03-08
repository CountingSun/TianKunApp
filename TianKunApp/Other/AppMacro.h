//
//  AppMacro.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

////  原型地址： https://pro.modao.cc/app/DpDdMFXGMMkB2xq526dh168252BwrwS#screen=s9C0FCE72A11516243317344


/// svn地址:https://47.92.72.134/svn/UI/

#ifndef AppMacro_h
#define AppMacro_h
///判断是否为空
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

// 日志输出宏定义
#ifdef DEBUG
// 调试状态
#define WQLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )//分别是方法地址，文件名，在文件的第几行，自定义输出内容
#else
// 发布状态
#define WQLog(...)
#endif
#ifdef DEBUG
#define BaseUrl(string) [@"http://47.92.72.134:8888/" stringByAppendingString:string]
//#define BaseUrl(string) [@"http://api.jianzhuyimi.com/" stringByAppendingString:string]

#else
#define BaseUrl(string) [@"http://api.jianzhuyimi.com/" stringByAppendingString:string]
//#define BaseUrl(string) [@"http://47.92.72.134:8888/" stringByAppendingString:string]

#endif
//是否开fang vip
#define IS_OPEN_VIP 0
#define IS_OPEN_RongCloud 0

#define IS_Builder_Version 0






#define CreateHtmlString(string) [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"utf-8\"></head><body>%@</body></html>",string]
//MARK:判断是否是 iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#ifndef sx_deviceVersion
#define sx_deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif


#define NavBarHeight IS_IPHONE_X?88:64

//MARK:分享地址

#define DEFAULT_SHARE_URL @"http://appweb.jianzhuyimi.com/app/shouye/b/download.html"

//MARK:登录成功通知KEY
#define LOGIN_SUCCEED_NOTICE @"login_succeed_notice"
//MARK:融云收到消息通知KEY
#define RCIMReceiveMessageNotice @"RCIMReceiveMessageNotice"
//MARK:网络变化通知KEY
#define NET_WORK_STATES_NOTIFICATION_KEY @"netWorkChangeEventNotification"
//MARK:支付成功通知KEY
#define PAY_SUCCEED_NOTICE @"PAY_SUCCEED_NOTICE"
//MARK:位置更新通知KEY
#define LOCATION_UPDATE_KEY @"LOCATION_UPDATE_KEY"
//MARK:通知数量的key
#define NOTICE_BADGE_KEY @"NOTICE_BADGE_KEY"
//MARK:收到通知更新数量的通知的KEY
#define NOTIFICATION_CHANGE_KEY @"NOTICE_BADGE_KEY"
//MARK:后台播放  控制
#define kAppDidReceiveRemoteControlNotification @"kAppDidReceiveRemoteControlNotification"

//MARK:网络请求提示语

#define NET_ERROR_TOST @"网络连接失败"
#define NET_WAIT_TOST @"请稍候"
#define NET_WAIT_NO_DATA @"暂无更多数据"

//MARK:支付宝SCHEMES
#define ALIPAY_SCHEMES @"TianKunAppAliPay"

//百度文字识别  ak  sk
#define AipOcrServiceAK @"OvorEQtSz3f9iA2I26rE8SIT"
#define AipOcrServiceSK @"sxi5ZtBGqKCChjioXlyOdXhANXNOGy98"

//MARK:再次获取验证码等待时间
#define GET_CODE_TIME 60

#define DEFAULT_IMAGE_11 @"default11_fail_image"
#define DEFAULT_IMAGE_21 @"default21_fail_image"
//MARK:默认分页大小

#define DEFAULT_PAGE_SIZE 20





#endif /* AppMacro_h */
