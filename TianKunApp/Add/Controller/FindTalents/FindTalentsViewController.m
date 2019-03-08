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
#import "JobInfo.h"

@interface FindTalentsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) JobInfo *jobInfo;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) CompanyInfo *companyInfo;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;


/**
 1 修改
 */
@property (nonatomic ,assign) NSInteger fromType;


@end

@implementation FindTalentsViewController
- (instancetype)initWithJobInfo:(JobInfo *)jobInfo succeedBlock:(succeedBlock)succeedBlock{
    if (self = [super init]) {
        _fromType = 1;
        _jobInfo = jobInfo;
        _companyInfo = [[CompanyInfo alloc]init];
        _companyInfo.companyName = jobInfo.enterprisename;
        _companyInfo.companyID = [jobInfo.enterpriseid integerValue];
        
        _succeedBlock = succeedBlock;

        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _footView;
    _footView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _publicButton.backgroundColor = COLOR_THEME;
    _publicButton.layer.masksToBounds = YES;
    _publicButton.layer.cornerRadius = 5;
    
    
    
    _tableView.rowHeight = 45;
    [_tableView  registerNib:[UINib nibWithNibName:@"FindTalentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTalentsTableViewCell"];
    [_tableView  registerNib:[UINib nibWithNibName:@"AddinputTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddinputTextTableViewCell"];

    
    if (_fromType == 1) {
        [self.titleView setTitle:@"编辑职位"];
        [self.tableView reloadData];
    }else{
        [self.titleView setTitle:@"发布职位"];
        _jobInfo = [[JobInfo alloc]init];

        [self showLoadingView];
        [self getEnterpriseInfo];
    }

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
            [self.tableView reloadData];

            
        }else if(code == 2){
            
            
        }else{
            [self showGetDataErrorWithMessage:@"获取企业信息失败" reloadBlock:^{
                [self showLoadingView];
                [self getEnterpriseInfo];
                
            }];

        }
        
        
        
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
                              @"edificeid":_jobInfo.second_typeid,
                              @"edificename":_jobInfo.name,
                              @"work_describe":_jobInfo.work_describe,
                              @"cityid":_jobInfo.cityid,



                              };
    
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    [self.netWorkEngine postWithDict:partDict url:BaseUrl(@"addjob/postjob.action") succed:^(id responseObject) {
        self.view.userInteractionEnabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"发布成功"];
            if (_succeedBlock) {
                _succeedBlock(_jobInfo);
            }

            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
    
}
- (void)editJob{
    
    NSDictionary *partDict = @{
                               @"id":_jobInfo.job_id,
                               @"enterpriseid":@(_companyInfo.companyID),
                               @"position_id":_jobInfo.second_typeid,
                               @"name":_jobInfo.name,
                               @"work_describe":_jobInfo.work_describe,
                               @"job_site":_jobInfo.cityid,
                               
                               
                               
                               };
    
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    [self.netWorkEngine postWithDict:partDict url:BaseUrl(@"my/edit_job.action") succed:^(id responseObject) {
        self.view.userInteractionEnabled = YES;
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"修改成功"];
            if (_succeedBlock) {
                _succeedBlock(_jobInfo);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            self.view.userInteractionEnabled = YES;

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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)texeFieldTextChange:(UITextField *)textField{
    
    _jobInfo.name = textField.text;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            AddinputTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddinputTextTableViewCell" forIndexPath:indexPath];
            [cell.textField addTarget:self action:@selector(texeFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            if (_jobInfo.name.length) {
                cell.textField.text = _jobInfo.name;
            }

            return cell;
            
        }
    }
    FindTalentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTalentsTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"公司信息";
        if (_companyInfo.companyID) {
            cell.detailLabel.text = _companyInfo.companyName;
        }else{
            cell.detailLabel.text = @"去完善";

        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLabel.text = @"职位类型";
                if (!_jobInfo.secondTypeName.length) {
                    cell.detailLabel.text = @"请选择";

                }else{
                    cell.detailLabel.text = _jobInfo.secondTypeName;

                }
            }
                break;
            case 1:
            {
                cell.titleLabel.text = @"职位名称";
            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"工作地点";
                if (_jobInfo.cityid.length) {
                    cell.detailLabel.text = _jobInfo.city_name;
                    
                }else{
                    cell.detailLabel.text = @"请选择";
                }
            }
                break;
            default:{
                cell.titleLabel.text = @"职位描述点";
                if (_jobInfo.work_describe.length) {
                    cell.detailLabel.text = _jobInfo.work_describe;
                }else{
                    cell.detailLabel.text = @"请填写";
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
            if (companyInfo.companyID) {
                _companyInfo = companyInfo;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            }else{
                [self showLoadingView];
                [self getEnterpriseInfo];

            }

        };
        
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        switch (indexPath.row) {
            case 0:
                {
                    SelectJobTypeViewController *vc = [[SelectJobTypeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    vc.selectJobSucceedBlock = ^(FilterInfo *first, FilterInfo *second) {
                    _jobInfo.secondTypeName = second.propertyName;
                        _jobInfo.second_typeid = second.propertyID;

                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

                    };
                    

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
                    _jobInfo.cityid = cityInfo.propertyID;
                    _jobInfo.city_name = [NSString stringWithFormat:@"%@",cityInfo.propertyName];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                

            }
                break;
            case 3:{
                JobIntroduceViewController *vc = [[JobIntroduceViewController alloc]init];
                vc.textStr = _jobInfo.work_describe;
                
                vc.textChangeBlock = ^(NSString *text) {
                    _jobInfo.work_describe = text;
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
    if (!_jobInfo.secondTypeName.length) {
        [self showErrorWithStatus:@"请选择职位类型"];
        return;
        
    }
    if (!_jobInfo.name.length) {
        [self showErrorWithStatus:@"请输入职位名称"];
        return;
        
    }
    if (!_jobInfo.cityid.length) {
        [self showErrorWithStatus:@"请选择工作地点"];
        return;
        
    }
    if (!_jobInfo.work_describe.length) {
        [self showErrorWithStatus:@"请输入职位描述"];
        return;
        
    }
    if (_fromType == 1) {
        [self editJob];
        
    }else{
        [self publicJob];
    }
    


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
