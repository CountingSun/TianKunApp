//
//  IconBadgeManager.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/13.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconBadgeManager : NSObject


/**
 添加系统消息未读信息

 @param messageID 消息的ID
 */
+ (void)addSystemUnReadMessageWithMessageID:(NSString *)messageID;

/**
 判断系统消息是否已读

 @param messageID 消息的ID
 @return 否已读
 */
+ (BOOL)isContainsSystemMessageID:(NSString *)messageID;

/**
 获取系统消息未读个数

 @return 未读个数
 */
+ (NSInteger)getSystemMessagCount;

/**
 将消息标记为已读

 @param messageID 消息的ID
 */
+ (void)deleteSystemMessageWithMessageID:(NSString *)messageID;

/**
 删除所有系统消息
 */
+ (void)deleteAllSystemMessage;


/**
 添加今日推荐消息未读信息
 
 @param messageID 消息的ID
 */

+ (void)addRecomendUnReadMessageWithMessageID:(NSString *)messageID;
/**
 判断今日推荐消息是否已读
 
 @param messageID 消息的ID
 @return 否已读
 */

+ (BOOL)isContainsRecomendMessageID:(NSString *)messageID;
/**
 获取今日推荐消息未读个数
 
 @return 未读个数
 */

+ (NSInteger)getRecomendMessagCount;
/**
 将消息标记为已读
 
 @param messageID 消息的ID
 */
+ (void)deleteRecomendMessageWithMessageID:(NSString *)messageID;

/**
 删除所有今日推荐
 */
+ (void)deleteAllRecomendMessage;


/**
 获取全部未读消息个数

 @return <#return value description#>
 */
+(NSInteger)getAllUnReadCount;
/**
 添加vip未读信息
 
 @param messageID 消息的ID
 */
+ (void)addVIPUnReadMessageWithMessageID:(NSString *)messageID;
/**
 将vip消息标记为已读
 
 @param messageID 消息的ID
 */
+ (void)deleteVIPMessage;


@end
