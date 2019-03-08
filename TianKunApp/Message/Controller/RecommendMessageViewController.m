//
//  RecommendMessageViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RecommendMessageViewController.h"
#import "RecommendMessageTableViewCell.h"
#import "TKMessageInfo.h"
#import "MessageDetailViewController.h"
#import "IconBadgeManager.h"

@interface RecommendMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation RecommendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"今日推荐" ];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendMessageTableViewCell"];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
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
    if ([UserInfoEngine getUserInfo].userID) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userId"];
    }
    [dict setObject:@(_pageIndex) forKey:@"pageNo"];
    [dict setObject:@(_pageSize) forKey:@"pageSize"];
    [dict setObject:@"1" forKey:@"recommend_message"];

    [_netWorkEngine postWithDict:dict url:BaseUrl(@"find.recommendMessage.by") succed:^(id responseObject) {
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
                    TKMessageInfo *info = [TKMessageInfo mj_objectWithKeyValues:dict];
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
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 264;
        _tableView.separatorColor = COLOR_VIEW_BACK;
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
    RecommendMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendMessageTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendMessageTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;
        
    }
    

    TKMessageInfo *messageInfo =_arrData[indexPath.row];
    cell.titleLabel.text = messageInfo.title;
    [cell.mainImageView sd_imageDef21WithUrlStr:messageInfo.picture_url];
    cell.timeLabel.text = [NSString timeReturnDateString:messageInfo.create_date formatter:@"yyyy-MM-dd HH:mm"];
    cell.detailLabel.text = messageInfo.content;
    if ([IconBadgeManager isContainsRecomendMessageID:[NSString stringWithFormat:@"%@",@(messageInfo.message_id)]]) {
        cell.isReadLabel.hidden = NO;
    }else{
        cell.isReadLabel.hidden = YES;
    }

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TKMessageInfo *messageInfo =_arrData[indexPath.row];
    MessageDetailViewController *webLinkViewController = [[MessageDetailViewController alloc] initWithMessageID:messageInfo.message_id isRead:messageInfo.is_read];
    __weak typeof(self) weakSelf = self;
    
    webLinkViewController.readBlock = ^{
        messageInfo.is_read = 1;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    
    webLinkViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webLinkViewController animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
