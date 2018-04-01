//
//  NetWorkEngine.h
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/7/18.
//  Copyright © 2017年 seek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NetworkReachabilityStatus) {
    
    NetworkReachabilityStatusUnknown          = -1,//未知网络状态
    NetworkReachabilityStatusNotReachable     = 0,//网络未连接
    NetworkReachabilityStatusReachableViaWWAN = 1,//流量模式
    NetworkReachabilityStatusReachableViaWiFi = 2,//wifi模式

};



typedef void(^SucceedBlock)(id responseObject);
typedef void(^ErrorBlock)(NSError *error);
typedef void(^ProgressBlock)(CGFloat progress);

@interface NetWorkEngine : NSObject



/**
 监测网络状态

 @param baseUrl @“”
 */
- (void)monitoringnetWorkChangeWithBaseUrl:(NSString *)baseUrl networkReachabilityStatusBlock:(void(^)(NetworkReachabilityStatus networkReachabilityStatus))networkReachabilityStatusBlock;



/**
 post请求

 @param dic 参数
 @param url URL
 @param succed 成功会回调
 @param errorBlock 失败回调
 */
- (void)postWithDict:(NSDictionary *)dic
                 url:(NSString *)url
              succed:(SucceedBlock)succed
          errorBlock:(ErrorBlock)errorBlock;

/**
 get请求

 @param url URL
 @param succed 成功会回调
 @param errorBlock 失败回调
 */
- (void)getWithUrl:(NSString *)url
            succed:(SucceedBlock)succed
        errorBlock:(ErrorBlock)errorBlock;

/**
 上传图片（NSData形式）

 @param imageData 图片data
 @param url URL
 @param dic 参数
 @param succed 成功回调
 @param errorBlock 失败回调
 */
- (void)upLoadmageData:(NSData *)imageData
                   Url:(NSString *)url
                  dict:(NSDictionary *)dic
                succed:(SucceedBlock)succed
            errorBlock:(ErrorBlock)errorBlock;

/**
 post请求 返回字符串

 @param dic 参数
 @param url URL
 @param succed 成功回调
 @param errorBlock 失败回调
 */
- (void)postWithReturnDataDict:(NSDictionary *)dic
                           url:(NSString *)url
                        succed:(SucceedBlock)succed
                    errorBlock:(ErrorBlock)errorBlock;


/**
 上传视频

 @param filePath 视频本地地址
 @param url URL
 @param dic 参数字典
 @param name 名字
 @param fileName 文件名
 @param succed 成功回调
 @param progressBlock 进度
 @param errorBlock 失败回调
 */
- (void)postVidoWithfilePath:(NSString *)filePath
                         url:(NSString *)url
                        dict:(NSDictionary *)dic
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                      succed:(SucceedBlock)succed
               progressBlock:(ProgressBlock)progressBlock
                  errorBlock:(ErrorBlock)errorBlock;



- (void)formDataUpDataWithUrl:(NSString *)url
                    paramsDic:(NSDictionary *)paramsDic
                     imageArr:(NSMutableArray<UIImage *> *)imageArr
                       succed:(SucceedBlock)succed
                   errorBlock:(ErrorBlock)errorBlock;

/**
 上传图片（NSData形式）
 
 @param imageData 图片data
 @param imageName 图片名称
 @param url URL
 @param dic 参数
 @param succed 成功回调
 @param errorBlock 失败回调
 */
- (void)upLoadmageData:(NSData *)imageData
             imageName:(NSString *)imageName
                   Url:(NSString *)url
                  dict:(NSDictionary *)dic
                succed:(SucceedBlock)succed
            errorBlock:(ErrorBlock)errorBlock;


@end
