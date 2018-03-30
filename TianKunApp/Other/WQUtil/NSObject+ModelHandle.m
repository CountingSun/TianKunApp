
//
//  NSObject+ModelHandle.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "NSObject+ModelHandle.h"

@implementation NSObject (ModelHandle)
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    unsigned count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t propertyValue = properties[i];
        const char *propertyNameChar = property_getName(propertyValue);
        NSString *propertyName = [NSString stringWithUTF8String:propertyNameChar];
        if ([propertyName isEqualToString:property.name]) {
            if (kObjectIsEmpty(oldValue)) {
                return @"";
            }
        }
        
        
    }
    return oldValue;
}

@end
