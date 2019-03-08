//
//  EducationDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationDetailViewController.h"
#import "EducationTableViewCell.h"
#import <WebKit/WebKit.h>
#import "DocumentInfo.h"
#import "EductationNetworkEngine.h"
#import "BuyDocumentView.h"
#import "MyVIPViewController.h"
#import "SingleBuyDocumentView.h"
#import "CollectShareView.h"
#import "AppShared.h"


@interface EducationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,BuyDocumentViewDelegate>
@property (nonatomic, strong) UIWebView *headerView;
@property (nonatomic ,strong) WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) DocumentInfo *documentInfo;
@property (nonatomic ,assign) NSInteger documentID;
@property (nonatomic ,strong) EductationNetworkEngine *eductationNetworkEngine;
@property (strong, nonatomic) IBOutlet UIView *goBuyView;
@property (weak, nonatomic) IBOutlet UIButton *boBuyButton;
@property (nonatomic ,strong) BuyDocumentView *buyDocumentView;
@property (nonatomic ,strong) SingleBuyDocumentView *singleBuyDocumentView;
@property (nonatomic ,strong) CollectShareView *collectShareView;

@end

@implementation EducationDetailViewController
- (instancetype)initWithDocumentID:(NSInteger)documentID{
    if (self = [super init]) {
        _documentID = documentID;
    }
    return self;
}
- (instancetype)initWithDocumentInfo:(DocumentInfo *)documentInfo{
    if (self = [super init]) {
        _documentInfo = documentInfo;
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"正文"];
    self.tableView.tableHeaderView = self.headerView;
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(paySucceedNotice:) name:PAY_SUCCEED_NOTICE object:nil];
    [center addObserver:self selector:@selector(loginSucceedNotice:) name:LOGIN_SUCCEED_NOTICE object:nil];

    self.tableView.canLoadMore = NO;

    if (_documentInfo) {
        if (_documentInfo.canSee == 1) {
            if (_documentInfo.date_details_url.length) {
                [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_documentInfo.date_details_url]]];
                
            }
        }else{
            if (_documentInfo.date_details_url.length) {
                [self.headerView loadHTMLString:_documentInfo.synopsis baseURL:[NSURL URLWithString:BaseUrl(@""])];
                 
                 }
                 }
                 [self setupNav];
                 
                 if (_documentInfo.collectID) {
                     _collectShareView.collectButton.selected = YES;
                     
                 }else{
                     _collectShareView.collectButton.selected = NO;
                 }
                 
                 [self getRecommend];
    }else{
        [self showLoadingView];
        [self getData];
    }

    
}
- (void)setupNav{
    if (!_collectShareView) {
        __weak typeof(self) weakSelf = self;

        _collectShareView = [[CollectShareView alloc] initWithFrame:CGRectMake(0, 0, 80, 40) collectButtonBlock:^{
            [weakSelf collect];
        } shareButtonBlock:^{
            
            
            id images;
            if (weakSelf.documentInfo.video_image_url.length) {
                images = @[_documentInfo.video_image_url];
                
            } else {
                images = [UIImage imageNamed:@"AppIcon"];
            }

            
            [AppShared shareParamsByText:weakSelf.documentInfo.data_title1 images:images url:DEFAULT_SHARE_URL title:weakSelf.documentInfo.data_title];

        }];
        
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_collectShareView];
    
}

-(void)paySucceedNotice:(id)sender{
    [self showLoadingView];
    [self getData];
}
 -(void)loginSucceedNotice:(id)sender{
     [self showLoadingView];
     [self getData];
 }

- (IBAction)goBuyButtonClick:(id)sender {
    if([UserInfoEngine isLogin]){
        if (!_buyDocumentView) {
            _buyDocumentView = [[BuyDocumentView alloc]initWithNib];
            _buyDocumentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            _buyDocumentView.delegate = self;
            
        }
        [_buyDocumentView showBuyDocumentView];
    }
}

- (void)getData{
    if (!_eductationNetworkEngine) {
        _eductationNetworkEngine = [[EductationNetworkEngine alloc]init];
    }
    [_eductationNetworkEngine getEductationInfoWithDocumentID:_documentID returnBlock:^(NSInteger code, NSString *msg, DocumentInfo *documentInfo) {
        if (code == 1) {
            
            _documentInfo = documentInfo;
            if (_documentInfo.canSee == 1) {
                if (_documentInfo.date_details_url.length) {
                    [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_documentInfo.date_details_url]]];
                    
                }
            }else{
                if (_documentInfo.date_details_url.length) {
                    [self.headerView loadHTMLString:_documentInfo.synopsis baseURL:[NSURL URLWithString:BaseUrl(@""])];
                    
                }
            }
                [self setupNav];

             if (_documentInfo.collectID) {
                 _collectShareView.collectButton.selected = YES;
                 
             }else{
                 _collectShareView.collectButton.selected = NO;
             }
                     if(_reloadBlock){
                         _reloadBlock();
                     }
            [self getRecommend];
            
        }else if(code == -1){
            [self hideLoadingView];

            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];

        }else{
            [self hideLoadingView];

            [self showGetDataErrorWithMessage:msg reloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];

            
        }
    }];
}
                
