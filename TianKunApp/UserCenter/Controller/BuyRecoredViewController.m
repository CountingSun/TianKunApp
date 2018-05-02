//
//  BuyRecoredViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "BuyRecoredViewController.h"
#import "BuyRecordTableViewCell.h"
#import "ReocrdDetailInfo.h"
#import "DocumentInfo.h"
#import "EducationDetailViewController.h"
#import "PlayViewController.h"

@interface BuyRecoredViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation BuyRecoredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
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
    [_netWorkEngine postWithDict:@{@"page":@(_pageIndex),@"count":@(_pageSize),@"userid":[UserInfoEngine getUserInfo].userID} url:BaseUrl(@"Learning/selectlearningbybuyuserid.action") succed:^(id responseObject) {
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
                    DocumentInfo *info = [DocumentInfo mj_objectWithKeyValues:dict];
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

- (void)setupUI{
    [self.titleView setTitle:@"购买记录"];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    [self.tableView registerNib:[UINib nibWithNibName:@"BuyRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuyRecordTableViewCell"];

}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 170;
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
    BuyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyRecordTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuyRecordTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;
        
    }
    DocumentInfo *info = _arrData[indexPath.row];
    cell.timeLabel.text = [NSString timeReturnDateString:info.create_date formatter:@"yyyy-MM-dd HH:mm"];
    cell.titleLabel.text = info.data_title;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",@(info.money)];
    [cell.infoImageView sd_imageDef11WithUrlStr:info.video_image_url];
    
//
//    [cell.titleImageView sd_imageDef11WithUrlStr:info.announcement_pictures];
//    cell.titleLabel.text = info.announcement_title;
//    cell.detailLabel.text = info.announcement_describe;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentInfo *info = _arrData[indexPath.row];
    if (info.type == 1) {
        EducationDetailViewController *vc = [[EducationDetailViewController alloc]initWithDocumentID:info.data_id];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PlayViewController *vc = [[PlayViewController alloc]initWithDocumentID:info.data_id];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
