//
//  EductationNetworkEngine.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EductationNetworkEngine.h"
#import "DocumentInfo.h"

@implementation EductationNetworkEngine

-(void)postWithPageIndex:(NSInteger)pageIndex
                pageSize:(NSInteger)pageSize
               dataType2:(NSInteger)dataType2
               calssType:(NSInteger)calssType
             returnBlock:(void(^)(NSInteger code,NSString *msg,NSMutableArray *arrData))returnBlock{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(pageIndex) forKey:@"stratnum"];
    [dict setObject:@(pageSize) forKey:@"num"];
    [dict setObject:@(dataType2) forKey:@"k"];
    [dict setObject:@(calssType) forKey:@"l"];
    
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"Learning/selecthotlearning.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1) {
            NSMutableArray *arrData = [NSMutableArray array];

            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            for (NSDictionary *dict  in arr) {
                DocumentInfo *info = [DocumentInfo mj_objectWithKeyValues:[dict objectForKey:@"LearningData"]];
                info.collectID = [[dict objectForKey:@"shoucangrenid"] integerValue];
                [arrData addObject:info];
                
                
            }
            returnBlock(code,@"",arrData);
        }else{
            returnBlock(code,[responseObject objectForKey:@"msg"],nil);
        }

    } errorBlock:^(NSError *error) {
        returnBlock(-1,@"",nil);
    }];
    

    
}
-(void)getEductationInfoWithDocumentID:(NSInteger)documentID
                           returnBlock:(void(^)(NSInteger code,NSString *msg,DocumentInfo *documentInfo))returnBlock{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if([UserInfoEngine getUserInfo].userID){
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"uid"];
        [dict setObject:[UserInfoEngine getUserInfo].nickname forKey:@"username"];
    }
    [dict setObject:@(documentID) forKey:@"id"];
    
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"Learning/selectlearninglistbytjquanxian.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            DocumentInfo *documentInfo = [DocumentInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"value"] objectForKey:@"learning"]];
            documentInfo.collectID = [[[responseObject objectForKey:@"value"] objectForKey:@"shoucangrenid"] integerValue];
            documentInfo.canSee = [[[responseObject objectForKey:@"value"] objectForKey:@"yes"] integerValue];
            returnBlock(code,@"",documentInfo);
            
        }else{
            returnBlock(code,[responseObject objectForKey:@"msg"],nil);
        }
    } errorBlock:^(NSError *error) {
        returnBlock(-1,@"",nil);

    }];

}





@end
