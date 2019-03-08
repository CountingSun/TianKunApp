//
//  MesssageViewModel.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MesssageViewModel.h"
#import "TKMessageListInfo.h"

@implementation MesssageViewModel
+ (NSMutableArray *)arrMenu{
    
    NSMutableArray *arr = [NSMutableArray array];
    TKMessageListInfo *info0 = [[TKMessageListInfo alloc]initWithListTitle:@"系统消息" listDetail:@"系统消息里面的简介" listImage:@"消息(1)" listUnReadNum:0 listID:0];
    [arr addObject:info0];

    TKMessageListInfo *info1 = [[TKMessageListInfo alloc]initWithListTitle:@"今日推荐" listDetail:@"系统消息里面的简介" listImage:@"今日推荐" listUnReadNum:3 listID:1];
    [arr addObject:info1];

    TKMessageListInfo *info2 = [[TKMessageListInfo alloc]initWithListTitle:@"到期提醒" listDetail:@"系统消息里面的简介" listImage:@"到期提醒" listUnReadNum:0 listID:2];
    [arr addObject:info2];

    TKMessageListInfo *info3 = [[TKMessageListInfo alloc]initWithListTitle:@"专家消息" listDetail:@"系统消息里面的简介" listImage:@"专家消息" listUnReadNum:4 listID:3];
    [arr addObject:info3];
    if ([ISVipManager isOpenVip]) {
        TKMessageListInfo *info4 = [[TKMessageListInfo alloc]initWithListTitle:@"VIP客服" listDetail:@"系统消息里面的简介" listImage:@"vip客服" listUnReadNum:0 listID:4];
        [arr addObject:info4];

    }



    return arr;
    
}

@end
