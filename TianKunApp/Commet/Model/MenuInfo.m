//
//  MenuInfo.m
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/9.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "MenuInfo.h"

@implementation MenuInfo
-(instancetype)initWithMenuName:(NSString *)menuName menuIcon:(NSString *)menuIcon menuID:(NSInteger)menuID{
    
    if (self = [super init]) {
        _menuName = menuName;
        _menuIcon = menuIcon;
        _menuID = menuID;
        
    }
    return self;
    
    
}

@end
