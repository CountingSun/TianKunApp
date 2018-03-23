//
//  HMUploadSingleImage.h
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/8/4.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SelectSucceedBlock)(UIImage *image,NSString *filePath);
@interface WQUploadSingleImage : NSObject
@property (nonatomic,copy)SelectSucceedBlock selectSucceedBlock;

+(instancetype)manager;
-(void)showUpImagePickerWithVC:(UIViewController *)vc compression:(CGFloat)compression selectSucceedBlock:(SelectSucceedBlock)selectSucceedBlock;



@end
