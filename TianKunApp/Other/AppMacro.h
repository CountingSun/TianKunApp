//
//  AppMacro.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

// 日志输出宏定义
#ifdef DEBUG
// 调试状态
#define WQLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )//分别是方法地址，文件名，在文件的第几行，自定义输出内容
#else
// 发布状态
#define WQLog(...)
#endif

#define NET_WORK_STATES_NOTIFICATION_KEY @"netWorkChangeEventNotification"

#endif /* AppMacro_h */
