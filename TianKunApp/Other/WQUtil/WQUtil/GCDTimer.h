//
//  GCDTimer.h
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/27.
//  Copyright © 2017年 seek. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, ActionOption) {
    AbandonPreviousAction, // 废除同一个timer之前的任务
    MergePreviousAction    // 将同一个timer之前的任务合并到新的任务中
};

@interface GCDTimer : NSObject

+(GCDTimer *)sharedInstance;
/**
 启动一个timer，默认精度为0.01秒
 
 @param timerName timer的名称，作为唯一标识
 @param interval 执行的时间间隔
 @param queue timer将被放入的列队，也就是action执行的列队，传入nil将自动放到一个子线程队列中。
 @param repeats 是否循环
 @param action 时间间隔到点执行的block
 @param option 多次schedule同一个timer时的操作选项(目前提供将之前的任务废除或合并的选项)。
 
 */
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                          actionOption:(ActionOption)option
                                action:(dispatch_block_t)action;

/**
 撤销某个timer。
 
 @param timerName timer的名称，作为唯一标识。
 */
- (void)cancelTimerWithName:(NSString *)timerName;


/**
 *  是否存在某个名称标识的timer。
 *
 *  @param timerName timer的唯一名称标识。
 *
 *  @return YES表示存在，反之。
 */
- (BOOL)existTimer:(NSString *)timerName;

@end
