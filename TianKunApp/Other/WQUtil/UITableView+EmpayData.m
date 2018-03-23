//
//  UITableView+EmpayData.m
//  KMEEN.ZF
//
//  Created by Rookie on 16/5/12.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "UITableView+EmpayData.h"

@implementation UITableView (EmpayData)


- (void)tableViewDisplayWitMsg:(NSString *)message withImage:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger) rowCount{
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
//        UIImage *BGImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        UIImage *BGImage = [UIImage imageNamed:imageName];
        BGImageView.image = BGImage;
        [bgView2 addSubview:BGImageView];
        
        [BGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView2);
            make.width.offset(120);
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
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)tableViewDisplayWitMsg:(NSString *)message withImage:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger) rowCount width:(CGFloat)widthIs height:(CGFloat)heightIs{
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
            make.width.offset(widthIs);
            make.height.offset(heightIs);
            
            
        }];
        
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
        messageLabel.font = [UIFont systemFontOfSize:17];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [bgView2 addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(BGImageView);
            make.centerX.equalTo(bgView2);
            make.width.offset(message.length*18);
            make.height.offset(55);
            
            
            
        }];

        
        self.backgroundView = bgView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


- (void)tableViewDisplayWitMsg:(NSString *)message  ifNecessaryForRowCount:(NSUInteger)rowCount  {
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [messageLabel sizeToFit];
        
        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


- (void)tableViewDisplayWitMsg:(NSString *)message  ifNecessaryForRowCount:(NSUInteger)rowCount offset:(CGFloat)offset {
    
    if (rowCount == 0) {
        
        UIView *bgView = [[UIView alloc] init];
        
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.width.offset(200);
            make.height.offset(30);
            make.centerX.offset(SCREEN_WIDTH/2+offset);
            
            
            
            
        }];

//        messageLabel.sd_layout.centerXEqualToView(bgView).centerYIs(kScreeHeight/2+offset).widthIs(200).heightIs(30);
        
        self.backgroundView = bgView;
        
    } else {
        self.backgroundView = nil;
    }
    
}


@end
