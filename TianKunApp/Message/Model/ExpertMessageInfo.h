//
//  ExpertMessageInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertMessageInfo : NSObject
@property (nonatomic, copy) NSString *messageTitle;
@property (nonatomic, copy) NSString *messageDetail;
@property (nonatomic, copy) NSString *messageTime;

@property (nonatomic ,assign) BOOL isOpen;
@end
