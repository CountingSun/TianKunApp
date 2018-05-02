//
//  WQTools.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <UIKit/UIKit.h>
#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);

@interface WQTools : NSObject

/**
 判断手机是否联网


 @return BOOL
 */
+ (BOOL)connectedToNetwork;

/**
 获取当前时间
 
 @param dateFormat 时间格式
 @return string
 */
+(NSString *)getNowDataWithDateFormat:(NSString *)dateFormat;

/**
 图片裁剪
 
 @param rect rect
 @return UIImage
 */
+(UIImage*)getSubImageWithImage:(UIImage *)image rect:(CGRect)rect;

/**
 图片等比例缩放
 
 @param size size
 @return UIImage
 */
+(UIImage*)scaleWithImage:(UIImage *)image size:(CGSize)size;

/**
 获取sdimage缓存大小
 
 @return NSString
 */
+(NSString *)getTmpSize;

/**
 清除缓存
 */
+ (void)clearTmpPics;

/**
 磁盘总空间

 @return CGFloat
 */
+ (CGFloat)diskOfAllSizeMBytes;

/**
 磁盘可用空间

 @return   CGFloat
 */
+ (CGFloat)diskOfFreeSizeMBytes;

/**
 获取指定路径下某个文件的大小

 @param filePath 路径
 @return <#return value description#>
 */
+ (long long)fileSizeAtPath:(NSString *)filePath;

/**
 获取文件夹下所有文件的大小

 @param folderPath <#folderPath description#>
 @return <#return value description#>
 */
+ (long long)folderSizeAtPath:(NSString *)folderPath;
//
/**
 将字符串数组按照元素首字母顺序进行排序分组

 @param array <#array description#>
 @return <#return value description#>
 */
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;
//
/**
 获取字符串(或汉字)首字母

 @param string <#string description#>
 @return <#return value description#>
 */
+ (NSString *)firstCharacterWithString:(NSString *)string;
//
/**
 获取当前时间

 @param format @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
 @return <#return value description#>
 */
+ (NSString *)currentDateWithFormat:(NSString *)format;
/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2;
/**
 将十六进制颜色转换为 UIColor 对象
 
 @param color <#color description#>
 @return <#return value description#>
 */
+ (UIColor *)colorWithHexString:(NSString *)color;


// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField

/**
 对图片进行滤镜处理

 @param image <#image description#>
 @param name <#name description#>
 @return <#return value description#>
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;

#pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)

/**
 对图片进行模糊处理

 @param image <#image description#>
 @param name <#name description#>
 @param radius <#radius description#>
 @return <#return value description#>
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;
/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

/**
  创建一张实时模糊效果 View (毛玻璃效果)

 @param frame <#frame description#>
 @return <#return value description#>
 */
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;
//
/**
 全屏截图

 @return <#return value description#>
 */
+ (UIImage *)shotScreen;
//
/**
 截取view生成一张图片

 @param view <#view description#>
 @return <#return value description#>
 */
+ (UIImage *)shotWithView:(UIView *)view;

/**
 截取view中某个区域生成一张图片

 @param view <#view description#>
 @param scope <#scope description#>
 @return <#return value description#>
 */
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;

/**
 压缩图片到指定文件大小

 @param image <#image description#>
 @param size <#size description#>
 @return <#return value description#>
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;


/**
 获取设备 IP 地址

 @return <#return value description#>
 */
+ (NSString *)getIPAddress ;
/*
 绘制虚线
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;

+(NSString *)valueStringWith:(id)object;

/**
 打电话

 @param tel 拨打电话
 */
+ (void)callWithTel:(NSString *)tel;


/**
 判断系统是否接收推送

 @return bool
 */
- (BOOL)isAllowedNotification;



@end
