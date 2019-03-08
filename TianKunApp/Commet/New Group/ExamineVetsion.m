//
//  ExamineVetsion.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/9.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ExamineVetsion.h"

#define VERSION_KEY @"NowVersion"
@implementation ExamineVetsion

+(void)examineVetsion{
    [[[NetWorkEngine alloc] init] postWithDict:@{@"type":@"1"} url:BaseUrl(@"UpdateVersionsController/selectupdateversionbytype.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSString *version = [[responseObject objectForKey:@"value"] objectForKey:@"number"];
            
            NSInteger versionInt = [[version stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            
            
            NSString *appVersion = [WQTools appVersion];
            NSInteger appVersionInt  = [[appVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];

            
            if (versionInt>appVersionInt) {
                NSString *isUp = [[NSUserDefaults standardUserDefaults] objectForKey:version];
                if (![isUp isEqualToString:@"YES"]) {
                    [WQAlertController showAlertControllerWithTitle:@"提示" message:@"发现新版本，是否前去App Store更新？" sureButtonTitle:@"去更新" cancelTitle:@"不再提示" sureBlock:^(QMUIAlertAction *action) {
                        NSURL *url = [NSURL URLWithString:[[responseObject objectForKey:@"value"] objectForKey:@"url"]];
                        [[UIApplication sharedApplication] openURL:url];
                    } cancelBlock:^(QMUIAlertAction *action) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:version];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }];
                }
            }
        }
    } errorBlock:^(NSError *error) {
    }];

}

@end
