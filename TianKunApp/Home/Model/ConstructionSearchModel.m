//
//  ConstructionSearchModel.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ConstructionSearchModel.h"

@implementation ConstructionSearchModel

- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}
- (NSString *)name{
    if (!_name.length) {
        return @"";
    }
    return _name;
}

@end
