//
//  AddBusinessCooperationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddBusinessCooperationViewController.h"
#import "UserInfoEditTableViewCell.h"
#import "CooperationInfo.h"
#import "CooperationSelectAddressView.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "AddressInfo.h"
#import "NSString+WQString.h"
#import "SelectAddressViewController.h"
#import "FilterInfo.h"

@interface AddBusinessCooperationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet QMUITextView *introductTextField;
@property (nonatomic ,strong) QMUIButton *saveButton;
@property (nonatomic ,strong) CooperationInfo *cooperationInfo;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) CooperationSelectAddressView *addressView;
@property (nonatomic ,assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic ,strong) NSMutableArray *arrResult;
@property (nonatomic, copy) NSString *addressIDsString;
@property (nonatomic, copy) NSString *addressNamesString;
@property (nonatomic ,assign) NSInteger isFromEdit;


@end

@implementation AddBusinessCooperationViewController
- (instancetype)initWithCooperationInfo:(CooperationInfo *)cooperationInfo succeedBlock:(EditCooperationInfoSucceedBlock)succeedBlock{
    if (self = [super init]) {
        _cooperationInfo = cooperationInfo ;
        _addressIDsString = [cooperationInfo.action_scope stringByReplacingOccurrencesOfString:@"[" withString:@""];
        _addressIDsString = [_addressIDsString stringByReplacingOccurrencesOfString:@"]" withString:@""];
        _addressIDsString = [_addressIDsString stringByReplacingOccurrencesOfString:@"\"" withString:@""];

        _addressNamesString = [cooperationInfo.action_scope_name stringByReplacingOccurrencesOfString:@"[" withString:@""];
        _addressNamesString = [_addressNamesString stringByReplacingOccurrencesOfString:@"]" withString:@""];

        _succeedBlock = succeedBlock;
        _isFromEdit = 100;
        
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    if (_isFromEdit == 100) {
        [self.tableView reloadData];
        _introductTextField.text = _cooperationInfo.content;
        
    }
    

}
- (void)setupUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _footView;
    _tableView.rowHeight = 45;
    if (!_cooperationInfo) {
        _cooperationInfo = [[CooperationInfo alloc]init];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoEditTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoEditTableViewCell"];
    
    [self.titleView setTitle:@"商务合作"];
    _saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    if (_isFromEdit == 100) {
        [_saveButton setTitle:@"保存" forState:0];
    }else{
        [_saveButton setTitle:@"发布" forState:0];
    }

    [_saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [_saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [view addSubview:_saveButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];

}
- (void)seve{
    if (!_cooperationInfo.initiator.length) {
        [self showErrorWithStatus:@"请输入单位名称"];
        return;
    }
    if (!_cooperationInfo.phone.length) {
        [self showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    if (![_cooperationInfo.phone isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确的手机号码"];
        return;

    }
//    if (!_cooperationInfo.address.length&&!_cooperationInfo.addressDetail) {
//        [self showErrorWithStatus:@"请选择服务区域"];
//        return;
//    }
    if (!_cooperationInfo.linkman.length) {
        [self showErrorWithStatus:@"请输入联系人"];
        return;
    }
    if (!_cooperationInfo.provinces_id.length) {
        [self showErrorWithStatus:@"请选择企业属地"];
        return;
    }
    if (!_cooperationInfo.address.length) {
        [self showErrorWithStatus:@"请输入商家地址"];
        return;
    }
    
    if (!_introductTextField.text.length) {
        [self showErrorWithStatus:@"请输入服务内容"];
        return;
    }
    [self showWithStatus:NET_WAIT_TOST];
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:_cooperationInfo.initiator forKey:@"initiator"];
    [dict setObject:_cooperationInfo.phone forKey:@"phone"];
    [dict setObject:_cooperationInfo.linkman forKey:@"linkman"];
    [dict setObject:_cooperationInfo.address forKey:@"address"];
    [dict setObject:_introductTextField.text forKey:@"content"];
    
    [dict setObject:_cooperationInfo.provinces_name forKey:@"provinces_name"];
    [dict setObject:_cooperationInfo.provinces_id forKey:@"provinces_id"];
    [dict setObject:_cooperationInfo.cities_id forKey:@"cities_id"];
    [dict setObject:_cooperationInfo.cities_name forKey:@"cities_name"];

//    [dict setObject:_cooperationInfo.longitude forKey:@"longitude"];
//    [dict setObject:_cooperationInfo.latitude forKey:@"latitude"];
    
    NSString *urlString = @"";
    
    if (_isFromEdit == 100) {
        [dict setObject:@(_cooperationInfo.hits_show) forKey:@"hits_show"];
        [dict setObject:@(_cooperationInfo.hits_record) forKey:@"hits_record"];
        [dict setObject:@(_cooperationInfo.delete_flag) forKey:@"delete_flag"];
        [dict setObject:@(_cooperationInfo.cooperationID) forKey:@"id"];

        urlString =  BaseUrl(@"update.cooperationRequest");

    }else{
        urlString =  BaseUrl(@"create.cooperationRequest");
    }
    self.view.userInteractionEnabled = NO;
    
    [_netWorkEngine postWithDict:dict url:urlString succed:^(id responseObject) {
        self.view.userInteractionEnabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (_isFromEdit == 100) {
                [self showSuccessWithStatus:@"修改成功"];
            }else{
                [self showSuccessWithStatus:@"发布成功"];
            }
            self.view.userInteractionEnabled = NO;
            _cooperationInfo.content =_introductTextField.text;
            _cooperationInfo.action_scope = _addressIDsString;
            
            _cooperationInfo.action_scope_name = _addressNamesString;
            
            if (_succeedBlock) {
                _succeedBlock(_cooperationInfo);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoEditTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoEditTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.indexPath = indexPath;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"名        称：";
            cell.textField.placeholder = @"请输入名称";
            cell.textField.text = _cooperationInfo.initiator;
            
            cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                _cooperationInfo.initiator = string;
                
            };
            
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"手机号码：";
            cell.textField.placeholder = @"请输入手机号码";
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            cell.textField.text = _cooperationInfo.phone;
            cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                _cooperationInfo.phone = string;
            };

        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"联  系  人：";
            cell.textField.placeholder = @"请输入联系人姓名";
            cell.textField.text = _cooperationInfo.linkman;

            cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                _cooperationInfo.linkman = string;

            };

            
        }
            break;
        case 3:
        {
            cell.titleLabel.text = @"企业属地：";
            cell.textField.placeholder = @"请选择企业属地";
            cell.textField.enabled = NO;
            if (_cooperationInfo.provinces_id.length) {
                cell.textField.text = [NSString stringWithFormat:@"%@%@",_cooperationInfo.provinces_name,_cooperationInfo.cities_name];
                
            }

        }
            break;

        case 4:
        {
            cell.titleLabel.text = @"详细地址：";
            cell.textField.placeholder = @"请选输入详细地址";
            cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                _cooperationInfo.address = string;
                
            };
            
            if (_cooperationInfo.address.length) {
                cell.textField.text = _cooperationInfo.address;
                
            }
        }
            break;
            
        default:
            break;
    }

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 3) {
//        MapViewController *vc = [[MapViewController alloc]init];
//        if (_centerCoordinate.latitude) {
//            vc.centerCoordinate = _centerCoordinate;
//        }
//        if (_cooperationInfo.address.length) {
//            vc.addressText = _cooperationInfo.address;
//        }
//        if (_cooperationInfo.addressDetail.length) {
//            vc.addressDetail = _cooperationInfo.addressDetail;
//
//        }
//
//        vc.selectSucceedBlock = ^(CLLocationCoordinate2D centerCoordinate, NSString *addressText, NSString *addressDetail) {
//            _centerCoordinate = centerCoordinate;
//
//            _cooperationInfo.longitude = [NSString stringWithFormat:@"%@",@(centerCoordinate.longitude)];
//            _cooperationInfo.latitude = [NSString stringWithFormat:@"%@",@(centerCoordinate.latitude)];
//
//            _cooperationInfo.address = [NSString stringWithFormat:@"%@",addressText];
//            _cooperationInfo.addressDetail = [NSString stringWithFormat:@"%@",addressDetail];
//
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//
//
//        };
//
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }

    if (indexPath.row == 3) {
        SelectAddressViewController *vc = [[SelectAddressViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.selectSucceedBlock = ^(FilterInfo *provinceInfo, FilterInfo *cityInfo) {
            _cooperationInfo.cities_id = cityInfo.propertyID;
            _cooperationInfo.cities_name = cityInfo.propertyName;
            
            _cooperationInfo.provinces_id = provinceInfo.propertyID;
            _cooperationInfo.provinces_name = provinceInfo.propertyName;
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        };

    }
}
- (CooperationSelectAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[CooperationSelectAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        [[AppDelegate sharedAppDelegate].window addSubview:self.addressView];
        _addressView.selectSucceed = ^(NSMutableArray *arrData) {
            _arrResult = arrData;
            _addressIDsString = @"";
            _addressNamesString = @"";

            [arrData enumerateObjectsUsingBlock:^(AddressInfo *addressInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                _addressIDsString = [_addressIDsString stringByAppendingString:addressInfo.countiesID];
                _addressIDsString = [_addressIDsString stringByAppendingString:@","];
                _addressNamesString = [_addressNamesString stringByAppendingString:addressInfo.countiesName];
                _addressNamesString = [_addressNamesString stringByAppendingString:@"、"];
            }];
            _addressIDsString = [_addressIDsString substringToIndex:_addressIDsString.length-1];
            _addressNamesString = [_addressNamesString substringToIndex:_addressNamesString.length-1];

        
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }
    
    return _addressView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
