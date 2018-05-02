//
//  EductationNetworkEngine.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DocumentInfo;

@interface EductationNetworkEngine : NSObject
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;

-(void)postWithPageIndex:(NSInteger)pageIndex
                pageSize:(NSInteger)pageSize
               dataType2:(NSInteger)dataType2
               calssType:(NSInteger)calssType
returnBlock:(void(^)(NSInteger code,NSString *msg,NSMutableArray *arrData))returnBlock;

-(void)getEductationInfoWithDocumentID:(NSInteger)documentID
                           returnBlock:(void(^)(NSInteger code,NSString *msg,DocumentInfo *documentInfo))returnBlock;

@end
