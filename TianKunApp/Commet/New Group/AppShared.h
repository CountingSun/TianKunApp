//
//  AppShared.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppShared : NSObject
+(void)shareParamsByText:(NSString *)text
                  images:(id)images
                     url:(NSString *)url
                   title:(NSString *)title;
+(void)shareParamsByText:(NSString *)text
                  images:(id)images
                     url:(NSString *)url
                   title:(NSString *)title
            succeedBlock:(void(^)(NSInteger type))succeedBlock;

@end
