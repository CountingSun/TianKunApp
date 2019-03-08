//
//  MyVipCertificateListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyVipCertificateListViewController.h"
#import "MyVipCertificateListTableViewCell.h"
#import "MyVipCertificateViewController.h"

#import "CertificateInfo.h"
#import "NSString+WQString.h"
@interface MyVipCertificateListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation MyVipCertificateListViewController
- (instancetype)initWithType:(NSInteger)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == 1) {
        [self.titleView setTitle:@"个人证书"];

    }else{
        [self.titleView setTitle:@"企业证书"];

    }
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyVipCertificateListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyVipCertificateListTableViewCell"];
    [self showLoadingView];
    [self getData];

}
- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_type) forKey:@"data_type"];
    [dict setObject:@(_pageIndex) forKey:@"pageNo"];
    [dict setObject:@(_pageSize) forKey:@"pageSize"];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];

    [_netWorkEngine postWithDict:dict url:BaseUrl(@"find.vipUpDataList.by.vip.userid") succed:^(id responseObject) {
        [self hideLoadingView];
        [self.tableView endRefresh];
        
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
                    CertificateInfo *info = [CertificateInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:info];
                    
                }
                [self.tableView reloadData];
                
            }else{
                if (!_arrData.count) {
                    [self showGetDataNullWithReloadBlock:^{
                        [self showLoadingView];
                        [self getData];
                    }];
                    
                    
                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
            }
            if(arr.count<_pageSize){
                _tableView.canLoadMore = NO;
            }else{
                _tableView.canLoadMore = YES;
            }
            
        }else{
            if (!_arrData.count) {
                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    [self getData];
                }];
                
                
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
            [self showGetDataFailViewWithReloadBlock:^{
                [self hideEmptyView];
                [self showLoadingView];
                [self getData];
            }];
            
        }
        
    }];
    
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 40;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        __weak typeof(self) weakSelf = self;
        [_tableView headerWithRefreshingBlock:^{
            _pageIndex = 1;
            [weakSelf getData];
        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex ++;
            [weakSelf getData];
            
        }];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CertificateInfo *info = _arrData[indexPath.section];
    
    MyVipCertificateListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyVipCertificateListTableViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            {
                cell.nameLabel.text = @"企业名称：";
                cell.detailLabel.text = info.company_name;
            }
            break;
        case 1:
        {
            if (_type == 1) {
                cell.nameLabel.text = @"类型专业：";
                NSString *type = info.certificate_type_names.count?info.certificate_type_names[0]:@"";
                
                cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",info.certificate_name,type];


            }else{
                cell.nameLabel.text = @"证书类型：";
                cell.detailLabel.text = info.certificate_name;

            }

        }
            break;
        case 2:
        {
            if (_type == 1) {
                cell.nameLabel.text = @"证书姓名：";
                cell.detailLabel.text = info.name;
                
                
            }else{
                cell.nameLabel.text = @"发证日期：";
                cell.detailLabel.text = [NSString timeReturnDateString:info.opening_date formatter:@"yyyy-MM-dd"];
                
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CertificateInfo *info = _arrData[indexPath.section];
    MyVipCertificateViewController *vc = [[MyVipCertificateViewController alloc] initWithType:_type certificateInfo:info];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
