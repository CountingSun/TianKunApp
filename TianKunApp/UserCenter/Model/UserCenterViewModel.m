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
    MenuInfo *menuInof0 = [[MenuInfo alloc]initWithMenuName:@"我的收藏" menuIcon:@"收藏" menuID:0];
    [arr addObject:menuInof0];
    
    MenuInfo *menuInof1 = [[MenuInfo alloc]initWithMenuName:@"浏览足迹" menuIcon:@"足迹" menuID:1];
    [arr addObject:menuInof1];
    if ([ISVipManager isOpenVip]) {
        MenuInfo *menuInof3 = [[MenuInfo alloc]initWithMenuName:@"购买记录" menuIcon:@"购买记录" menuID:3];
        [arr addObject:menuInof3];

    }else{
        MenuInfo *menuInof4 = [[MenuInfo alloc]initWithMenuName:@"我的发布" menuIcon:@"我的发布_small" menuID:4];
        [arr addObject:menuInof4];

    }

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
    
    
    if ([UserInfoEngine getUserInfo].userID) {
        if (![UserInfoEngine getUserInfo].phone.length) {
            
        }else{
            if ([UserInfoEngine getIsHadPwd]) {
                MenuInfo *menuInof6 = [[MenuInfo alloc]initWithMenuName:@"修改密码" menuIcon:@"" menuID:6];
                [arr addObject:menuInof6];
                
            }else{
                MenuInfo *menuInof6 = [[MenuInfo alloc]initWithMenuName:@"设置密码" menuIcon:@"" menuID:6];
                [arr addObject:menuInof6];
                
            }
            
        }
        
            MenuInfo *menuInof7 = [[MenuInfo alloc]initWithMenuName:@"管理收货地址" menuIcon:@"" menuID:7];
            [arr addObject:menuInof7];
            MenuInfo *menuInof8 = [[MenuInfo alloc]initWithMenuName:@"账户关联设置" menuIcon:@"" menuID:8];
            [arr addObject:menuInof8];
            

    }


    return arr;

}
+ (NSMutableArray *)arrSetHelpMenu{
    NSMutableArray *arr = [NSMutableArray array];
    
    MenuInfo *menuInof0 = [[MenuInfo alloc]initWithMenuName:@"怎样注册成为用户" menuIcon:@"" menuID:0 menuDetail:@"howTobeUser"];
    [arr addObject:menuInof0];
    
    if ([ISVipManager isOpenVip]) {
        MenuInfo *menuInof1 = [[MenuInfo alloc]initWithMenuName:@"怎样注册成为VIP" menuIcon:@"" menuID:1 menuDetail:@"howTobeVip"];
        [arr addObject:menuInof1];

    }
    MenuInfo *menuInof2 = [[MenuInfo alloc]initWithMenuName:@"如何修改绑定手机" menuIcon:@"" menuID:2 menuDetail:@"howBundlePhone"];
    [arr addObject:menuInof2];
    
    MenuInfo *menuInof3 = [[MenuInfo alloc]initWithMenuName:@"如何修改和删除信息" menuIcon:@"" menuID:3 menuDetail:@"howEditInfo"];
    [arr addObject:menuInof3];
    
    
    
    return arr;

}
+ (NSMutableArray *)arrVipMenu{
    NSMutableArray *arr = [NSMutableArray array];
    
    MenuInfo *menuInof0 = [[MenuInfo alloc]initWithMenuName:@"资质维护" menuIcon:@"资质维护" menuID:0];
    [arr addObject:menuInof0];
    
    MenuInfo *menuInof1 = [[MenuInfo alloc]initWithMenuName:@"资质推荐" menuIcon:@"资质推荐" menuID:1];
    [arr addObject:menuInof1];
    MenuInfo *menuInof2 = [[MenuInfo alloc]initWithMenuName:@"资质申报" menuIcon:@"资质申报" menuID:2];
    [arr addObject:menuInof2];
    
    MenuInfo *menuInof3 = [[MenuInfo alloc]initWithMenuName:@"工商维护" menuIcon:@"工商维护" menuID:3];
    [arr addObject:menuInof3];
    
    MenuInfo *menuInof4 = [[MenuInfo alloc]initWithMenuName:@"安许维护" menuIcon:@"安许维护" menuID:4];
    [arr addObject:menuInof4];
    MenuInfo *menuInof5 = [[MenuInfo alloc]initWithMenuName:@"人员维护" menuIcon:@"人员维护" menuID:5];
    [arr addObject:menuInof5];
    MenuInfo *menuInof6 = [[MenuInfo alloc]initWithMenuName:@"税务咨询" menuIcon:@"税务咨询" menuID:6];
    [arr addObject:menuInof6];
    MenuInfo *menuInof7 = [[MenuInfo alloc]initWithMenuName:@"政策解读" menuIcon:@"政策解读" menuID:7];
    [arr addObject:menuInof7];
    MenuInfo *menuInof8 = [[MenuInfo alloc]initWithMenuName:@"法律咨询" menuIcon:@"法律咨询" menuID:8];
    [arr addObject:menuInof8];
    MenuInfo *menuInof9 = [[MenuInfo alloc]initWithMenuName:@"定制方案" menuIcon:@"定制方案" menuID:9];
    [arr addObject:menuInof9];
    MenuInfo *menuInof10 = [[MenuInfo alloc]initWithMenuName:@"全程免费" menuIcon:@"全程免费" menuID:10];
    [arr addObject:menuInof10];
    MenuInfo *menuInof11 = [[MenuInfo alloc]initWithMenuName:@"专属客服" menuIcon:@"专属客服" menuID:11];
    [arr addObject:menuInof11];

    
    return arr;

}

@end
