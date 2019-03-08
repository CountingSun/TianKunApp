//
//  ManagerAddressViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ManagerAddressViewController.h"
#import "UserGoodsAddressInfo.h"

@interface ManagerAddressViewController ()<QMUITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet QMUITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightCon;
@property (nonatomic ,assign) NSInteger isHaveAddress;
@property (nonatomic ,strong) UserGoodsAddressInfo *addressInfo;

@end

@implementation ManagerAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 20;
    _addressTextView.delegate = self;
    _addressTextView.autoResizable = YES;
    _addressInfo = [[UserGoodsAddressInfo alloc] init];

    [self.titleView setTitle:@"管理收货地址"];
    [self showWithStatus:NET_WAIT_TOST];
    
    [self getAddress];

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
                
                _nameTextField.text = _addressInfo.user_name;
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

- (IBAction)sureButtonClick:(id)sender {
    
    if (!_nameTextField.text.length) {
        [self showErrorWithStatus:@"请输入收货人姓名"];
        return;
    }
    if (!_phoneTextField.text.length) {
        [self showErrorWithStatus:@"请输入手机号码"];
        return;

    }
    if (![_phoneTextField.text isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确的手机号码"];
        return;
        
    }
    if (!_addressTextView.text.length) {
        [self showErrorWithStatus:@"请输入收货地址"];
        return;

    }
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    NSString *urlString = @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:_nameTextField.text forKey:@"user_name"];
    [dict setObject:_phoneTextField.text forKey:@"phone"];
    [dict setObject:_addressTextView.text forKey:@"addres"];
    
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

            [self showSuccessWithStatus:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
//            if (_isHaveAddress) {
//
//            }else{
//                _addressInfo.user_name = _nameTextField.text  ;
//                _addressInfo.phone = _phoneTextField.text  ;
//                _addressInfo.addres = _addressTextView.text  ;
//
//                _addressInfo.addressID = [[responseObject objectForKey:@"value"] integerValue];
//
//            }
            
        }else{
            self.view.userInteractionEnabled = YES;
            
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;
        
    }];


}
- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height{
    if (height<35) {
        _textViewHeightCon.constant = 35;
        
    }else{
        _textViewHeightCon.constant = height;
    }
    [self.view layoutIfNeeded];
    
}

- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
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