- (void)getRecommend{
    if (!_eductationNetworkEngine) {
        _eductationNetworkEngine = [[EductationNetworkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    [_eductationNetworkEngine postWithPageIndex:_pageIndex pageSize:_pageSize dataType2:_documentInfo.data_type2 calssType:_documentInfo.type docID:_documentID returnBlock:^(NSInteger code,NSString *msg, NSMutableArray *arrData) {
        if (code == 1) {
            if(!_arrData){
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
            }
            [_arrData addObjectsFromArray:arrData];
            [self.tableView reloadData];
            if (arrData.count<_pageSize) {
                self.tableView.canLoadMore= NO;
            }else{
                self.tableView.canLoadMore= YES;
            }
            
        }else if(code == -1){
            [self showErrorWithStatus:NET_ERROR_TOST];
            _pageIndex--;
        }else{
            [self showErrorWithStatus:msg];
            _pageIndex--;

        }
        
    }];
    
    
}
- (void)collect{
    if (![UserInfoEngine isLogin]) {
        return;
    }
    _collectShareView.collectButton.enabled = NO;
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:@(_documentInfo.data_id) forKey:@"learning_notice_id"];
    if (_collectShareView.collectButton.selected) {
        [dict setObject:@(2) forKey:@"type"];
        [dict setObject:@(_documentInfo.collectID) forKey:@"id"];
        
    }else{
        [dict setObject:@(1) forKey:@"type"];
    }
    
    
    [self showWithStatus:NET_WAIT_TOST];
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"Learning/insertforumcollectible.action") succed:^(id responseObject) {
        _collectShareView.collectButton.enabled = YES;
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
                _collectShareView.collectButton.selected =! _collectShareView.collectButton.selected;
                
                if (_collectShareView.collectButton.selected) {
                    [self showSuccessWithStatus:@"收藏成功"];
                    _documentInfo.collectID = [[responseObject objectForKey:@"value"] integerValue];
                    
                }else{
                    [self showSuccessWithStatus:@"取消收藏成功"];
                    
                }
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
        
    } errorBlock:^(NSError *error) {
        _collectShareView.collectButton.enabled = YES;
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (UIWebView *)headerView {
    if (!_headerView) {
        _headerView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        _headerView.delegate = self;
        
        [_headerView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _headerView;
}
//实时改变webView的控件高度，使其高度跟内容高度一致
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect frame = self.headerView.frame;
        frame.size.height = self.headerView.scrollView.contentSize.height;
        self.headerView.frame = frame;
        [self.tableView reloadData];
    }
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 140;
        [self.view addSubview:_tableView];
        __weak typeof(self)  weakSelf = self;
        
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex++;
            [weakSelf getRecommend];
        }];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  _arrData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EducationTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EducationTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;
        
    }
    
    DocumentInfo *info = _arrData[indexPath.section];
    [cell.titleImageView sd_imageDef11WithUrlStr:info.video_image_url];
    cell.titleLabel.text = info.data_title;
    cell.detailLabel.text = info.synopsis;
    if (info.is_charge) {
        cell.isFreeLabel.text = @"收费";
    }else{
        cell.isFreeLabel.text = @"免费";
        
    }
    if(![ISVipManager isOpenVip]){
        cell.isFreeLabel.hidden = YES;
    }
    cell.numLabel.text = [NSString stringWithFormat:@"浏览%@次",@(info.hits_show)];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_documentInfo.canSee == 1){
        
    }else{
        if(section == 0)
            return 40;
    }

        return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

        return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_documentInfo.canSee == 1){
        
    }else{
        if(section == 0)
            return _goBuyView;
    }
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentInfo *info = _arrData[indexPath.section];
    
    EducationDetailViewController *vc = [[EducationDetailViewController alloc]initWithDocumentID:info.data_id];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark-
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoadingView];
    [self showGetDataErrorWithMessage:@"数据加载失败" reloadBlock:^{
        [self showLoadingView];
        
        [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_documentInfo.date_details_url]]];
    }];
    
    
}
//MARK:BuyDocumentViewDelegate
- (void)buyVIPButtonClickDelegate{
    if([UserInfoEngine isLogin]){
        MyVIPViewController *myVIPViewController = [[MyVIPViewController alloc]init];
        [self.navigationController pushViewController:myVIPViewController animated:YES];
    }
    

}
//MARK:单个购买
- (void)buyDocumentButtonClickDelegate{
    if (!_singleBuyDocumentView) {
        _singleBuyDocumentView = [[SingleBuyDocumentView alloc]initWithNib];
        _singleBuyDocumentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        __weak typeof(self) weakSelf = self;
        _singleBuyDocumentView.pauSucceedBlock = ^{
            [weakSelf showLoadingView];
            [weakSelf getData];
        };
    }
    _singleBuyDocumentView.documentID = _documentInfo.data_id;
    [_singleBuyDocumentView showSingleBuyDocumentView];

}

- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
}
- (void)dealloc{
    [_headerView.scrollView removeObserver:self forKeyPath:@"contentSize"];
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
