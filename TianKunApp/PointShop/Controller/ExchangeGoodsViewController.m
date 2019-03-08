//
//  ExchangeGoodsViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/13.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ExchangeGoodsViewController.h"
#import "UserGoodsAddressInfo.h"
#import "GoodsInfo.h"

@interface ExchangeGoodsViewController ()<QMUITextViewDelegate ,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *linkManTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet QMUITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger isHaveAddress;
@property (nonatomic ,strong) UserGoodsAddressInfo *addressInfo;
@property (weak, nonatomic) IBOutlet UIButton *sureBUtton;
@property (weak, nonatomic) IBOutlet QMUITextView *memoTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoTextViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@end

@implementation ExchangeGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
    
    
    [self showWithStatus:NET_WAIT_TOST];
    
    [self getAddress];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:COLOR_THEME] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.titleView.tintColor = [UIColor whiteColor];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)setView{
    [self.titleView setTitle:@"设置地址"];
    _addressTextView.delegate = self;
    _addressTextView.autoResizable = YES;
    
    _memoTextView.delegate = self;
    _memoTextView.autoResizable = YES;
    


    
    _addressInfo = [[UserGoodsAddressInfo alloc] init];
    _pointLabel.text = [NSString stringWithFormat:@"所需积分：%@",@(_goodsInfo.integral)];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    
    

}
- (void)getAddress{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [dict setObject:@(1) forKey:@"page"];
    [dict setObject:@(1) forKey:@"count"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TkSpCommodityAPPController/selectaddressbyuser.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self dismiss];
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                NSDictionary *dict = arr[0];
                _addressInfo = [UserGoodsAddressInfo mj_objectWithKeyValues:dict];
                _isHaveAddress = YES;
                
                _linkManTextField.text = _addressInfo.user_name;
                _phoneTextField.text = _addressInfo.phone;
                _addressTextView.text = _addressInfo.addres;
                
            }else{
                _isHaveAddress = NO;
                
            }
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
    

}
- (void)saveAddress{
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    NSString *urlString = @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:_linkManTextField.text forKey:@"user_name"];
    [dict setObject:_phoneTextField.text forKey:@"phone"];
    [dict setObject:_addressTextView.text forKey:@"addres"];
    if (_memoTextView.text.length) {
        [dict setObject:_memoTextView.text forKey:@"remarks"];

    }else{
        [dict setObject:@"" forKey:@"remarks"];

    }
    
    [dict setObject:@(1) forKey:@"stick"];

    if (_isHaveAddress) {
        urlString = @"TkSpCommodityAPPController/updateaddress.action";
        [dict setObject:@(_addressInfo.addressID) forKey:@"id"];

    }else{
        urlString = @"TkSpCommodityAPPController/insertaddress.action";
    }
    
    [self.netWorkEngine postWithDict:dict url:BaseUrl(urlString) succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            
            if (_isHaveAddress) {
                
            }else{
                _addressInfo.addressID = [[responseObject objectForKey:@"value"] integerValue];
                
            }
            [self gotoBuy];
            
        }else{
            self.view.userInteractionEnabled = YES;
            
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;

    }];
    
}
- (void)gotoBuy{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [dict setObject:@(_goodsInfo.goodsID) forKey:@"spid"];
    [dict setObject:@(_addressInfo.addressID) forKey:@"addressid"];
    [dict setObject:@(1) forKey:@"number"];
    
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TkSpCommodityAPPController/redemption.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"兑换成功,请到我的兑换中查看"];
            if (_succeedBlock) {
                _succeedBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            self.view.userInteractionEnabled = YES;

        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;

    }];
    

}
- (IBAction)sureButtonClick:(id)sender {
    
    if (!_linkManTextField.text.length) {
        [self showErrorWithStatus:@"请输入收货人姓名"];
        return;
    }
    if (!_phoneTextField.text.length) {
        [self showErrorWithStatus:@"请输入电话号码"];
        return;
    }
    if (![_phoneTextField.text isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确电话号码"];
        return;

    }
    if (!_addressTextView.text.length) {
        [self showErrorWithStatus:@"请输入地址"];
        return;
    }
    
    [self saveAddress];
    

}
- (void)tapBack{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(_backView.frame, touchPoint)) {
        return NO;
    }
    
    return YES;
}
- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height{
    if (textView == _addressTextView) {
        if (height<35) {
            _textViewHeight.constant = 35;
            
        }else{
            _textViewHeight.constant = height;
        }
        [self.view layoutIfNeeded];

    }else if (textView == _memoTextView){
        if (height<35) {
            _memoTextViewHeight.constant = 35;
            
        }else{
            _memoTextViewHeight.constant = height;
        }
        [self.view layoutIfNeeded];

    }else{
        
    }
    
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
}
- (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();return theImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
