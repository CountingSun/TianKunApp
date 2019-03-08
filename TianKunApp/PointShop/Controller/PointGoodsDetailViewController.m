//
//  PointGoodsDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PointGoodsDetailViewController.h"
#import "SDCycleScrollView.h"
#import <WebKit/WebKit.h>
#import "GoodsInfo.h"
#import "ExchangeGoodsViewController.h"
#import "GoodsDetailTableViewCell.h"

@interface PointGoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,SDCycleScrollViewDelegate,UIWebViewDelegate,WKNavigationDelegate>
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger goodsID;
@property (nonatomic ,strong) UIButton *footButton;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) SDCycleScrollView *bannerView;
@property (nonatomic ,strong) UIView *headView;
@property (nonatomic, strong) WKWebView *footView;

@property (nonatomic ,strong) NSMutableArray *arrPicture;
@property (nonatomic ,strong) GoodsInfo *goodsInfo;
@property (nonatomic ,assign) BOOL isRemove;




@end

@implementation PointGoodsDetailViewController
- (instancetype)initWithGoodsID:(NSInteger)goodsID{
    if (self = [super init]) {
        _goodsID = goodsID;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"商品详情"];
    [self headView];
    [self showLoadingView];
    [self getData];
    
    
}
- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc] init];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [dict setObject:@(_goodsID) forKey:@"id"];

    [_netWorkEngine postWithDict:dict url:BaseUrl(@"TkSpCommodityAPPController/selectspcommoditybyid.action") succed:^(id responseObject) {
        [self hideLoadingView];

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrPicture) {
                _arrPicture = [NSMutableArray   array];
                
            }
            NSMutableArray *resArr = [[responseObject objectForKey:@"value"] objectForKey:@"picture"];
            
            for (NSDictionary *dict in resArr) {
                [_arrPicture addObject:[dict objectForKey:@"picture_url"]];
            }
            self.bannerView.imageURLStringsGroup = _arrPicture;
            
            _goodsInfo = [GoodsInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"value"] objectForKey:@"sp"] ];
            [self.footView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_goodsInfo.synopsis_url]]];

            if (!_goodsInfo.number) {
                self.footButton.enabled = NO;
                [self.footButton setBackgroundColor:COLOR_TEXT_LIGHT];
                
            }
            [self.tableView reloadData];

            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                
                [self getData];
                
            }];
            
        }
        
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getData];
        }];
    }];
    
}

- (UIButton *)footButton{
    if (!_footButton) {
        _footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footButton setTitle:@"兑换" forState:0];
        [_footButton setTitleColor:[UIColor whiteColor] forState:0];
        [_footButton setBackgroundColor:COLOR_THEME];
        [_footButton addTarget:self action:@selector(footButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_footButton];
        
        [_footButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(45);
        }];
        
    }
    return _footButton;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 116;
        _tableView.bounces = NO;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.footButton.mas_top);
        }];
        _tableView.tableFooterView = self.footView;
        _tableView.tableHeaderView = self.headView;
        [_tableView registerNib:[UINib nibWithNibName:@"GoodsDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsDetailTableViewCell"];
        
        
        
    }
    return _tableView;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2) delegate:self placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_21]];
        [_headView addSubview:_bannerView];
        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_headView);
            make.height.offset(SCREEN_WIDTH/2);
            
        }];

    }
    return _headView;
    
}
- (WKWebView *)footView {
    if (!_footView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        
        wkWebConfig.userContentController = wkUController;
        
        _footView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01) configuration:wkWebConfig];
        _footView.navigationDelegate = self;
        _footView.scrollView.bouncesZoom = NO;
        if (@available(iOS 11.0, *)) {
            _footView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        [_footView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"DJWebKitContext"];

    }
    return _footView;
}
//实时改变webView的控件高度，使其高度跟内容高度一致
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (!self.footView.isLoading) {
        
        if([keyPath isEqualToString:@"scrollView.contentSize"]){
            
            CGRect frame = self.footView.frame;
            frame.size.height = self.footView.scrollView.contentSize.height;
            self.footView.frame = frame;
            [self.tableView reloadData];
            
        }
        
    }
}
#pragma mark-
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self hideLoadingView];
    
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
//    [_footView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    _isRemove = YES;
//    _tableView.bounces = YES;

}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
#pragma mark -- 拦截webview用户触击了一个链接

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
    }
    return YES;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _goodsInfo.name;
    cell.pointLabel.text = [NSString stringWithFormat:@"%@",@(_goodsInfo.integral)];
    cell.oldProceLabel.text = [NSString stringWithFormat:@"库存%@",@(_goodsInfo.number)];
    
    return cell;
    
}
- (void)footButtonClick{
    ExchangeGoodsViewController *vc = [[ExchangeGoodsViewController alloc] init];
    vc.goodsInfo = _goodsInfo;
    vc.succeedBlock = ^{
      
        if (_buySucceedBlock) {
            _buySucceedBlock();
            
        }
        _goodsInfo.number -- ;
        if (_goodsInfo.number<= 0) {
            _goodsInfo.number = 0;
        }
        if (!_goodsInfo.number) {
            self.footButton.enabled = NO;
            [self.footButton setBackgroundColor:COLOR_TEXT_LIGHT];
            
        }
        [self.tableView reloadData];

        
    };
//    self.definesPresentationContext = YES;
//    vc.view.backgroundColor = UIColorMask;
//    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:vc animated:YES completion:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc{
//    if (!_isRemove) {
        [_footView removeObserver:self forKeyPath:@"scrollView.contentSize"];

//    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
