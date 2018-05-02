//
//  TenderBidInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenderBidInfo : NSObject

/**
 id
 */
@property (nonatomic, copy) NSString *tender_id;

/**
 标题
 */
@property (nonatomic, copy) NSString *tender_title;
/**
 '招标编号
 */
@property (nonatomic, copy) NSString *tender_number;
/**
 招标类型,1建筑/2公路/3水利/4电力/5矿长....',

 */
@property (nonatomic, copy) NSString *tender_type;

/**
 信息类型:1招标信息/2中标信息',

 */
@property (nonatomic, copy) NSString *notice_type;

/**
 采购业主'
 */
@property (nonatomic, copy) NSString *buyer;

/**
 '招标公司',

 */
@property (nonatomic, copy) NSString *initiator;

/**
 '联系人',

 */
@property (nonatomic, copy) NSString *linkman;

/**
 ''联系电话',

 */
@property (nonatomic, copy) NSString *phone;

/**
 ' '通讯地址',

 */
@property (nonatomic, copy) NSString *mailing_address;

/**
 '公告内容',

 */
@property (nonatomic, copy) NSString *notice_content;

/**
 '公告摘要',

 */
@property (nonatomic, copy) NSString *notice_summary;

/**
 '截止日期',

 */
@property (nonatomic, copy) NSString *end_date;

/**
 '邮政编码',

 */
@property (nonatomic, copy) NSString *postal_code;

/**
 内容URL
 */
@property (nonatomic, copy) NSString *notice_content_url;


/**
 图片地址
 */
@property (nonatomic, copy) NSString *tender_pictures;

@property (nonatomic, copy) NSString *tender_ym_title;
@property (nonatomic, copy) NSString *create_date;
@end
