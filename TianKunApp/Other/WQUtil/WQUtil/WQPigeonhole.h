//
//  WQPigeonhole.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPigeonhole : NSObject
//本地化
+(void)encodeObject:(NSObject *)obj;
+(NSObject *)decodeObject;

@end
