//
//  AddHistoryRecordNetwork.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddHistoryRecordNetwork.h"

@implementation AddHistoryRecordNetwork
- (void)addHistoryRecodeWithDataID:(NSInteger)dataID dataType:(NSInteger)dataType  dataTypeTwo:(NSInteger)dataTypeTwo data_title:(NSString *)data_title data_sketch:(NSString *)data_sketch dataPictureUrl:(NSString *)dataPictureUrl{

    if ([UserInfoEngine getUserInfo].userID) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:@(dataID) forKey:@"data_id"];
        [dict setObject:@(dataType) forKey:@"data_type"];
        [dict setObject:@(dataTypeTwo) forKey:@"data_type_two"];
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
        if (data_title) {
            [dict setObject:data_title forKey:@"data_title"];

        }
        if (data_sketch) {
            
            if (data_sketch.length >=100) {
                data_sketch = [data_sketch substringToIndex:90];
                
            }
            [dict setObject:data_sketch forKey:@"data_sketch"];

        }
        if (dataPictureUrl) {
            [dict setObject:dataPictureUrl forKey:@"data_picture_url"];

        }

        [[[NetWorkEngine alloc] init] postWithDict:dict url:BaseUrl(@"create.watchRecord") succed:^(id responseObject) {
            
            
        } errorBlock:^(NSError *error) {
            
        }];

    }
}

@end
