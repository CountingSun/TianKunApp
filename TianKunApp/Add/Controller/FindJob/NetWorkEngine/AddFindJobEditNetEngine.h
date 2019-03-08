//
//  AddFindJobEditNetEngine.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/8.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^succeedBlock)(NSInteger code,NSString *msg);
typedef void(^errorBlock)(NSError *error);

@interface AddFindJobEditNetEngine : NSObject

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
- (void)editWithParameterDict:(NSMutableDictionary *)parameterDict succeedBlock:(succeedBlock)succeedBlock errorBlock:(errorBlock)errorBlock ;
- (void)upLoadHeadImage:(NSData *)imageData resumeID:(NSString *) resumeID succeedBlock:(succeedBlock)succeedBlock errorBlock:(errorBlock)errorBlock ;
@end
