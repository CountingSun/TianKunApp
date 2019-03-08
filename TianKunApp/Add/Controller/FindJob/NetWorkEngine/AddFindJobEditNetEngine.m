//
//  AddFindJobEditNetEngine.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/8.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddFindJobEditNetEngine.h"

@implementation AddFindJobEditNetEngine

- (void)editWithParameterDict:(NSMutableDictionary *)parameterDict succeedBlock:(succeedBlock)succeedBlock errorBlock:(errorBlock)errorBlock {
    
    
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    [_netWorkEngine postWithDict:parameterDict url:BaseUrl(@"update.resume") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (succeedBlock) {
            succeedBlock(code,[responseObject objectForKey:@"msg"]);
        }
        
    } errorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}
- (void)upLoadHeadImage:(NSData *)imageData resumeID:(NSString *) resumeID succeedBlock:(succeedBlock)succeedBlock errorBlock:(errorBlock)errorBlock {
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    [_netWorkEngine upLoadmageData:imageData imageName:@"pictureFile" Url:BaseUrl(@"update.resume.pictureFile.portrait") dict:@{@"id":resumeID} succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (succeedBlock) {
            succeedBlock(code,msg);
        }
        
    } errorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    

}

@end
