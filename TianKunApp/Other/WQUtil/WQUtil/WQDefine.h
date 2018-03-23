//
//  WQDefine.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#ifndef WQDefine_h
#define WQDefine_h

#define HEIGHT     [[UIScreen mainScreen] bounds].size.height //获取屏幕的高度
#define WIDTH      [[UIScreen mainScreen] bounds].size.width  //获取屏幕的宽度



#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatueBarHeight (IS_iOS7 ? 20:0)
#define NavigationbarHeight (IS_iOS7 ? 44:0)
#define ViewOriginY (IS_iOS7 ? 64:0)
#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kMBProgressTag 9999
#define IS_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)


#pragma mark 16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define MYColor       0xf4c91d
#define MYGreen       0x1DE3DD//青涩
#define MYBlue        0x61d2fe//蓝色
#define MYRed         0xff5534//红色
//#define MYHEIGHTRED   0xff4966//亮红
#define MYYellow      0xfecf55//黄
#define MYGray        0xcecece//背景浅灰
#define MYSGray       0x7F7F7F//字体深灰

#define MYHEIGHT [[UIScreen mainScreen] bounds].size.height/667
#define MYWIDTH  [[UIScreen mainScreen] bounds].size.width/375

//EF2800
#define HaveNetWork [MyTools connectedToNetwork]

/** 没有导航栏的屏幕高度 */
#define ScreenHNoNavi ([UIScreen mainScreen].bounds.size.height - 64 - 49)

#if DEBUG
#define SuLog(format, ...) NSLog(format, ## __VA_ARGS__)
//#define SuLog(format, ...) NSLog(@"%s: %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__]);
#else
#define SuLog(format, ...)
#endif
// 消息通知
#define RegisterNotify(_name, _selector)                    \
[[NSNotificationCenter defaultCenter] addObserver:self  \
selector:_selector name:_name object:nil];

#define RemoveNofify            \
[[NSNotificationCenter defaultCenter] removeObserver:self];

#define SendNotify(_name, _object)  \
[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object];

// 日志输出宏
#define BASE_LOG(cls,sel) SuLog(@"%@ -> %@",NSStringFromClass(cls), NSStringFromSelector(sel))
#define BASE_ERROR_LOG(cls,sel,error) SuLog(@"ERROR:%@ -> %@ -> %@",NSStringFromClass(cls), NSStringFromSelector(sel), error)
#define BASE_INFO_LOG(cls,sel,info) SuLog(@"INFO:%@ -> %@ -> %@",NSStringFromClass(cls), NSStringFromSelector(sel), info)

// 日志输出函数
#if DEBUG
#define BASE_LOG_FUN()         BASE_LOG([self class], _cmd)
#define BASE_ERROR_FUN(error)  BASE_ERROR_LOG([self class],_cmd,error)
#define BASE_INFO_FUN(info)    BASE_INFO_LOG([self class],_cmd,info)
#else
#define BASE_LOG_FUN()
#define BASE_ERROR_FUN(error)
#define BASE_INFO_FUN(info)
#endif
//弱引用
#define WEAKSELF __weak __typeof(self) weakSelf = self;

#endif /* WQDefine_h */
