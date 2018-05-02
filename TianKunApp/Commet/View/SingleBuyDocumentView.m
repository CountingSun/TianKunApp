//
//  SingleBuyDocumentView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SingleBuyDocumentView.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>

@interface SingleBuyDocumentView()

@property (nonatomic ,strong) NSMutableDictionary *dict;
@property (nonatomic, copy) NSString *orderStr;

@end

@implementation SingleBuyDocumentView
- (instancetype)initWithNib{

    return [[NSBundle mainBundle] loadNibNamed:@"SingleBuyDocumentView" owner:nil options:nil].firstObject;
}
- (void)setDocumentID:(NSInteger)documentID{
    _documentID = documentID;

}
- (void)awakeFromNib{
    [super awakeFromNib];
    _alyButton.spacingBetweenImageAndTitle = 10;
    _wxButton.spacingBetweenImageAndTitle = 10;
    [_alyButton setImagePosition:QMUIButtonImagePositionLeft];
    [_wxButton setImagePosition:QMUIButtonImagePositionLeft];
    self.backgroundColor = UIColorMask;
}
- (IBAction)alyButtpnClick:(id)sender {
//    if (_delegate) {
//        [_delegate aliPayButtonClick];
//    }
    [self getAliOrder];
}
- (IBAction)wxButtonClick:(id)sender {
//    if (_delegate) {
//        [_delegate wxButtonClick];
//    }
    [self getWXOrder];
}
- (IBAction)closeButtonClick:(id)sender {
    [self hiddenSingleBuyDocumentView];
    
}
- (void)showSingleBuyDocumentView{
    self.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self];

}

- (void)hiddenSingleBuyDocumentView{
    self.hidden = YES;
    [self removeFromSuperview];

}
- (void)getAliOrder{
    
    if (_documentID) {
        if ([UserInfoEngine isLogin]) {
            [SVProgressHUD showWithStatus:@"正在生成订单信息，请稍候"];

            [[[NetWorkEngine alloc] init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname,@"content_id":@(_documentID)} url:BaseUrl(@"Learningbuy/insertuserbuylearning.action") succed:^(id responseObject) {
                NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                if (code == 1) {
                    _orderStr = [[responseObject objectForKey:@"value"] objectForKey:@"orderinfo"];
                    [self aliPay];

                }else{
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                }
            } errorBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:NET_ERROR_TOST];
            }];
            
        }

    }else{
        [SVProgressHUD showErrorWithStatus:@"当前资料无效"];
    }
    
}
- (void)getWXOrder{
    if (_documentID) {
        if ([UserInfoEngine isLogin]) {
            [SVProgressHUD showWithStatus:@"正在生成订单信息，请稍候"];
            
            [[[NetWorkEngine alloc] init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname,@"content_id":@(_documentID)} url:BaseUrl(@"Learningbuy/wxPay_learning.action") succed:^(id responseObject) {
                NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                if (code == 1) {
                    _dict = [[responseObject objectForKey:@"value"] objectForKey:@"ordermessage"];
                    [self wxPay];

                }else{
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                }
            } errorBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:NET_ERROR_TOST];
            }];
            
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前资料无效"];
    }

}
// NOTE: 调用支付结果开始支付

- (void)aliPay{
    NSString *appScheme = ALIPAY_SCHEMES;
    
    
    // NOTE: 调用支付结果开始支付
    
    [[AlipaySDK defaultService] payOrder:_orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        
        NSString * memo = resultDic[@"memo"];
        
        NSLog(@"===memo:%@", memo);
        
        if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:memo];
            
        }
        
        
        
    }];
    
    [AppDelegate sharedAppDelegate].aliPayFinishBlock = ^(NSDictionary *resultDic) {
        [self hiddenSingleBuyDocumentView];

        NSLog(@"reslut = %@",resultDic);
        
        NSString * memo = resultDic[@"memo"];
        
        NSLog(@"===memo:%@", memo);
        
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            
            
            
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            if (_pauSucceedBlock) {
                _pauSucceedBlock();
            }
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:memo];
            
        }
        
    };

}
- (void)wxPay{
    if (![WXApi isWXAppInstalled]){
        [SVProgressHUD showErrorWithStatus:@"请先安装微信"];
        
        
    }else if(![WXApi isWXAppSupportApi]){
        [SVProgressHUD showErrorWithStatus:@"请更新微信版本"];
        
    }else{
        //调起微信支付
        NSMutableString *stamp  = [_dict objectForKey:@"timestamp"];
        
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [_dict objectForKey:@"partnerid"];
        req.prepayId            = [_dict objectForKey:@"prepayid"];
        req.nonceStr           = [_dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package = [_dict objectForKey:@"package"];
        req.sign                = [_dict objectForKey:@"sign"];
        [WXApi sendReq:req];
        
        
        [AppDelegate sharedAppDelegate].wexinPayFinishBlock  = ^(NSInteger errorCode,NSString *message) {
            [self hiddenSingleBuyDocumentView];
            switch (errorCode) {
                case 0:
                {
                    [SVProgressHUD showErrorWithStatus:@"支付结果：成功！"];
                    if (_pauSucceedBlock) {
                        _pauSucceedBlock();
                    }

                }
                    break;
                case -1:
                {
                    [SVProgressHUD showErrorWithStatus:@"支付结果：失败！"];
                    
                }
                    break;
                case -2:{
                    [SVProgressHUD showErrorWithStatus:@"用户已经退出支付！"];
                }
                    break;
                    
                default:{
                    [SVProgressHUD showErrorWithStatus:message];
                    
                }
                    break;
            }
        };
        
        
    }
    
    
}

@end
