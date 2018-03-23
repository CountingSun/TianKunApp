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
        
        bgView2.sd_layout
        .centerXEqualToView(bgView)
        .centerYEqualToView(bgView)
        .widthIs(204)
        .heightIs(218);
        
        UIImageView *BGImageView = [UIImageView new];
//        UIImage *BGImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        UIImage *BGImage = [UIImage imageNamed:imageName];
        BGImageView.image = BGImage;
        [bgView2 addSubview:BGImageView];
        
        BGImageView.sd_layout
        .centerXEqualToView(bgView2)
        .widthIs(120)
        .heightIs(80);
        
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
//        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.font = [UIFont systemFontOfSize:17];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
//        [messageLabel sizeToFit];
        [bgView2 addSubview:messageLabel];
        
        messageLabel.sd_layout
        .topSpaceToView(BGImageView,0)
        .centerXEqualToView(bgView2)
        .widthIs(message.length*18)
        .heightIs(55);
        
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
        
        bgView2.sd_layout
        .centerXEqualToView(bgView)
        .centerYEqualToView(bgView)
        .widthIs(204)
        .heightIs(218);
        
        UIImageView *BGImageView = [UIImageView new];
        UIImage *BGImage = [UIImage imageNamed:imageName];
        BGImageView.image = BGImage;
        [bgView2 addSubview:BGImageView];
        
        BGImageView.sd_layout
        .centerXEqualToView(bgView2)
        .widthIs(widthIs)
        .heightIs(heightIs);
        
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
        messageLabel.font = [UIFont systemFontOfSize:17];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [bgView2 addSubview:messageLabel];
        
        messageLabel.sd_layout
        .topSpaceToView(BGImageView,0)
        .centerXEqualToView(bgView2)
        .widthIs(message.length*18)
        .heightIs(55);
        
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
        messageLabel.sd_layout.centerXEqualToView(bgView).centerYIs(kScreeHeight/2+offset).widthIs(200).heightIs(30);
        
        self.backgroundView = bgView;
        
    } else {
        self.backgroundView = nil;
    }
    
}


@end
