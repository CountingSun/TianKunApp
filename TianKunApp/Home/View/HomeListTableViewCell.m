//
//  HomeListTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeListTableViewCell.h"

@implementation HomeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_titleImageView sd_setImageWithURL:[NSURL URLWithString:@"https://image.baidu.com/search/detail?ct=503316480&z=&tn=baiduimagedetail&ipn=d&word=%E6%87%92&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=-1&cs=3438519682,1571759516&os=3425887164,1649723805&simid=3040819961,3678167725&pn=1&rn=1&di=128055766960&ln=1966&fr=&fmq=1521534195237_R&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&is=0,0&istype=2&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=0&objurl=http%3A%2F%2Fupload.hea.cn%2F2014%2F0814%2F1407999182769.jpg&rpstart=0&rpnum=0&adpicid=0"] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_11]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
