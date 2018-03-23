//
//  WQAppInfo.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WQAppInfo : NSObject
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

#pragma mark - ----------------------- APP信息 -----------------------


/**
 view背景色
 
 @return uicolor
 */
+(UIColor *)backGroundColor;

/**
 主题色
 
 @return UIcolor
 */
+(UIColor *)themColor;

/**
 导航栏颜色
 
 @return UIcolor
 */
+(UIColor *)navColor;

/**
 大部分的按钮的颜色
 
 @return UIcolor
 */
+(UIColor *)buttonColor;



/**
 登录页面分割线颜色
 
 @return UIcolor
 */
+(UIColor *)texeFieldSpColor;

/**
 view背景色
 
 @return UIcolor
 */
+(UIColor *)viewBackColor;





/**
 屏幕宽度
 
 @return CGFloat
 */
+(CGFloat)appScreenWidth;

/**
 屏幕高度
 
 @return CGFloat
 */
+(CGFloat)appScreenHeight;

/**
 默认文字黑色
 
 @return UIColor
 */
+(UIColor *)defTexeDeep;

/**
 默认文字灰色
 
 @return UIColor
 */
+(UIColor *)defTextLight;

/**
 默认背景色
 
 @return UIColor
 */
+(UIColor *)defBackgroundColor;

/**
 引用背景灰色
 
 @return UIColor
 */
+(UIColor *)defReferenceBackgroundColor;

/*
 iOS的版本号，一个叫做Version，一个叫做Build，这两个值都可以在Xcode 中选中target，点击“Summary”后看到。 Version在plist文件中的key是“CFBundleShortVersionString”，和AppStore上的版本号保持一致，Build在plist中的key是“CFBundleVersion”，代表build的版本号，该值每次build之后都应该增加1。
 */

/**
 appVerison
 
 @return NSString
 */
+(NSString *)appVerison;

/**
 appBuild
 
 @return NSString
 */
+(NSString *)appBuild;
@end;
