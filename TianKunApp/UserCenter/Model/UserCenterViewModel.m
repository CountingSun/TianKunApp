//
//  UserCenterViewModel.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UserCenterViewModel.h"
#import "MenuInfo.h"

@implementation UserCenterViewModel
+ (NSMutableArray *)arrMenu{

    NSMutableArray *arr = [NSMutableArray array];
    
    MenuInfo *menuInof0 = [[MenuInfo alloc]initWithMenuName:@"我的收藏" menuIcon:@"我的收藏" menuID:0];
    [arr addObject:menuInof0];
    
    MenuInfo *menuInof1 = [[MenuInfo alloc]initWithMenuName:@"浏览足迹" menuIcon:@"浏览足迹" menuID:1];
    [arr addObject:menuInof1];
    MenuInfo *menuInof2 = [[MenuInfo alloc]initWithMenuName:@"设置" menuIcon:@"设置" menuID:2];
    [arr addObject:menuInof2];

    
    return arr;
    
}
+ (NSMutableArray *)arrSetMenu{
    NSMutableArray *arr = [NSMutableArray array];
    
    MenuInfo *menuInof0 = [[MenuInfo alloc]initWithMenuName:@"消息设置" menuIcon:@"" menuID:0];
    [arr addObject:menuInof0];
    
    MenuInfo *menuInof1 = [[MenuInfo alloc]initWithMenuName:@"清除缓存" menuIcon:@"" menuID:1];
    [arr addObject:menuInof1];
    MenuInfo *menuInof2 = [[MenuInfo alloc]initWithMenuName:@"帮助与反馈" menuIcon:@"" menuID:2];
    [arr addObject:menuInof2];
    
    MenuInfo *menuInof3 = [[MenuInfo alloc]initWithMenuName:@"关于我们" menuIcon:@"" menuID:3];
    [arr addObject:menuInof3];
    
    MenuInfo *menuInof4 = [[MenuInfo alloc]initWithMenuName:@"版本升级" menuIcon:@"" menuID:4];
    [arr addObject:menuInof4];
    MenuInfo *menuInof5 = [[MenuInfo alloc]initWithMenuName:@"使用协议" menuIcon:@"" menuID:5];
    [arr addObject:menuInof5];
    MenuInfo *menuInof6 = [[MenuInfo alloc]initWithMenuName:@"修改密码" menuIcon:@"" menuID:6];
    [arr addObject:menuInof6];


    return arr;

}
+ (NSMutableArray *)arrSetHelpMenu{
    NSMutableArray *arr = [NSMutableArray array];
    
    MenuInfo *menuInof0 = [[MenuInfo alloc]initWithMenuName:@"建筑一秘是干什么的？" menuIcon:@"" menuID:0];
    [arr addObject:menuInof0];
    
    MenuInfo *menuInof1 = [[MenuInfo alloc]initWithMenuName:@"成为会员有什么好处？" menuIcon:@"" menuID:1];
    [arr addObject:menuInof1];
    MenuInfo *menuInof2 = [[MenuInfo alloc]initWithMenuName:@"积分该怎么用？" menuIcon:@"" menuID:2];
    [arr addObject:menuInof2];
    
    MenuInfo *menuInof3 = [[MenuInfo alloc]initWithMenuName:@"如何赚取积分" menuIcon:@"" menuID:3];
    [arr addObject:menuInof3];
    
    
    
    return arr;

}

@end
