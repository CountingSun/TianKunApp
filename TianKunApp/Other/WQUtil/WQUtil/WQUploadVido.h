//
//  HMUploadVido.h
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/8/10.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 取得的视频信息
 */
@interface ResultVidoInfo : NSObject



/**
 文件路径
 */
@property (nonatomic,copy) NSString *filePath;
/**
 文件大小
 */
@property (nonatomic,copy) NSString *fileSize;

@end



typedef void(^SelectVideoSucceedBlock)(ResultVidoInfo *resultVidoInfo);

@interface WQUploadVido : NSObject
+(instancetype)shared;
@property (nonatomic,copy)SelectVideoSucceedBlock selectSucceedBlock;
@property (nonatomic,strong) ResultVidoInfo *vidoInfo;

/**
 选择视频

 @param vc 展示的viewcontroller    
 @param selectSucceedBlock  selectSucceedBlock
 */
-(void)showUpVidoPickerWithVC:(UIViewController *)vc selectSucceedBlock:(SelectVideoSucceedBlock)selectSucceedBlock;

@end
