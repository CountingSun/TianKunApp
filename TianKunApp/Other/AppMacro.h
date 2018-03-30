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

#define BaseUrl(string) [@"http://47.92.72.134/" stringByAppendingString:string]
//#define BaseUrl(string) [@"http://192.168.1.128/" stringByAppendingString:string]

#define LOGIN_SUCCEED_NOTICE @"netWorkChangeEventNotification"

#define NET_WORK_STATES_NOTIFICATION_KEY @"netWorkChangeEventNotification"
#define NET_ERROR_TOST @"网络连接失败"
#define NET_WAIT_TOST @"请稍候"
#define NET_WAIT_NO_DATA @"暂无更多数据"

#define GET_CODE_TIME 60

#define DEFAULT_IMAGE_11 @"行业信息"
#define DEFAULT_IMAGE_21 @"行业信息"

#define DEFAULT_PAGE_SIZE 15
#endif /* AppMacro_h */
