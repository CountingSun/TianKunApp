//
//  EducationTextListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationTextListViewController.h"
#import "EducationTextTableViewCell.h"
#import "EducationDetailViewController.h"
#import "DocumentInfo.h"
#import "DocumentPropertyInfo.h"

@interface EducationTextListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) NSMutableDictionary *dict;


@end

@implementation EducationTextListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    _pageSize = 16;

    [self.tableView registerNib:[UINib nibWithNibName:@"EducationTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"EducationTextTableViewCell"];
    [self showLoadingView];
    
}
- (void)reloadWithDocumentPropertyInfo:(DocumentPropertyInfo *)documentPropertyInfo{
    
    [self.dict removeAllObjects];
    _pageIndex = 1;
    [self.dict setObject:@(_pageSize) forKey:@"num"];
    [self.dict setObject:@(_pageIndex) forKey:@"stratnum"];
    [self.dict setObject:@(documentPropertyInfo.classType) forKey:@"k"];
    [self.dict setObject:@(documentPropertyInfo.documentClass) forKey:@"l"];
    [self.dict setObject:@(documentPropertyInfo.isFree) forKey:@"m"];
    [self.dict setObject:@(documentPropertyInfo.documentType) forKey:@"z"];
    
    [self.tableView beginRefreshing];
    self.tableView.canLoadMore = NO;

    [self getDocumentListWithDict:self.dict];
    
}

- (void)getDocumentListWithDict:(NSMutableDictionary *)dict{
    if (_pageIndex <1) {
        _pageIndex = 1;
    }
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"Learning/selectlearninglistbytj.action") succed:^(id responseObject) {
        [self.tableView endRefresh];
        [self hideLoadingView];
        [self hideEmptyView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1) {
            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
                
            }
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            for (NSDictionary *dict in arr) {
                DocumentInfo *info = [DocumentInfo mj_objectWithKeyValues:dict];
                [_arrData addObject:info];
            }
            [self.tableView reloadData];
            if (!_arrData.count) {
                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    
                    [self getDocumentListWithDict:self.dict];
                }];

            }
            if (arr.count<_pageSize) {
                self.tableView.canLoadMore = NO;
            }else{
                self.tableView.canLoadMore = YES;
            }

        }else{
            _pageIndex--;
            if (_arrData.count) {
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
            }else{
                [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                    [self showLoadingView];

                    [self getDocumentListWithDict:self.dict];
                }];
                
            }
            
        }
    } errorBlock:^(NSError *error) {
        [self hideEmptyView];
        [self hideLoadingView];
        [self.tableView endRefresh];
        _pageIndex--;

        if (_arrData.count) {
            [self showErrorWithStatus:NET_ERROR_TOST];
            
        }else{
            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getDocumentListWithDict:self.dict];
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
        _tableView.estimatedRowHeight = 120;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [self.view addSubview:_tableView];
        __weak typeof(self)  weakSelf = self;
        [_tableView headerWithRefreshingBlock:^{
            _pageIndex = 1;
            [self.dict setObject:@(weakSelf.pageIndex) forKey:@"stratnum"];
            [weakSelf getDocumentListWithDict:self.dict];
        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex ++;
            [self.dict setObject:@(weakSelf.pageIndex) forKey:@"stratnum"];
            [weakSelf getDocumentListWithDict:self.dict];
        }];
        
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrData.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EducationTextTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EducationTextTableViewCell" owner:nil options:nil] firstObject];
    }
    DocumentInfo *info = _arrData[indexPath.section];
    cell.documentInfo = info;
    
    return cell;
    
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
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentInfo *info = _arrData[indexPath.section];
    EducationDetailViewController *vc = [[EducationDetailViewController alloc]initWithDocumentID:info.data_id];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
}
- (NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}


@end
