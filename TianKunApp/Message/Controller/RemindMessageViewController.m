//
//  RemindMessageViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RemindMessageViewController.h"
#import "RemindMessageHeadTableViewCell.h"
#import "RemindMessageTableViewCell.h"
#import "RemindInfo.h"
#import "CertificateInfo.h"
#import "MyVipCertificateViewController.h"

#import "CommonNoDaataFootView.h"

@interface RemindMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
//@property (nonatomic ,strong) NSMutableArray *arrProperty;
@property (nonatomic, copy) NSString *propertyString;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) UserInfo *userInfo;
@property (nonatomic ,strong) CommonNoDaataFootView *footView;

@property (nonatomic ,strong) UIView *footViewBlank;


@end

@implementation RemindMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"到期提醒" ];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;

    [self.tableView registerNib:[UINib nibWithNibName:@"RemindMessageHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemindMessageHeadTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RemindMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemindMessageTableViewCell"];
    _propertyString = @"";
    [self showLoadingView];
//    [self getUserInfo];
    [self getReaindList];
    
}
- (void)getUserInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userId"];
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"find.user.and.overdue.certificate") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _userInfo = [[UserInfo alloc] init];
            _userInfo.name = [[responseObject objectForKey:@"value"] objectForKey:@"name"];
            _userInfo.headimg = [[responseObject objectForKey:@"value"] objectForKey:@"headimg"];

//            if (!_arrProperty) {
//                _arrProperty = [NSMutableArray array];
//            }
//            [_arrProperty removeAllObjects];
//
            NSMutableArray *arr = [[[responseObject objectForKey:@"value"] objectForKey:@"paging"] objectForKey:@"content"];
                _propertyString = [arr componentsJoinedByString:@"，"];
                
            
            [self getReaindList];
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getUserInfo];
            }];
            
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataErrorWithMessage:NET_ERROR_TOST reloadBlock:^{
            [self showLoadingView];
            [self getUserInfo];
        }];
    }];
    
}
- (void)getReaindList{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:@(_pageIndex) forKey:@"pageNo"];
    [dict setObject:@(_pageSize) forKey:@"pageSize"];
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"find.vipUpDataList.by.vipUpData") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
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
                    if(arr.count<_pageSize){
                        _tableView.canLoadMore = NO;
                    }else{
                        _tableView.canLoadMore = YES;
                    }
                    
                }else{
                    if (!_arrData.count) {
                        _tableView.tableFooterView = self.footView;
                    }else{
                        _tableView.tableFooterView = self.footViewBlank;
                        
                        _pageIndex--;
                        [self showErrorWithStatus:NET_WAIT_NO_DATA];
                        
                    }
                    _tableView.canLoadMore = NO;

                }
                
            }else{
                if (!_arrData.count) {
                    _tableView.tableFooterView = self.footView;

                }else{
                    _pageIndex--;
                    _tableView.tableFooterView = self.footViewBlank;
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
                
            }
            
            
            
        }else{
            
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [_tableView endRefresh];
        [self showErrorWithStatus:NET_ERROR_TOST];

        if (_arrData.count) {
            _pageIndex = 1;
        }else{
            self.footView.label.text = NET_ERROR_TOST;
            
            _tableView.tableFooterView = self.footView;

        }
        
    }];
    
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.separatorColor = COLOR_VIEW_BACK;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            _pageIndex = 1;
            [weakSelf getReaindList];
        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex ++;
            [weakSelf getReaindList];

        }];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = COLOR_WHITE;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 2, 30)];
        [view addSubview:label];
        label.backgroundColor =COLOR_THEME;
        
        WQLabel *titleLabel = [[WQLabel alloc]initWithFrame:CGRectMake(18, 0, 0, 0) font:[UIFont systemFontOfSize:16] text:@"我的证书" textColor:COLOR_TEXT_BLACK textAlignment:NSTextAlignmentLeft numberOfLine:1];
        
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
        
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:lineView];
        
        
        
        
        return view;
    }else{
        return [UIView new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section == 0) {
//        RemindMessageHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindMessageHeadTableViewCell"];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindMessageHeadTableViewCell" owner:nil options:nil] firstObject];
//        }
//        [cell.headImageView sd_imageWithUrlStr:_userInfo.headimg placeholderImage:@"头像"];
//        cell.nameLabel.text = _userInfo.name;
//        cell.detailLabel.text = _propertyString;
//
//        return cell;
//
//    }else{
        RemindMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindMessageTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindMessageTableViewCell" owner:nil options:nil] firstObject];
        }
        CertificateInfo *info = _arrData[indexPath.row];
        cell.titleLabel.text = info.certificate_name;
        cell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",info.name];
        cell.starTimeLabel.text = [NSString stringWithFormat:@"办证时间：%@",[NSString timeReturnDateString:info.opening_date formatter:@"yyyy-MM-dd"]];
        cell.endTimeLabel.text = [NSString stringWithFormat:@"到期时间：%@",[NSString timeReturnDateString:info.remind_date formatter:@"yyyy-MM-dd"]];
        [cell.mainImageView sd_imageDef11WithUrlStr:info.certificate_url];
        

        return cell;

//    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        CertificateInfo *info = _arrData[indexPath.row];
        MyVipCertificateViewController *vc = [[MyVipCertificateViewController alloc] initWithType:info.data_type certificateInfo:info];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

}
- (CommonNoDaataFootView *)footView{
    if (!_footView) {
        _footView = [[CommonNoDaataFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    _footView.label.text = @"暂无数据";
    return _footView;
    
}
- (UIView *)footViewBlank{
    if (!_footViewBlank) {
        _footViewBlank = [UIView new];
    }
    return _footViewBlank;
}

- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc] init];
    }
    return _netWorkEngine;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
