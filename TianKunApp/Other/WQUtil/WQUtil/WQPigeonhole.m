//
//  WQPigeonhole.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/12.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQPigeonhole.h"
static NSString *fileKey = @"fileKey";
static NSString *filePath = @"Documents/muArrayFindHistory.src";

@implementation WQPigeonhole
+(void)encodeObject:(NSObject *)obj{
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:filePath];
    //1:准备存储数据的对象
    NSMutableData *data = [NSMutableData data];
    //2:创建归档对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //3:开始归档
    [archiver encodeObject:obj forKey:fileKey];
    //4:完成归档
    [archiver finishEncoding];
    //5:写入文件当中
    [data writeToFile:path atomically:YES];
    
}
+(NSObject *)decodeObject{
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:filePath];
    
    //准备解档路径
    NSData *myData = [NSData dataWithContentsOfFile:path];
    //创建反归档对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:myData];
    //反归档
    NSObject *obj = [[NSObject alloc]init];
    obj = [unarchiver decodeObjectForKey:fileKey];
    //完成反归档
    [unarchiver finishDecoding];
    
    
    return obj;
    
    
}

@end
