//
//  MyPublicCompanyViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublicCompanyViewController.h"
#import "CompanyInfo.h"
#import "CompanyClassInfo.h"
#import "CompanyIntroduceTableViewCell.h"
#import "PublicEnterpriseViewController.h"
#import "BusinessLicenseViewController.h"

@interface MyPublicCompanyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong)  CompanyInfo *companyInfo;
@property (nonatomic, strong)  WQTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic ,assign) NSInteger status;

@end

@implementation MyPublicCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingView];
    _statusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBusinessLicense)];
    [_statusLabel addGestureRecognizer:tap];

    [self getEnterpriseInfo];
    
}
- (void)gotoBusinessLicense{
    if (_status == 1||_status == 2||_status == 3) {
        return;
        
    }
    BusinessLicenseViewController *vc = [[BusinessLicenseViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)getEnterpriseInfo{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }

    [self.netWorkEngine postWithDict:@{@"uid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"add/add_message.action") succed:^(id responseObject) {
        [self hideLoadingView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _companyInfo = [[CompanyInfo alloc]init];
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
            _status = [[[[responseObject objectForKey:@"value"] objectForKey:@"qyxx"] objectForKey:@"status"] integerValue];
            
            switch (_status) {
                case 0:
                {
                    _statusLabel.text = @"未认证";
                }
                    break;
                case 1:{
                    _statusLabel.text = @"待审核";
                    
                }
                    break;
                    
                case 2:{
                    _statusLabel.text = @"审核中";
                    
                }
                    break;
                case 3:{
                    _statusLabel.text = @"审核通过";
                    
                }
                    break;
                    
                default:
                    _statusLabel.text = @"审核未通过";
                    
                    break;
            }

            [self.tableView reloadData];
            
        }else if(code == 2){
            [self showEmptyViewWithText:@"提示" detailText:@"尚未发布企业" buttonTitle:@"去发布" buttonAction:@selector(goToPublic)];
        }else{
            
        }
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getEnterpriseInfo];
            
        }];
        
    }];
    
    
}
- (void)clickEditButton{
    [self goToPublic];
    
}

- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 45;
        [self.view addSubview:self.tableView];
        _tableView.tableHeaderView = self.headView;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
        
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellID = @"defCellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.selectionStyle = 0;
        }
        switch (indexPath.row) {
            case 0:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"企业名称：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_companyInfo.companyName color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 1:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"联系人：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_companyInfo.contacts color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 2:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"联系电话：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_companyInfo.phone color:COLOR_THEME fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 3:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"地址：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_companyInfo.companyAddress color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;

            case 4:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"资质类型：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_companyInfo.companyCertification color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
                
            default:
                break;
        }
        return cell;
        
    }else{
        CompanyIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyIntroduceTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CompanyIntroduceTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        cell.contentLable.text = _companyInfo.companyIntroduce;
        
        return cell;
        
    }
    return [UITableViewCell new];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
//            if(_companyInfo.phone.length){
//                [WQTools callWithTel:_companyInfo.phone];
//            }
        }
    }
    
}
- (NSAttributedString *)dealStringWithString:(NSString *)str color:(UIColor *)color fontSize:(CGFloat)fontSize{
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                        NSForegroundColorAttributeName:color
                                                        }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)goToPublic{
    PublicEnterpriseViewController *vc = [[PublicEnterpriseViewController alloc]init];
    vc.EditSucceedBlock = ^(CompanyInfo *companyInfo) {
        [self hideEmptyView];
//        [self showLoadingView];
//        [self getEnterpriseInfo];
        _companyInfo = companyInfo;
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
