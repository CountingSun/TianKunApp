
//
//  IconBadgeManager.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/13.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "IconBadgeManager.h"
#import "UnreadMessageModel.h"
#import <RongIMKit/RongIMKit.h>
#import <JPush/JPUSHService.h>

#define SYSTEM_MESSAGE_PATH @"TianKunSystemUnReadMessage"
#define RECOMEND_MESSAGE_PATH @"TianKunRecomendUnReadMessage"
#define VIP_MESSAGE_PATH @"TianKunVIPUnReadMessage"

@interface IconBadgeManager()

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger unReadCount;


@end;


@implementation IconBadgeManager
+ (void)addSystemUnReadMessageWithMessageID:(NSString *)messageID{
    
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:SYSTEM_MESSAGE_PATH];
    
    NSMutableArray *arrAddIds = [NSMutableArray array];
    [arrAddIds insertObject:messageID atIndex:0];
    
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (arrMessageIds) {
        [arrAddIds addObjectsFromArray:arrMessageIds];
    }
    if ([NSKeyedArchiver archiveRootObject:arrAddIds toFile:filePath]) {
        WQLog(@"添加系统未读消息成功");
    }else{
        WQLog(@"添加系统未读消息失败");
    }
}
+ (BOOL)isContainsSystemMessageID:(NSString *)messageID{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:SYSTEM_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

    if (!arrMessageIds) {
        WQLog(@"不包含该条系统消息");
        return NO;
    }else{
        if ([arrMessageIds containsObject:messageID]) {
            WQLog(@"包含该条系统消息：%@",messageID);
            return YES;
        }else{
            WQLog(@"不包含该条系统消息");
            return NO;
        }
    }
}
+ (NSInteger)getSystemMessagCount{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:SYSTEM_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!arrMessageIds) {
        return 0;
    }else{
        return arrMessageIds.count;
    }
}
+ (void)deleteSystemMessageWithMessageID:(NSString *)messageID{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:SYSTEM_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

    if (arrMessageIds) {
        if ([arrMessageIds containsObject:messageID]) {
            NSMutableArray *arrAddIds = [NSMutableArray arrayWithArray:arrMessageIds];
            [arrAddIds removeObject:messageID];
            [NSKeyedArchiver archiveRootObject:arrAddIds toFile:filePath];
            NSInteger count = arrAddIds.count+ [self getSystemMessagCount];
            [JPUSHService setBadge:count];
        }
    }
}
+ (void)deleteAllSystemMessage{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:SYSTEM_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (arrMessageIds) {
        NSMutableArray *arrAddIds = [NSMutableArray arrayWithArray:arrMessageIds];
        NSInteger count = [self getAllUnReadCount] - arrAddIds.count;
        if (count<0) {
            count = 0;
        }
        [arrAddIds removeAllObjects];
        [NSKeyedArchiver archiveRootObject:arrAddIds toFile:filePath];
        
        [JPUSHService setBadge:count];
    }

}
+ (void)addRecomendUnReadMessageWithMessageID:(NSString *)messageID{
    
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:RECOMEND_MESSAGE_PATH];
    
    NSMutableArray *arrAddIds = [NSMutableArray array];
    [arrAddIds insertObject:messageID atIndex:0];
    
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (arrMessageIds) {
        [arrAddIds addObjectsFromArray:arrMessageIds];
    }
    if ([NSKeyedArchiver archiveRootObject:arrAddIds toFile:filePath]) {
        WQLog(@"添加今日推荐未读消息成功");
    }else{
        WQLog(@"添加系统未读消息失败");
    }
}
+ (BOOL)isContainsRecomendMessageID:(NSString *)messageID{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:RECOMEND_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (!arrMessageIds) {
        return NO;
    }else{
        if ([arrMessageIds containsObject:messageID]) {
            return YES;
        }else{
            return NO;
        }
    }
}
+ (NSInteger)getRecomendMessagCount{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:RECOMEND_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!arrMessageIds) {
        return 0;
    }else{
        return arrMessageIds.count;
    }
}
+ (void)deleteRecomendMessageWithMessageID:(NSString *)messageID{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:RECOMEND_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (arrMessageIds) {
        if ([arrMessageIds containsObject:messageID]) {
            NSMutableArray *arrAddIds = [NSMutableArray arrayWithArray:arrMessageIds];
            [arrAddIds removeObject:messageID];
            [NSKeyedArchiver archiveRootObject:arrAddIds toFile:filePath];
            NSInteger count = arrAddIds.count +[self getSystemMessagCount];
            [JPUSHService setBadge:count];
        }
    }
}
+ (void)deleteAllRecomendMessage{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:RECOMEND_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (arrMessageIds) {
        NSMutableArray *arrAddIds = [NSMutableArray arrayWithArray:arrMessageIds];
        NSInteger count = [self getAllUnReadCount] - arrAddIds.count;
        if (count<0) {
            count = 0;
        }
        [arrAddIds removeAllObjects];
        [NSKeyedArchiver archiveRootObject:arrAddIds toFile:filePath];
        
        [JPUSHService setBadge:count];
    }
    
}

+(NSInteger)getAllUnReadCount{
    return [self getSystemMessagCount] + [self getRecomendMessagCount] +[self getVIPMessagCount];
    
}
/**
 添加vip未读信息
 
 @param messageID 消息的ID
 */
+ (void)addVIPUnReadMessageWithMessageID:(NSString *)messageID{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:VIP_MESSAGE_PATH];
    
    NSMutableArray *arrAddIds = [NSMutableArray array];
    [arrAddIds insertObject:messageID atIndex:0];
    
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (arrMessageIds) {
        [arrAddIds addObjectsFromArray:arrMessageIds];
    }
    if ([NSKeyedArchiver archiveRootObject:arrAddIds toFile:filePath]) {
        WQLog(@"添加今日推荐未读消息成功");
    }else{
        WQLog(@"添加系统未读消息失败");
    }

}
/**
 将vip消息标记为已读
 
 @param messageID 消息的ID
 */
+ (void)deleteVIPMessage{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:VIP_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (arrMessageIds) {
            NSMutableArray *arrAddIds = [NSMutableArray arrayWithArray:arrMessageIds];
            NSInteger count = [self getAllUnReadCount] - arrAddIds.count;
        if (count<0) {
            count = 0;
        }
            [arrAddIds removeAllObjects];
            [NSKeyedArchiver archiveRootObject:arrAddIds toFile:filePath];

            [JPUSHService setBadge:count];
    }

}

+ (NSInteger)getVIPMessagCount{
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doucumentPath stringByAppendingPathComponent:VIP_MESSAGE_PATH];
    NSArray *arrMessageIds = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!arrMessageIds) {
        return 0;
    }else{
        return arrMessageIds.count;
    }
}

@end
