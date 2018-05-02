//
//  FindImageListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindImageListViewController.h"
#import "FindImageListTableViewCell.h"
#import "CompanyDetailViewController.h"
#import "EnterpriseInfo.h"
#import "CompanyInfo.h"
#import "FindListTableViewCell.h"

@interface FindImageListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic, copy) NSString *viwTitle;
@property (nonatomic ,copy)NSString * classID;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation FindImageListViewController

- (instancetype)initWithViewTitle:(NSString *)viewTitle classID:(NSString *)classID{
    if (self = [super init]) {
        _viwTitle = viewTitle;
        _classID = classID;
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:_viwTitle];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;

    [self.tableView registerNib:[UINib nibWithNibName:@"FindImageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindImageListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindListTableViewCell"];

    [self showLoadingView];
    [self getData];
    
}
- (void)getData{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }

    [self.netWorkEngine postWithDict:@{@"categoryid":_classID,@"pageNo":@(_pageIndex),@"pageSize":@(_pageSize)} url:BaseUrl(@"find.by.enterpriseList") succed:^(id responseObject) {
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
                    [self showGetDataNullWithReloadBlock:^{
                        [self showLoadingView];
                        [self getData];
                    }];
                    
                    
                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
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
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
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
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EnterpriseInfo *enterpriseInfo = _arrData[indexPath.row];

//    if ([_classID isEqualToString:@"23"]) {
//        FindListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindListTableViewCell"];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"FindImageListTableViewCell" owner:nil options:nil] firstObject];
//
//        }
//        cell.titleLabel.text = enterpriseInfo.enterprise_name;
//        cell.detailLabel.text = enterpriseInfo.enterprise_introduce;
//
//        cell.selectionStyle = 0;
//        return cell;
//
//    }else{
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

//    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EnterpriseInfo *enterpriseInfo = _arrData[indexPath.row];

    CompanyDetailViewController *viewController = [[CompanyDetailViewController alloc]initWithCompanyID:enterpriseInfo.enterprise_id type:2];
    [self.navigationController pushViewController:viewController animated:YES];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
