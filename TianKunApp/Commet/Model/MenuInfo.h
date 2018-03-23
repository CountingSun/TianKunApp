//
//  MenuInfo.h
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/9.
//  Copyright © 2017年 seek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuInfo : NSObject
@property (nonatomic,copy) NSString *menuName;
@property (nonatomic,copy) NSString *menuIcon;
@property (nonatomic,assign) NSInteger menuID;


-(instancetype)initWithMenuName:(NSString *)menuName menuIcon:(NSString *)menuIcon menuID:(NSInteger)menuID;


@end
