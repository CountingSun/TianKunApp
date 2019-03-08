//
//  ISVipManager.m
//  TianKunApp
//
//  Created by 天堃 on 2018/7/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ISVipManager.h"

@implementation ISVipManager
+ (void)getIsOpenVip:(void(^)(NSString *isOpen))succeedBlock{
    [[[NetWorkEngine alloc] init] postWithDict:@{@"version":@"1.1.0"} url:BaseUrl(@"lg/requeststatus.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSString *valueData = [responseObject objectForKey:@"value"];
//            valueData = @"1";
            succeedBlock(valueData);
            
        }else{
            succeedBlock(@"0");

        }

    } errorBlock:^(NSError *error) {
        succeedBlock(@"0");
    }];

}

+ (BOOL)isOpenVip{
    NSString *isOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"IS_REVIEWVERSION"];
    if ([isOpen isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
    
}

+ (void)setIsOpenVip:(NSString *)isVIP{
    NSString *isOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"IS_REVIEWVERSION"];
    if (isOpen.length) {
        if ([isOpen isEqualToString:@"0"]) {
            [[NSUserDefaults standardUserDefaults] setObject:isVIP forKey:@"IS_REVIEWVERSION"];

        }else{
            
        }
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:isVIP forKey:@"IS_REVIEWVERSION"];
    }

}
@end
