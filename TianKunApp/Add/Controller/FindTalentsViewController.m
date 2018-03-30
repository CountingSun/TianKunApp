//
//  FindTalentsViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindTalentsViewController.h"
#import "FindTalentsTableViewCell.h"
#import "JobIntroduceViewController.h"
#import "SelectAddressViewController.h"
#import "FilterInfo.h"
#import "AddSelectJobTypeViewController.h"
#import "ClassTypeInfo.h"
#import "CompanyInfo.h"
#import "PublicEnterpriseViewController.h"
#import "SelectJobTypeViewController.h"

#import "AddinputTextTableViewCell.h"

@interface PublicModel :NSObject


/**
 企业id
 */
@property (nonatomic, copy) NSString *enterpriseid;
/**
 职位名称
 */

@property (nonatomic, copy) NSString *edificename;
/**
 职位类型ID
 */
@property (nonatomic, copy) NSString *edificeTypeID;

/**
 职位类型名称
 */

@property (nonatomic, copy) NSString *edificeTypename;


/**
 市级编码
 */

@property (nonatomic, copy) NSString *cityid;
/**
 职位描述
 */

@property (nonatomic, copy) NSString *work_describe;

/**
 工作地址
 */

@property (nonatomic, copy) NSString *address;

@end
@implementation PublicModel
@end

@interface FindTalentsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) PublicModel *publicModel;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) CompanyInfo *companyInfo;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;

@end

@implementation FindTalentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _footView;
    _footView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _publicButton.backgroundColor = COLOR_THEME;
    _publicButton.layer.masksToBounds = YES;
    _publicButton.layer.cornerRadius = 5;
    
    
    [self.titleView setTitle:@"发布职位"];
    _publicModel = [[PublicModel alloc]init];
    
    _tableView.rowHeight = 45;
    [_tableView  registerNib:[UINib nibWithNibName:@"FindTalentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTalentsTableViewCell"];
    [_tableView  registerNib:[UINib nibWithNibName:@"AddinputTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddinputTextTableViewCell"];

    [self showLoadingView];
    [self getEnterpriseInfo];
    
    
    
}


-(void)getEnterpriseInfo{
    
    [self.netWorkEngine postWithDict:@{@"uid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"add/add_message.action") succed:^(id responseObject) {
        [self hideLoadingView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSDictionary *dict = [[responseObject objectForKey:@"value"] objectForKey:@"qyxx"];
            _companyInfo = [[CompanyInfo alloc]init];
            
            _companyInfo.companyName = [dict objectForKey:@"enterprise_name"];
            _companyInfo.companyID = [[dict objectForKey:@"id"] integerValue];
            
            
        }else{
            [self hideLoadingView];
            
            
        }
        
        
        [self.tableView reloadData];
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getEnterpriseInfo];
            
        }];
        
    }];
    
    
}
- (void)publicJob{
    
    NSDictionary *partDict = @{
                              @"userid":[UserInfoEngine getUserInfo].userID,
                              @"username":[UserInfoEngine getUserInfo].nickname,
                              @"enterpriseid":@(_companyInfo.companyID),
                              @"edificeid":_publicModel.edificeTypeID,
                              @"edificename":_publicModel.edificename,
                              @"work_describe":_publicModel.work_describe,
                              @"cityid":_publicModel.cityid,



                              };
    
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    [self.netWorkEngine postWithDict:partDict url:BaseUrl(@"addjob/postjob.action") succed:^(id responseObject) {
        self.view.userInteractionEnabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }
    return 4;
    
}

- (void)texeFieldTextChange:(UITextField *)textField{
    
    _publicModel.edificename = textField.text;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            AddinputTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddinputTextTableViewCell" forIndexPath:indexPath];
            [cell.textField addTarget:self action:@selector(texeFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            
            return cell;
            
        }
    }
    FindTalentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTalentsTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"公司信息";
        if (_companyInfo.companyName.length) {
            cell.detailLabel.text = _companyInfo.companyName;
        }else{
            cell.detailLabel.text = @"去完善";

        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLabel.text = @"职位类型";
                if (!_publicModel.edificeTypename.length) {
                    cell.detailLabel.text = @"请选择";

                }else{
                    cell.detailLabel.text = _publicModel.edificeTypename;

                }
            }
                break;
            case 1:
            {
                cell.titleLabel.text = @"职位名称";
                if (_publicModel.work_describe.length) {
                    cell.detailLabel.text = _publicModel.edificename;

                }else{
                    cell.detailLabel.text = @"请选择";
                }
            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"工作地点";
                if (_publicModel.cityid.length) {
                    cell.detailLabel.text = _publicModel.address;
                    
                }else{
                    cell.detailLabel.text = @"请选择";
                }
            }
                break;
            default:{
                cell.titleLabel.text = @"职位描述点";
                if (_publicModel.work_describe.length) {
                    cell.detailLabel.text = _publicModel.work_describe;
                }else{
                    cell.detailLabel.text = @"请选择";
                }

            }
                break;
        }
        }
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    if (indexPath.section == 0) {
        PublicEnterpriseViewController *vc = [[PublicEnterpriseViewController alloc]init];
        vc.EditSucceedBlock = ^(CompanyInfo *companyInfo) {
            _companyInfo = companyInfo;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        };
        
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        switch (indexPath.row) {
            case 0:
                {
                    SelectJobTypeViewController *vc = [[SelectJobTypeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    vc.selectJobSucceedBlock = ^(FilterInfo *first, FilterInfo *second) {
                    _publicModel.edificeTypename = second.propertyName;
                        _publicModel.edificeTypeID = second.propertyID;

                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

                    };
                    
//                    vc.selectSucceedBlock = ^(ClassTypeInfo *classTypeInfo) {
//                        _publicModel.edificename = classTypeInfo.typeName;
//                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    };

                }
                break;
            case 1:
            {
                

            }
                break;
            case 2:{
                
                SelectAddressViewController *vc = [[SelectAddressViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                vc.selectSucceedBlock = ^(FilterInfo *provinceInfo, FilterInfo *cityInfo) {
                    _publicModel.cityid = cityInfo.propertyID;
                    _publicModel.address = [NSString stringWithFormat:@"%@%@",provinceInfo.propertyName,cityInfo.propertyName];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                

            }
                break;
            case 3:{
                JobIntroduceViewController *vc = [[JobIntroduceViewController alloc]init];
                vc.textStr = _publicModel.work_describe;
                
                vc.textChangeBlock = ^(NSString *text) {
                    _publicModel.work_describe = text;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
}
- (IBAction)publicButtonClick:(id)sender {
    
    if (!_companyInfo.companyID) {
        [self showErrorWithStatus:@"请选择公司"];
        return;
        
    }
    if (!_publicModel.edificeTypeID.length) {
        [self showErrorWithStatus:@"请选择职位类型"];
        return;
        
    }
    if (!_publicModel.edificename.length) {
        [self showErrorWithStatus:@"请输入职位名称"];
        return;
        
    }
    if (!_publicModel.address.length) {
        [self showErrorWithStatus:@"请选择工作地点"];
        return;
        
    }
    if (!_publicModel.work_describe.length) {
        [self showErrorWithStatus:@"请输入职位描述"];
        return;
        
    }
    [self publicJob];
    


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
