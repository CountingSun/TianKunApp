//
//  SystemMessageViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageTableViewCell.h"
#import "TKMessageInfo.h"

#import "JobDetailViewController.h"
#import "FindJodDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "InteractionDetailViewController.h"

@interface SystemMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"系统消息"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SystemMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"SystemMessageTableViewCell"];
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
    [_netWorkEngine postWithDict:@{@"pageNo":@(_pageIndex),@"pageSize":@(_pageSize),@"recommend_message":@"2"} url:BaseUrl(@"find.recommendMessage.by") succed:^(id responseObject) {
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
        _tableView.estimatedRowHeight = 286;
        _tableView.separatorColor = COLOR_VIEW_BACK;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [_tableView headerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView endRefresh];
                
            });
            
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
    SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemMessageTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemMessageTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;

    }
    TKMessageInfo *messageInfo =_arrData[indexPath.row];

    cell.titleLabel.text = messageInfo.title;
    [cell.mainImageView sd_imageDef21WithUrlStr:BaseUrl(messageInfo.picture_url)];
    cell.timeLabel.text = [NSString timeReturnDateString:messageInfo.create_date formatter:@"yyyy-MM-dd HH:mm"];
    cell.detailLabel.text = messageInfo.content;
    
    return cell;
    
}



//MARK: 根据ID 类型 跳转到相应详情
- (void)jumpTodetailWithHistoryinfo:(TKMessageInfo *)info{
    //  private Short data_type;//资料(信息)类型: 1岗位信息,2简历信息,3文件通知,4公示公告,5招投标信息,6教育培训,7互动交流,8企业信息(APP发布),9企业信息(WEB发布)
    switch (info.data_type) {
        case 1:
        {
            JobDetailViewController *viewController = [[JobDetailViewController alloc] initWithJobID:[NSString stringWithFormat:@"%@",@(info.data_id)]];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:{
            
            FindJodDetailViewController *viewController = [[FindJodDetailViewController alloc] initWithResumeID:[NSString stringWithFormat:@"%@",@(info.data_id)]];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 3:{
            
            ArticleDetailViewController *viewController = [[ArticleDetailViewController alloc] initWithArticleID:info.data_id fromType:1];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4:{
            
            ArticleDetailViewController *viewController = [[ArticleDetailViewController alloc] initWithArticleID:info.data_id fromType:0];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 7:{
            
            InteractionDetailViewController *viewController = [[InteractionDetailViewController alloc] initWithInteractionID:[NSString stringWithFormat:@"%@",@(info.data_id)]];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
            
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TKMessageInfo *messageInfo =_arrData[indexPath.row];
    [self jumpTodetailWithHistoryinfo:messageInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
