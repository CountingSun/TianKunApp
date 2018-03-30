//
//  PublicUploadTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicUploadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (nonatomic, copy) dispatch_block_t block;
@end
