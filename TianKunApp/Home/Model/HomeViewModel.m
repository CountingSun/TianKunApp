//
//  HomeViewModel.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeViewModel.h"
#import "MenuInfo.h"

@implementation HomeViewModel
+ (NSMutableArray *)arrMenu{
        NSMutableArray *arrMenu = [NSMutableArray arrayWithCapacity:10];
        MenuInfo *menuInfo0 = [[MenuInfo alloc]initWithMenuName:@"建设企业" menuIcon:@"建设信息" menuID:0];
        [arrMenu addObject:menuInfo0];
        MenuInfo *menuInfo1 = [[MenuInfo alloc]initWithMenuName:@"从业人员" menuIcon:@"从业人员" menuID:1];
        [arrMenu addObject:menuInfo1];
        MenuInfo *menuInfo2 = [[MenuInfo alloc]initWithMenuName:@"文件通知" menuIcon:@"文件通知" menuID:2];
        [arrMenu addObject:menuInfo2];
        MenuInfo *menuInfo3 = [[MenuInfo alloc]initWithMenuName:@"公告公示" menuIcon:@"公示公告" menuID:3];
        [arrMenu addObject:menuInfo3];
        MenuInfo *menuInfo4 = [[MenuInfo alloc]initWithMenuName:@"招标信息" menuIcon:@"招标信息" menuID:4];
        [arrMenu addObject:menuInfo4];
        MenuInfo *menuInfo5 = [[MenuInfo alloc]initWithMenuName:@"中标信息" menuIcon:@"中标信息" menuID:5];
        [arrMenu addObject:menuInfo5];
        MenuInfo *menuInfo6 = [[MenuInfo alloc]initWithMenuName:@"企业招聘" menuIcon:@"企业招聘" menuID:6];
        [arrMenu addObject:menuInfo6];
        MenuInfo *menuInfo7 = [[MenuInfo alloc]initWithMenuName:@"人才求职" menuIcon:@"人才求职" menuID:7];
        [arrMenu addObject:menuInfo7];
        MenuInfo *menuInfo8 = [[MenuInfo alloc]initWithMenuName:@"互动交流" menuIcon:@"互动交流" menuID:8];
        [arrMenu addObject:menuInfo8];
        MenuInfo *menuInfo9 = [[MenuInfo alloc]initWithMenuName:@"教育培训" menuIcon:@"教育培训" menuID:9];
        [arrMenu addObject:menuInfo9];
        
    return arrMenu;
    
}
+ (NSMutableArray *)arrEasyMenu{
    NSMutableArray *arrMenu = [NSMutableArray arrayWithCapacity:10];
    MenuInfo *menuInfo0 = [[MenuInfo alloc]initWithMenuName:@"工商查询" menuIcon:@"工商查询" menuID:0];
    [arrMenu addObject:menuInfo0];
    MenuInfo *menuInfo1 = [[MenuInfo alloc]initWithMenuName:@"资质查询" menuIcon:@"自制查询" menuID:1];
    [arrMenu addObject:menuInfo1];
    MenuInfo *menuInfo2 = [[MenuInfo alloc]initWithMenuName:@"人员查询" menuIcon:@"人员查询" menuID:2];
    [arrMenu addObject:menuInfo2];
    MenuInfo *menuInfo3 = [[MenuInfo alloc]initWithMenuName:@"项目查询" menuIcon:@"项目查询" menuID:3];
    [arrMenu addObject:menuInfo3];
    MenuInfo *menuInfo4 = [[MenuInfo alloc]initWithMenuName:@"诚信查询" menuIcon:@"项目查询" menuID:4];
    [arrMenu addObject:menuInfo4];
    
    return arrMenu;
    
}

@end
