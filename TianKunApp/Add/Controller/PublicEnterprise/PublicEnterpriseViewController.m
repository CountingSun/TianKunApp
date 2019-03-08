//
//  PublicEnterpriseViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PublicEnterpriseViewController.h"
#import "MapViewController.h"
#import "PublicInfoTableViewCell.h"
#import "PublicTextViewTableViewCell.h"
#import "PublicUploadTableViewCell.h"
#import "EnterpriseInfo.h"
#import "CompanyClassInfo.h"
#import "SelectCompanyClassViewController.h"
#import "CompanyInfo.h"
#import "WQUploadSingleImage.h"
#import "CooperationSelectAddressView.h"
#import "AppDelegate.h"
#import "AddressInfo.h"
#import "BusinessLicenseViewController.h"

#define SegmentationChart  \\\

@interface PublicEnterpriseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) NSMutableArray *arrClass;
@property (nonatomic ,strong) CompanyInfo *companyInfo;
@property (nonatomic ,strong) UIImage *selectImage;
@property (nonatomic ,strong) NSData *imageData;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic ,strong) QMUIButton *saveButton;
@property (nonatomic ,strong) CooperationSelectAddressView *addressView;

@property (nonatomic ,strong) AddressInfo *addressInfo;

@property (nonatomic, copy) NSString *addressDetailSring;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic ,assign) BOOL canEdit;

@property (nonatomic, assign) NSInteger status;


@end

