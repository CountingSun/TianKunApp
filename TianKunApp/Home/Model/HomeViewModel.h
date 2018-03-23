//
//  HomeViewModel.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

/**
 返回首页最上面的view的数组

 @return <#return value description#>
 */
+ (NSMutableArray *)arrMenu;
/**
 便民服务view的数组
 
 @return <#return value description#>
 */
+ (NSMutableArray *)arrEasyMenu;

@end
