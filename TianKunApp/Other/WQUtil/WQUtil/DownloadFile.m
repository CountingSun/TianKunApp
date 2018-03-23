//
//  DownloadFile.m
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/28.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "DownloadFile.h"
#import "AFNetworking.h"
#import "WQFile.h"


@implementation DownloadFile

-(instancetype)sharedInstance{
    
    static DownloadFile *_downloadFile = nil;
    
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadFile = [[DownloadFile alloc]init];
    });
    return _downloadFile;
}


-(void)downFileWithparamDic:(NSDictionary *)dic
                        url:(NSString *)requestUrl
                   fileType:(NSString *)fileType
                   fileName:(NSString *)fileName
                    succeed:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                       fail:(void(^)(AFHTTPRequestOperation *operation,NSError *error))fail
                   progress:(void(^)(float progress, int64_t downloadLength, int64_t totleLength))progress{
    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
    
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];

    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestUrl parameters:dic error:nil];
    
    AFHTTPRequestOperation *downLoadOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    NSString *localSavePath = [NSString stringWithFormat:@"%@/%@", [self setPathOfDocumentsByFileName:fileName], fileName];
    
    [downLoadOperation setOutputStream:[NSOutputStream outputStreamToFileAtPath:localSavePath append:NO]];
    [downLoadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        if (progress) {
            progress(p, totalBytesRead, totalBytesExpectedToRead);
        }
    }];
    [downLoadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(operation,error);
        }
    }];
    
    [downLoadOperation start];
    
    
}
/**
 *  根据文件的创建时间 设置保存到本地的路径
 * *  @param fileName 名字
 *
 *  @return
 */
-(NSString *)setPathOfDocumentsByFileName:(NSString *)fileName
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"file"]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:path]) {
        [filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


@end
