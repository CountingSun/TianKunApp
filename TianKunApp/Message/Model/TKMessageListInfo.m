//
//  TKMessageListInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "TKMessageListInfo.h"

@implementation TKMessageListInfo
- (instancetype)initWithListTitle:(NSString *)listTitle
                       listDetail:(NSString *)listDetail
                        listImage:(NSString *)listImage
                    listUnReadNum:(NSInteger)listUnReadNum
                           listID:(NSInteger)listID{
    if (self = [super init]) {
        _listTitle = listTitle;
        _listDetail = listDetail;
        _listImage = listImage;
        _listUnReadNum = listUnReadNum;
        _listID = listID;
        
        
        
        
    }
    return self;
}

@end
