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
@property (nonatomic,copy) NSString *menuDetail;
@property (nonatomic,copy) NSString *menuLink;


-(instancetype)initWithMenuName:(NSString *)menuName menuIcon:(NSString *)menuIcon menuID:(NSInteger)menuID;
-(instancetype)initWithMenuName:(NSString *)menuName menuIcon:(NSString *)menuIcon menuID:(NSInteger)menuID menuDetail:(NSString *)menuDetail;


@end
