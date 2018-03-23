//
//  NetWorkEngine.m
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/7/18.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "NetWorkEngine.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"


@implementation NetWorkEngine


/**
 监测网络状态
 
 @param baseUrl @“”
 */
- (void)monitoringnetWorkChangeWithBaseUrl:(NSString *)baseUrl networkReachabilityStatusBlock:(void(^)(NetworkReachabilityStatus networkReachabilityStatus))networkReachabilityStatusBlock{

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSURL *url = [NSURL URLWithString:baseUrl];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
                switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                WQLog(@"当前使用的是流量模式");
                        networkReachabilityStatusBlock(NetworkReachabilityStatusReachableViaWWAN);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                WQLog(@"当前使用的是wifi模式");
                        networkReachabilityStatusBlock(NetworkReachabilityStatusReachableViaWiFi);

                break;
            case AFNetworkReachabilityStatusNotReachable:
                WQLog(@"网络未连接");
                        networkReachabilityStatusBlock(NetworkReachabilityStatusNotReachable);

                break;
            case AFNetworkReachabilityStatusUnknown:
                WQLog(@"变成了未知网络状态");
                        networkReachabilityStatusBlock(NetworkReachabilityStatusUnknown);

                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"netWorkChangeEventNotification" object:@(status)];
    }];
    [manager.reachabilityManager startMonitoring];

}

- (void)postWithDict:(NSDictionary *_Nullable)dic url:(NSString *)url succed:(SucceedBlock)succed errorBlock:(ErrorBlock )errorBlock{

    _succeedBlock = succed;
    _errorBlock = errorBlock;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_succeedBlock) {
            _succeedBlock(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_errorBlock) {
            _errorBlock(error);
            
            
        }
    }];
    
}
- (void)getWithUrl:(NSString *)url succed:(SucceedBlock)succed errorBlock:(ErrorBlock)errorBlock{
    _succeedBlock = succed;
    _errorBlock = errorBlock;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_succeedBlock) {
            _succeedBlock(responseObject);
            
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_errorBlock) {
            _errorBlock(error);
            
        }

    }];
}
- (void)upLoadmageData:(NSData *)imageData Url:(NSString *)url dict:(NSDictionary *)dic succed:(SucceedBlock)succed errorBlock:(ErrorBlock)errorBlock{
    _succeedBlock = succed;
    _errorBlock = errorBlock;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"img" fileName:@"img" mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_succeedBlock) {
            _succeedBlock(responseObject);
            
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_errorBlock) {
            _errorBlock(error);
            
        }

    }];
    
}
- (void)postWithReturnDataDict:(NSDictionary *)dic url:(NSString *)url succed:(SucceedBlock)succed errorBlock:(ErrorBlock )errorBlock{
    
    _succeedBlock = succed;
    _errorBlock = errorBlock;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_succeedBlock) {
            _succeedBlock(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_errorBlock) {
            _errorBlock(error);
            
        }
    }];
    
}
- (void)postVidoWithfilePath:(NSString *)filePath url:(NSString *)url dict:(NSDictionary *)dic name:(NSString *)name fileName:(NSString *)fileName succed:(SucceedBlock)succed progressBlock:(ProgressBlock)progressBlock errorBlock:(ErrorBlock)errorBlock{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    AFHTTPRequestOperation *operation = [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]] name:name fileName:fileName mimeType:@"video/quicktime"];
        


    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succed(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        //进度
        
        if (progressBlock) {
            progressBlock(totalBytesWritten*1.0/totalBytesExpectedToWrite);

        }
        
    }];
    

    
}

@end
