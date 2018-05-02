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

@interface PublicEnterpriseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) NSMutableArray *arrClass;
@property (nonatomic ,strong) CompanyInfo *companyInfo;
@property (nonatomic ,strong) UIImage *selectImage;
@property (nonatomic ,strong) NSData *imageData;

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (nonatomic ,strong) QMUIButton *saveButton;

@end

@implementation PublicEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"发布"];
    [self setupUI];
    
    [self showLoadingView];
    _companyInfo = [[CompanyInfo alloc]init];
    [self getEnterpriseInfo];
    
    _saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_saveButton setTitle:@"保存" forState:0];
    [_saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [_saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];
    _saveButton.enabled = NO;

    
    
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
    if (!_companyInfo.companyAddress.length) {
        [self showErrorWithStatus:@"请输入地址"];
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
                                 _companyInfo.companyAddress,@"address",
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
            
            if (_EditSucceedBlock) {
                _EditSucceedBlock(_companyInfo);
                
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
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

            [self.tableView reloadData];
            
            NSInteger isAuthen = [[[[responseObject objectForKey:@"value"] objectForKey:@"user"] objectForKey:@"authentication"] integerValue];
            if (isAuthen != 4) {
                self.tableView.tableHeaderView = _headView;
            }
            

        }else{
            
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

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
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

            }
                break;
            case 2:{
                cell.nameLabel.text = @"地址：";
                cell.inputTextField.placeholder = @"请输入地址";
                cell.inputTextField.text = _companyInfo.companyAddress;
                cell.textBlock = ^(NSString *text) {
                    _companyInfo.companyAddress = text;
                    
                };

            }
                break;
            case 3:{
                cell.nameLabel.text = @"联系人：";
                cell.inputTextField.placeholder = @"请输入联系人姓名";
                cell.inputTextField.text = _companyInfo.contacts;
                cell.textBlock = ^(NSString *text) {
                    _companyInfo.contacts = text;
                    
                };

            }
                break;
            case 4:{
                cell.nameLabel.text = @"手机号";
                cell.inputTextField.placeholder = @"请输入手机号";
                cell.inputTextField.text = _companyInfo.phone;
                cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
                
                cell.textBlock = ^(NSString *text) {
                    _companyInfo.phone = text;
                    
                };

            }
                break;
            case 5:{
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
                weakCell.imageView.image = image;
                _imageData = UIImageJPEGRepresentation(image, 0.5);
            }];
            
        };
        UIImageView *imageView = cell.imageView;
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
//    MapViewController *mapViewController = [[MapViewController alloc]init];
//    [self.navigationController pushViewController:mapViewController animated:YES];

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


@end
