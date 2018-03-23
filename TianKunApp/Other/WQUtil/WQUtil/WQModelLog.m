//
//  WQModelLog.m
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/21.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "WQModelLog.h"
#import <objc/runtime.h>

@implementation WQModelLog
+ (NSString *)logClassPropertWithClass:(id)modelClass{
    
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
        uint count;
    
        objc_property_t *properties = class_copyPropertyList([modelClass class], &count);
        for (int i = 0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *name = @(property_getName(property));
            id value = [modelClass valueForKey:name]?:@"";//默认值为nil字符串
            [dict setObject:value forKey:name];
        }
    
        free(properties);
    
        return [NSString stringWithFormat:@"%@: %p> -- %@",[self class],self,dict];

}
@end
