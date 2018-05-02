//
//  EducationModel.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/8.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationModel.h"
#import "MenuInfo.h"

@implementation EducationModel
+ (NSMutableArray *)arrEducation{
    
    static NSMutableArray *arrEducation;
    if (!arrEducation) {
        arrEducation = [NSMutableArray arrayWithCapacity:11];
        //        学历:0其它/1初中/2高中/3中技/4中专/5大专/6本科/7硕士/8MBA/9博士/10博士后
        MenuInfo *menInof0 = [[MenuInfo alloc]initWithMenuName:@"其他" menuIcon:@"" menuID:0];
        [arrEducation addObject:menInof0];
        MenuInfo *menInof1 = [[MenuInfo alloc]initWithMenuName:@"初中" menuIcon:@"" menuID:1];
        [arrEducation addObject:menInof1];
        MenuInfo *menInof2 = [[MenuInfo alloc]initWithMenuName:@"高中" menuIcon:@"" menuID:2];
        [arrEducation addObject:menInof2];
        MenuInfo *menInof3 = [[MenuInfo alloc]initWithMenuName:@"中技" menuIcon:@"" menuID:3];
        [arrEducation addObject:menInof3];
        MenuInfo *menInof4 = [[MenuInfo alloc]initWithMenuName:@"中专" menuIcon:@"" menuID:4];
        [arrEducation addObject:menInof4];
        MenuInfo *menInof5 = [[MenuInfo alloc]initWithMenuName:@"大专" menuIcon:@"" menuID:5];
        [arrEducation addObject:menInof5];
        MenuInfo *menInof6 = [[MenuInfo alloc]initWithMenuName:@"本科" menuIcon:@"" menuID:6];
        [arrEducation addObject:menInof6];
        MenuInfo *menInof7 = [[MenuInfo alloc]initWithMenuName:@"硕士" menuIcon:@"" menuID:7];
        [arrEducation addObject:menInof7];
        MenuInfo *menInof8 = [[MenuInfo alloc]initWithMenuName:@"MBA" menuIcon:@"" menuID:8];
        [arrEducation addObject:menInof8];
        MenuInfo *menInof9 = [[MenuInfo alloc]initWithMenuName:@"博士" menuIcon:@"" menuID:9];
        [arrEducation addObject:menInof9];
        MenuInfo *menInof10 = [[MenuInfo alloc]initWithMenuName:@"博士后" menuIcon:@"" menuID:10];
        [arrEducation addObject:menInof10];

    }
    
    return arrEducation;
}

@end
