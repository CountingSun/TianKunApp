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
        [[NSNotificationCenter defaultCenter]postNotificationName:NET_WORK_STATES_NOTIFICATION_KEY object:@(status)];
    }];
    [manager.reachabilityManager startMonitoring];

}

- (void)postWithDict:(NSDictionary *_Nullable)dic url:(NSString *)url succed:(SucceedBlock)succed errorBlock:(ErrorBlock )errorBlock{
    
    
    WQLog(@"%@\n%@",url,dic);


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;

    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (succed) {
            succed(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (errorBlock) {
            errorBlock(error);
            
            
        }
    }];
    
}
- (void)getWithUrl:(NSString *)url succed:(SucceedBlock)succed errorBlock:(ErrorBlock)errorBlock{
    
    WQLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (succed) {
            succed(responseObject);
            
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
            
        }

    }];
}
- (void)postWithUrl:(NSString *)url
                succed:(SucceedBlock)succed
            errorBlock:(ErrorBlock)errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionary] options:NSJSONWritingPrettyPrinted error:nil];
    
    [manager POST:url parameters:[NSDictionary dictionary] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:jsonData name:@"xxxx"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (succed) {
            succed(responseObject);
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
            
        }
        
    }];
    
}

- (void)upLoadmageData:(NSData *)imageData Url:(NSString *)url dict:(NSDictionary *)dic succed:(SucceedBlock)succed errorBlock:(ErrorBlock)errorBlock{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];

    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        

//        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"image/png"];
        [formData appendPartWithFormData:jsonData name:@"xxxx"];

    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (succed) {
            succed(responseObject);
            
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
            
        }

    }];
    
}
- (void)postWithReturnDataDict:(NSDictionary *)dic url:(NSString *)url succed:(SucceedBlock)succed errorBlock:(ErrorBlock )errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (succed) {
            succed(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
            
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
- (void)formDataUpDataWithUrl:(NSString *)url
                    paramsDic:(NSDictionary *)paramsDic
                     imageArr:(NSMutableArray<UIImage *> *)imageArr
                       succed:(SucceedBlock)succed
                   errorBlock:(ErrorBlock)errorBlock{
    //设置网络请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];

    //发送网络请求  
    [manager POST:url parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSInteger i = 0; i<imageArr.count; i++) {
            UIImage *image = imageArr[i];
            NSData *data = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@""] fileName:[NSString stringWithFormat:@""] mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (succed) {
            succed(responseObject);
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {  
        if (errorBlock) {
            errorBlock(error);
            
        }

    }];  

}
- (void)upLoadmageData:(NSData *)imageData
             imageName:(NSString *)imageName
                   Url:(NSString *)url
                  dict:(NSDictionary *)dic
                succed:(SucceedBlock)succed
            errorBlock:(ErrorBlock)errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];

    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        if (imageData) {
            
            [formData appendPartWithFileData:imageData name:imageName fileName:@"file.png" mimeType:@"image/png"];
        }
        if (dic) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            [formData appendPartWithFormData:jsonData name:@"xxxx"];
        }

        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (succed) {
            succed(responseObject);
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
            
        }
        
    }];
    
}
- (void)uploadImagesWithArrImageData:(NSMutableArray *)arrImageData
                       url:(NSString *)url
                      dict:(NSDictionary *)dic
                      name:(NSString *)name
                  fileName:(NSString *)fileName
                    succed:(SucceedBlock)succed
             progressBlock:(ProgressBlock)progressBlock
                errorBlock:(ErrorBlock)errorBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    AFHTTPRequestOperation *operation = [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        for (NSInteger i = 0; i<arrImageData.count; i++) {
            // 设置上传图片的名字
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@-%@.png", str,@(i)];
            
            [formData appendPartWithFileData:arrImageData[i] name:@"pictureFile" fileName:fileName mimeType:@"image/png"];
        }
        if (dic) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            [formData appendPartWithFormData:jsonData name:@"xxxx"];
        }
        

        
        
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
