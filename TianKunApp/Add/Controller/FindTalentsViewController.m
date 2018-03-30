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

@end

@implementation FindTalentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    
    [self.titleView setTitle:@"发布职位"];
    _publicModel = [[PublicModel alloc]init];
    
    _tableView.rowHeight = 45;
    [_tableView  registerNib:[UINib nibWithNibName:@"FindTalentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTalentsTableViewCell"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }
    return 4;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
                if (!_publicModel.edificename.length) {
                    cell.detailLabel.text = @"请选择";

                }else{
                    cell.detailLabel.text = _publicModel.edificename;

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
                    AddSelectJobTypeViewController *vc = [[AddSelectJobTypeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    vc.selectSucceedBlock = ^(ClassTypeInfo *classTypeInfo) {
                        _publicModel.edificename = classTypeInfo.typeName;
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
