//
//  NSString+WQString.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WQString)
#pragma mark- ---字符串相关
/**
 *  价格保留小数
 *
 *  @param doubleValue 传人的价格
 *  @param count  价格的小数点位数
 *
 *  @return NSString
 */

+ (NSString *) stringFromeDouble:(double)doubleValue decimalPlacesCount:(NSInteger) count ;

/**
 *  获取商品子类列表
 *  价格保留小数
 *
 *  @param tfloat 传人的价格
 *  @param count  价格的小数点位数
 *
 *  @return NSString
 */
+ (NSString *)stringFromeFloat:(CGFloat)tfloat decimalPlacesCount:(NSInteger) count;

//MD5加密
-(NSString *)stringToMD5;

/**
 返回值是该字符串所占的大小
 
 @param font 字体大小
 @param size 在最大size
 @return CGSize
 */
-(CGSize)boundingRectWithFont:(UIFont *)font maxSize:(CGSize)size;

/**
 替换空指针为空字符串
 @return @""
 */
-(NSString *)stringReplaceNull;
/**
 去掉字符串中的空格
 
 
 @return NSString
 */
-(NSString *)stringDeleteBlank;
/**
 去除掉首尾的空白字符和换行字
 
 @return <#return value description#>
 */
-(NSString *)stringTackOutBlankLine;

/**
 去除掉首尾的空白字符
 
 @return <#return value description#>
 */
-(NSString *)stringTackOutBlank;
#pragma mark- ---富文本相关
/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)attriStrHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width ;
/**
 返回一个右边带图片的富文本
 @return NSMutableAttributedString
 */

-(NSMutableAttributedString *)attriStrRightWithimage:(UIImage *)image imageFrame:(CGRect)frame;
/**
 返回一个左边带图片的富文本
 @return NSMutableAttributedString
 */

-(NSMutableAttributedString *)attriStrLeftWithimage:(UIImage *)image imageFrame:(CGRect)frame;

#pragma mark- ---判断

/**
 手机号判断
 @return BOOL
 */
- (BOOL) isMobileNum;
//
/**
 判断邮箱格式是否正确

 @return BOOL
 */
-(BOOL)isAvailableEmail;

/**
 判断是否是纯汉字

 @return BOOL
 */
- (BOOL)isChinese;

/**
 判断是否含有汉字

 @return BOOL
 */
- (BOOL)includeChinese;

#pragma mark- --- 时间相关
/**
 将后台传的秒数转换为日期格式
 
 
 @param num 后台返回的秒
 @return NSString
 */

+ (NSString *)timeReturnDate:(NSNumber *)num;

/**
 将后台传的秒数转换为日期格式
 */

+ (NSString *)timeReturnDateString:(NSString *)str;
/**
 将后台传的秒数转换为日期格式
 */

+ (NSString *)timeReturnDateString:(NSString *)str formatter:(NSString *)formatter;

/**
 服务器时间转XXX前

 @param timeString 服务器时间字符串
 @return NSString
 */
+ (NSString *)updateTimeForTimeString:(NSString *)timeString;

/**
 服务器时间转XXX前


 @param times 服务器时间
 @return return NSString
 */
+ (NSString *)updateTimeForTime:(NSInteger)times;

/**
 时间字符串转毫秒值

 @param timeString <#timeString description#>
 @param formatter <#formatter description#>
 @return <#return value description#>
 */
+ (NSString *)getMillisecondWithTimeString:(NSString*)timeString formatter:(NSString *)formatter;


/**
 将URL中的\\替换为/

 @return <#return value description#>
 */
-(NSString *)dealToCanLoadUrl;


@end
