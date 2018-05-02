//
//  FileNoticceListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FileNoticceListViewController.h"
#import "HomeListTableViewCell.h"
#import "ClassTypeInfo.h"
#import "FileNoticceInfo.h"
#import "ArticleDetailViewController.h"

@interface FileNoticceListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) ClassTypeInfo *classTypeInfo;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation FileNoticceListViewController
- (instancetype)initWithClassTypeInfo:(ClassTypeInfo *)classTypeInfo{
    if(self = [super init]){
        _classTypeInfo = classTypeInfo;
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:0];
        
    }
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;

    [self.tableView registerNib:[UINib nibWithNibName:@"HomeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeListTableViewCell"];
    [self showLoadingView];
    [self getData];

    
}
- (void)getData{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }

    [self.netWorkEngine postWithDict:@{@"lb":_classTypeInfo.typeID,@"startnum":@(_pageIndex),@"endnum":@(_pageSize)} url:BaseUrl(@"ArticleNotices/findarticlenoticefenyebyid.action") succed:^(id responseObject) {
        [self hideLoadingView];
        [self.tableView endRefresh];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrData) {
                    _arrData = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    FileNoticceInfo *info = [FileNoticceInfo mj_objectWithKeyValues:dict];
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
                
                [self showErrorWithStatus:NET_WAIT_NO_DATA];
                
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
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            weakSelf.pageIndex=1;
            [weakSelf getData];
        }];
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex++;
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
    HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeListTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;

    }
    FileNoticceInfo *info = _arrData[indexPath.row];
    
    [cell.titleImageView sd_imageDef11WithUrlStr:info.article_pictures];
    cell.titleLabel.text = info.article_title;
    cell.detailLabel.text = info.article_describe;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FileNoticceInfo *info = _arrData[indexPath.row];

    ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]initWithArticleID:[info.article_id integerValue] fromType:1];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NetWorkEngine *)netWorkEngine{
    if(!_netWorkEngine){
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
