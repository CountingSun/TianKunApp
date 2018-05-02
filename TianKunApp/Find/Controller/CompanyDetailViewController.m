
//
//  CompanyDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CompanyIntroduceTableViewCell.h"
#import "HomeListTableViewCell.h"
#import "AppShared.h"
#import "CompanyInfo.h"
#import "CompanyClassInfo.h"

#import "EnterpriseInfo.h"
#import "FindListTableViewCell.h"
#import "FindImageListTableViewCell.h"

@interface CompanyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *rightBarButtonView;
@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;
@property (weak, nonatomic) IBOutlet QMUIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicTimeIaLbel;
@property (weak, nonatomic) IBOutlet UILabel *hadSeeLabel;

@property (nonatomic ,assign) NSInteger companyID;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) CompanyInfo *showCompanyInfo;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,assign) NSInteger type;



@end

@implementation CompanyDetailViewController

- (instancetype)initWithCompanyID:(NSInteger)companyID type:(NSInteger)type{
    if (self = [super init]) {
        _companyID = companyID;
        _type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [self showLoadingView];
    
    [self getCompanyInfo];
}
- (void)setupUI{
    [self.titleView setTitle:@"详情"];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];
    _rightBarButtonView.userInteractionEnabled = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBarButtonView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];

}
- (void)getCompanyInfo{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([UserInfoEngine getUserInfo].userID.length) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userId"];
        
        
    }
    [dict setObject:@(_companyID) forKey:@"id"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"find.enterprise.by.id") succed:^(id responseObject) {
        [self hideLoadingView];

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _rightBarButtonView.userInteractionEnabled = YES;

            NSDictionary *dict = [responseObject objectForKey:@"value"];
            
            _showCompanyInfo = [CompanyInfo mj_objectWithKeyValues:dict];
            _showCompanyInfo.companyAddress = [dict objectForKey:@"address"];
            _showCompanyInfo.companyIntroduce = [dict objectForKey:@"enterprise_introduce"];
            _showCompanyInfo.companyName = [dict objectForKey:@"enterprise_name"];
            _showCompanyInfo.firstTypeName = [dict objectForKey:@"certificate_type"];
            _showCompanyInfo.companyUpDate = [dict objectForKey:@"update_date"];
            
            _companyNameLabel.text = _showCompanyInfo.companyName;
            _publicTimeIaLbel.text = [NSString stringWithFormat:@"发布时间：%@",[NSString timeReturnDate:[NSNumber numberWithInteger:[_showCompanyInfo.companyUpDate integerValue]]]];
            
            if (!_showCompanyInfo.hits_show.length) {
                _showCompanyInfo.hits_show = @"0";
            }
            _hadSeeLabel.text = [NSString stringWithFormat:@"已有%@人浏览",_showCompanyInfo.hits_show];
            
            
            [self getRecommend];
            
            [self.tableView reloadData];
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getCompanyInfo];

            }];
            
            
        }
    } errorBlock:^(NSError *error) {
        _rightBarButtonView.userInteractionEnabled = YES;

        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getCompanyInfo];
        }];
        
    }];
    
    
    
}
- (void)getRecommend{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    
    [self.netWorkEngine postWithDict:@{@"certifications_type_id":_showCompanyInfo.firstTypeName,@"pageNo":@(_pageIndex),@"pageSize":@(_pageSize)} url:BaseUrl(@"find.by.enterpriseList") succed:^(id responseObject) {
        [self hideLoadingView];
        [_tableView endRefresh];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            if (arr.count) {
                if (!_arrData) {
                    _arrData = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    EnterpriseInfo *enterpriseInfo = [EnterpriseInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:enterpriseInfo];
                }
                [self.tableView reloadData];
                if(arr.count<_pageSize){
                    _tableView.canLoadMore = NO;
                }else{
                    _tableView.canLoadMore = YES;
                }
                
            }else{
                if (!_arrData.count) {
                    
                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
            }
            
        }else{
            if (!_arrData.count) {
                
            }else{
                _pageIndex--;
                
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
            }
            
        }
        
        
        
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [_tableView endRefresh];
        if (_arrData.count) {
            _pageIndex = 1;
            
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            _pageIndex = 1;
            
        }
        
    }];
        
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = _headView;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 45;
        __weak typeof(self ) weakSelf = self;
        
        [self.view addSubview:self.tableView];
        _tableView.footRefreshBlock = ^{
            weakSelf.pageIndex++;
            [weakSelf getRecommend];
        };
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return _arrData.count;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
        
    }
    if (section == 2) {
        return 40;
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
    if (section == 2) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        view.backgroundColor = COLOR_WHITE;
        
        WQLabel *label = [[WQLabel alloc]initWithFrame:CGRectMake(15, 0, 200, 40) font:[UIFont systemFontOfSize:14] text:@"更多推荐" textColor:COLOR_TEXT_BLACK textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [view addSubview:label];
        
        return view;
    }
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
                    NSAttributedString *titleAttributedString = [self dealStringWithString:@"联系人：" color:COLOR_TEXT_LIGHT fontSize:14];
                    NSAttributedString *detailAttributedString = [self dealStringWithString:_showCompanyInfo.contacts color:COLOR_TEXT_BLACK fontSize:14];
                    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                    [attStr appendAttributedString:titleAttributedString];
                    [attStr appendAttributedString:detailAttributedString];

                    cell.textLabel.attributedText = attStr;
                    
                }
                break;
            case 1:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"联系电话：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_showCompanyInfo.phone color:COLOR_THEME fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 2:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"资质类型：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_showCompanyInfo.firstTypeName color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 3:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"商家地址：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_showCompanyInfo.companyAddress color:COLOR_TEXT_BLACK fontSize:14];
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
        
    }else if (indexPath.section == 1){
        CompanyIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyIntroduceTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CompanyIntroduceTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        cell.contentLable.text = _showCompanyInfo.companyIntroduce;
        
        return cell;
        
    }else{
        EnterpriseInfo *enterpriseInfo = _arrData[indexPath.row];
        
            FindImageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindImageListTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"FindImageListTableViewCell" owner:nil options:nil] firstObject];
                cell.titleLabel.textColor = COLOR_TEXT_BLACK;
                cell.detailLabel.textColor = COLOR_TEXT_LIGHT;
                
            }
            
            [cell.iconImageView sd_imageDef11WithUrlStr:BaseUrl(enterpriseInfo.picture_url)];;
            cell.titleLabel.text = enterpriseInfo.enterprise_name;
            cell.detailLabel.text = enterpriseInfo.enterprise_introduce;
            
            cell.selectionStyle = 0;
            return cell;
            
    }
    return [UITableViewCell new];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if(_showCompanyInfo.phone.length){
                [WQTools callWithTel:_showCompanyInfo.phone];
            }
        }
    }
    if (indexPath.section == 2) {
        EnterpriseInfo *enterpriseInfo = _arrData[indexPath.row];
        
        CompanyDetailViewController *viewController = [[CompanyDetailViewController alloc]initWithCompanyID:enterpriseInfo.enterprise_id type:2];
        [self.navigationController pushViewController:viewController animated:YES];
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
    return 3;
}             
- (IBAction)collectButtonClick:(id)sender {
    
    if ([UserInfoEngine isLogin]) {
        [self showWithStatus:NET_WAIT_TOST];
        
        [self.netWorkEngine postWithDict:@{@"id":@(_companyID),@"user_id":[UserInfoEngine getUserInfo].userID,@"status":@(!_collectButton.selected)} url:BaseUrl(@"create.or.update.enterpriseCollectible") succed:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1) {
                _collectButton.selected =! _collectButton.selected;
                if (_collectButton.selected) {
                    [self showSuccessWithStatus:@"收藏成功"];
                }else{
                    [self showSuccessWithStatus:@"取消收藏成功"];
                }
                
            }
            else{
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
            }
        } errorBlock:^(NSError *error) {
            [self showErrorWithStatus:NET_ERROR_TOST];
            
            
        }];

    }

}

- (IBAction)shareButtonClick:(id)sender {
    [AppShared shared];
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
