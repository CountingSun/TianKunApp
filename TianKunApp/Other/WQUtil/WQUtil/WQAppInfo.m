//
//  WQAppInfo.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQAppInfo.h"
#import "WQDefine.h"


@implementation WQAppInfo

/**
 view背景色
 
 @return uicolor
 */
+(UIColor *)backGroundColor{
    
    return [UIColor colorWithRed:28/255.0 green:38/255.0 blue:47/255.0 alpha:1];
}

/**
 主题色
 
 @return UIcolor
 */
+(UIColor *)themColor{
    return RGB(233, 47, 105, 1);
}
/**
 导航栏颜色
 
 @return UIcolor
 */
+(UIColor *)navColor{
    
    return [UIColor colorWithRed:45/255.0 green:55/255.0 blue:66/255.0 alpha:1];
}
/**
 大部分的按钮的颜色
 
 @return UIcolor
 */
+(UIColor *)buttonColor{
    
    return [UIColor colorWithRed:28/255.0 green:169/255.0 blue:250/255.0 alpha:1];
    
}
/**
 登录页面分割线颜色
 
 @return UIcolor
 */
+(UIColor *)texeFieldSpColor{
    
    return [UIColor colorWithRed:49/255.0 green:66/255.0 blue:80/255.0 alpha:1];
    
}
/**
 view背景色
 
 @return UIcolor
 */
+(UIColor *)viewBackColor{
    
    return [UIColor colorWithRed:35/255.0 green:48/255.0 blue:56/255.0 alpha:1];
    
}



+(CGFloat)appScreenWidth{
    
    return [UIScreen mainScreen].bounds.size.width;
}
+(CGFloat)appScreenHeight{
    
    return [UIScreen mainScreen].bounds.size.height;
}
+(UIColor *)defTexeDeep{
    
    return UIColorFromRGB(0x2A2A2A);;
    
}
+(UIColor *)defTextLight{
    
    return  UIColorFromRGB(0x7A7A7A);
}
+(UIColor *)defBackgroundColor{
    
    return  UIColorFromRGB(0xFBFBFB);
    
}
+(UIColor *)defReferenceBackgroundColor{
    
    return  UIColorFromRGB(0xdedede);
    
}
+(NSString *)appVerison{
    
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    或
    //    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
}
+(NSString *)appBuild{
    
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