@implementation PublicEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"发布"];
    [self setView];
    
    [self setupUI];

    [self showLoadingView];
    [self getEnterpriseInfo];
    
    
    
    
}
- (void)setView{
    _companyInfo = [[CompanyInfo alloc]init];
    self.tableView.tableHeaderView = _headView;
    _canEdit = NO;

    _saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_saveButton setTitle:@"保存" forState:0];
    [_saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [_saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];

}
- (void)seve{
    
    if (!_companyInfo.companyClassInfo.company_id) {
        [self showErrorWithStatus:@"请选企业类别"];
        return;
    }
    if (!_companyInfo.companyName.length) {
        [self showErrorWithStatus:@"请输入企业名称"];
        return;
    }
    if (!_addressString.length) {
        [self showErrorWithStatus:@"请输选择企业属地"];
        return;
    }

    if (!_addressDetailSring.length) {
        [self showErrorWithStatus:@"请输输入企业详细地址"];
        return;
        
    }

    if (!_companyInfo.contacts.length) {
        [self showErrorWithStatus:@"请输入联系人"];
        return;

    }
    if (!_companyInfo.companyName.length) {
        [self showErrorWithStatus:@"请输入企业名称"];
        return;

    }
    if (!_companyInfo.phone.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;

    }
    if (!_companyInfo.companyName.length) {
        [self showErrorWithStatus:@"请输入企业名称"];
        return;

    }
    if (!_companyInfo.companyCertification.length) {
        [self showErrorWithStatus:@"请输入资质类型"];
        return;

    }
    if (!_companyInfo.companyIntroduce.length) {
        [self showErrorWithStatus:@"请输入企业描述"];
        return;
        
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [UserInfoEngine getUserInfo].userID,@"user_id",
                                [UserInfoEngine getUserInfo].nickname,@"username",
                                 _companyInfo.companyName,@"enterprise_name",
                                 _companyInfo.companyClassInfo.company_id,@"categoryid",
                                 _companyInfo.contacts,@"contacts",
                                 _companyInfo.phone,@"phone",
                                 [NSString stringWithFormat:@"%@-%@",_addressString,_addressDetailSring],@"address",
                                 _companyInfo.companyCertification,@"certificate_type",
                                 _companyInfo.companyIntroduce,@"enterprise_introduce",
                                 nil];
    
    if (_companyInfo.companyID) {
        [dict setObject:@(_companyInfo.companyID) forKey:@"id"];
        
    }
    
    self.view.userInteractionEnabled = NO;
    _saveButton.enabled = NO;
    
    [self showWithStatus:@"正在保存，请稍候"];
    [self.netWorkEngine upLoadmageData:_imageData imageName:@"pictureFile" Url:BaseUrl(@"add/add_submitmessage.action") dict:dict succed:^(id responseObject) {
        self.view.userInteractionEnabled = YES;
        _saveButton.enabled = YES;
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"保存成功"];
            _companyInfo.companyAddress = [NSString stringWithFormat:@"%@-%@",_addressString,_addressDetailSring];
            if (_EditSucceedBlock) {
                _EditSucceedBlock(_companyInfo);
                
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.view.userInteractionEnabled = YES;
            _saveButton.enabled = YES;

            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        

    } errorBlock:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        _saveButton.enabled = YES;

                [self showErrorWithStatus:NET_ERROR_TOST];

    }];
    
    
}
-(void)getEnterpriseInfo{
    
    [self.netWorkEngine postWithDict:@{@"uid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"add/add_message.action") succed:^(id responseObject) {
        [self hideLoadingView];
        _saveButton.enabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSDictionary *dict = [[responseObject objectForKey:@"value"] objectForKey:@"qyxx"];
            _companyInfo.companyAddress = [dict objectForKey:@"address"];
            _companyInfo.companyClassInfo.type_name = [dict objectForKey:@"category"];
            _companyInfo.companyClassInfo.company_id = [dict objectForKey:@"categoryid"];
            _companyInfo.companyCertification = [dict objectForKey:@"certificate_type"];

            _companyInfo.companyName = [dict objectForKey:@"enterprise_name"];
            _companyInfo.phone = [dict objectForKey:@"phone"];
            _companyInfo.contacts = [dict objectForKey:@"contacts"];
            _companyInfo.picture_url = [dict objectForKey:@"picture_url"];
            _companyInfo.companyID = [[dict objectForKey:@"id"] integerValue];
            _companyInfo.companyIntroduce = [dict objectForKey:@"enterprise_introduce"];
            NSArray *arr = [_companyInfo.companyAddress componentsSeparatedByString:@"-"];
            
            if (arr.count>3) {
                NSString *string = @"";
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@-",arr[0]]];
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@-",arr[1]]];
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",arr[2]]];
                
                _addressDetailSring =  [_companyInfo.companyAddress stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@-",string] withString:@""];
                
                _addressString = string;

                
            }else{
                _addressDetailSring = @"";
            }

            [self.tableView reloadData];
            
            _status = [[[[responseObject objectForKey:@"value"] objectForKey:@"qyxx"] objectForKey:@"status"] integerValue];

            switch (_status) {
                case 0:
                    {
                        _statusLabel.text = @"未认证";
                        [self setTableViewCanEdit:YES];
                    }
                    break;
                case 1:{
                    _statusLabel.text = @"待审核";
                    [self setTableViewCanEdit:NO];

                }
                    break;
                    
                case 2:{
                    _statusLabel.text = @"审核中";
                    [self setTableViewCanEdit:NO];

                }
                    break;
                case 3:{
                    _statusLabel.text = @"审核通过";
                    [self setTableViewCanEdit:NO];

                }
                    break;

                default:
                    _statusLabel.text = @"审核未通过";
                    [self setTableViewCanEdit:YES];

                    break;
            }

        }else if(code == 2){
            _status =[[[[responseObject objectForKey:@"value"] objectForKey:@"authent"] objectForKey:@"status"] integerValue];
            switch (_status) {
                case 0:
                {
                    _statusLabel.text = @"未认证";
                    [self setTableViewCanEdit:YES];
                }
                    break;
                case 1:{
                    _statusLabel.text = @"待审核";
                    [self setTableViewCanEdit:NO];
                    
                }
                    break;
                    
                case 2:{
                    _statusLabel.text = @"审核中";
                    [self setTableViewCanEdit:NO];
                    
                }
                    break;
                case 3:{
                    _statusLabel.text = @"审核通过";
                    [self setTableViewCanEdit:NO];
                    
                }
                    break;
                    
                default:
                    _statusLabel.text = @"审核未通过";
                    [self setTableViewCanEdit:YES];
                    
                    break;
            }

            _companyInfo.companyName = [[[responseObject objectForKey:@"value"] objectForKey:@"authent"] objectForKey:@"companyname"];

            
            [self.tableView reloadData];
            

        }else{
            [self setTableViewCanEdit:NO];

            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getEnterpriseInfo];
                
            }];
        }
        
        @try {
            NSMutableArray *arrClass = [[responseObject objectForKey:@"value"] objectForKey:@"qylb"];
            if (!_arrClass) {
                _arrClass = [NSMutableArray array];
            }
            
            for (NSDictionary *dict in arrClass) {
                
                CompanyClassInfo *companyClassInfo = [[CompanyClassInfo alloc]init];
                companyClassInfo.company_id = [dict objectForKey:@"id"];
                companyClassInfo.type_name = [dict objectForKey:@"type_name"];

                [_arrClass addObject:companyClassInfo];
            }

        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        


    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getEnterpriseInfo];

        }];
        
    }];
    
    
}
- (void)setupUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"PublicInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PublicInfoTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PublicTextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"PublicTextViewTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PublicUploadTableViewCell" bundle:nil] forCellReuseIdentifier:@"PublicUploadTableViewCell"];

    _statusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBusinessLicense)];
    [_statusLabel addGestureRecognizer:tap];
    
}
- (void)gotoBusinessLicense{
//    if (_status == 1||_status == 2||_status == 3) {
//        return;
//        
//    }
    BusinessLicenseViewController *vc = [[BusinessLicenseViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)setTableViewCanEdit:(BOOL)canEdits{
    if (canEdits) {
        _canEdit = YES;
        [self.tableView reloadData];

    }else{
        _canEdit = NO;
        [self.tableView reloadData];

    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    }
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }else if (indexPath.section == 1){
        return 120;
    }else{
        return 80;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PublicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicInfoTableViewCell" forIndexPath:indexPath];
        cell.rowImageView.hidden = YES;
        cell.inputTextField.enabled = YES;
        cell.inputTextField.userInteractionEnabled = YES;

        cell.inputTextField.keyboardType = UIKeyboardTypeDefault;

        switch (indexPath.row) {
            case 0:
            {
                cell.inputTextField.enabled = NO;
                cell.nameLabel.text = @"企业类别：";
                cell.inputTextField.placeholder = @"请选择企业类别";
                cell.rowImageView.hidden = NO;
                cell.inputTextField.text = _companyInfo.companyClassInfo.type_name;
                
                
            }
                break;
            case 1:{
                cell.nameLabel.text = @"企业名称：";
                cell.inputTextField.placeholder = @"请输入企业名称";
                cell.inputTextField.text = _companyInfo.companyName;
                cell.textBlock = ^(NSString *text) {
                    _companyInfo.companyName = text;
                    
                };
                if (!_canEdit) {
                    cell.inputTextField.enabled = NO;
                    
                }else{
                    cell.inputTextField.enabled = YES;
                    
                }

            }
                break;
            case 2:{
                cell.nameLabel.text = @"企业属地";
                cell.rowImageView.hidden = NO;

                cell.inputTextField.placeholder = @"请选择企业属地";
                cell.inputTextField.text = [_addressString stringByReplacingOccurrencesOfString:@"-" withString:@""];
                cell.inputTextField.userInteractionEnabled = NO;
            }
                break;

            case 3:{
                cell.inputTextField.text = _addressDetailSring;

                cell.nameLabel.text = @"详细地址：";
                cell.inputTextField.placeholder = @"请输入详细地址";
                
                cell.textBlock = ^(NSString *text) {
                    _addressDetailSring = text;
                    
                };

            }
                break;
            case 4:{
                cell.nameLabel.text = @"联系人：";
                cell.inputTextField.placeholder = @"请输入联系人姓名";
                cell.inputTextField.text = _companyInfo.contacts;
                cell.textBlock = ^(NSString *text) {
                    _companyInfo.contacts = text;
                    
                };

            }
                break;
            case 5:{
                cell.nameLabel.text = @"手机号";
                cell.inputTextField.placeholder = @"请输入手机号";
                cell.inputTextField.text = _companyInfo.phone;
                cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
                
                cell.textBlock = ^(NSString *text) {
                    _companyInfo.phone = text;
                    
                };

            }
                break;
            case 6:{
                cell.nameLabel.text = @"资质类型";
                cell.inputTextField.placeholder = @"请输入资质类型";
                cell.inputTextField.text = _companyInfo.companyCertification;
                cell.textBlock = ^(NSString *text) {
                    _companyInfo.companyCertification = text;
                    
                };

            }
                break;

            default:
                break;
        }
        return cell;

    }else if (indexPath.section == 1){
        PublicTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicTextViewTableViewCell" forIndexPath:indexPath];
        cell.textViewChangeBlock = ^(NSString *text) {
            _companyInfo.companyIntroduce = text;
            
        };
        cell.textView.text = _companyInfo.companyIntroduce;
        return cell;

    }else{
        PublicUploadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicUploadTableViewCell" forIndexPath:indexPath];
        
        
        __weak typeof(cell) weakCell = cell;
        
        cell.block = ^{
            [[WQUploadSingleImage manager] showUpImagePickerWithVC:self compression:0.5 selectSucceedBlock:^(UIImage *image, NSString *filePath) {
                _selectImage = image;
                weakCell.addImageView.image = image;
                _imageData = UIImageJPEGRepresentation(image, 0.5);
            }];
            
        };
        UIImageView *imageView = cell.addImageView;
        NSString *imageUrl = _companyInfo.picture_url;
        if (![imageUrl hasPrefix:@"http"]) {
            imageUrl = [NSString stringWithFormat:@"http://%@",_companyInfo.picture_url];
        }
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"上传-image"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (image) {
                _imageData = UIImageJPEGRepresentation(image, 1);

            }
        }];

        return cell;

    }
    
    return [UITableViewCell new];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0&&indexPath.row == 0) {
        SelectCompanyClassViewController *vc = [[SelectCompanyClassViewController alloc]init];
        vc.arrData = _arrClass;
        vc.selectSucceedBlock = ^(CompanyClassInfo *companyClassInfo) {
            _companyInfo.companyClassInfo = companyClassInfo;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
        };
        [self.navigationController pushViewController:vc animated:YES];

        
    }
    if (indexPath.section == 0&&indexPath.row == 2) {
        self.addressView.hidden = NO;
    }

}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}

- (CooperationSelectAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[CooperationSelectAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        [[AppDelegate sharedAppDelegate].window addSubview:self.addressView];
        _addressView.selectSucceed = ^(NSMutableArray *arrData) {
            
            if (arrData.count) {
                AddressInfo *info = arrData[0];
                NSString *string = [NSString stringWithFormat:@"%@-%@-%@",info.provinceName,info.cityName,info.countiesName];
                _addressString = string;
            }
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }
    
    return _addressView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
