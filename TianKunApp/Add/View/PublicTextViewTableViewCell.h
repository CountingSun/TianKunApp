//
//  PublicTextViewTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicTextViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (nonatomic, copy) void(^textViewChangeBlock)(NSString *text);

@end
