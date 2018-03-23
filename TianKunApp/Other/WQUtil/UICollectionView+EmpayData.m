//
//  UICollectionView+EmpayData.m
//  JRMedical
//
//  Created by a on 16/11/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "UICollectionView+EmpayData.h"
#import "ZWVerticalAlignLabel.h"

@implementation UICollectionView (EmpayData)


- (void)collectionViewDisplayWitMsg:(NSString *)message withImage:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger) rowCount{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        
        UIView *bgView = [UIView new];
        
        UIView *bgView2 = [UIView new];
        [bgView addSubview:bgView2];
        [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.centerY.equalTo(bgView);
            make.width.offset(204);
            make.height.offset(218);
            
            
        }];

        
        UIImageView *BGImageView = [UIImageView new];
        UIImage *BGImage = [UIImage imageNamed:imageName];
        BGImageView.image = BGImage;
        [bgView2 addSubview:BGImageView];
        [BGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView2);
            make.width.offset(130);
            make.height.offset(80);
            
            
        }];

        
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
//        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.font = [UIFont systemFontOfSize:17];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
//        [messageLabel sizeToFit];
        [bgView2 addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(BGImageView);
            make.centerX.equalTo(bgView2);
            make.width.offset(message.length*18);
            make.height.offset(55);
            
            
            
        }];

        
        
        self.backgroundView = bgView;
    } else {
        self.backgroundView = nil;
    }
}



- (void)collectionViewDisplayWitMsg:(NSString *)message  ifNecessaryForRowCount:(NSUInteger)rowCount widthDuiQi:(NSInteger)tag {
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        ZWVerticalAlignLabel *messageLabel = [ZWVerticalAlignLabel new];
        
        messageLabel.text = message;
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [messageLabel sizeToFit];
        
        if (tag == 1000) {
            messageLabel.font = [UIFont systemFontOfSize:14];
        }
        else {
             messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        }

        self.backgroundView = messageLabel;
    } else {
        self.backgroundView = nil;
    }
}

@end
