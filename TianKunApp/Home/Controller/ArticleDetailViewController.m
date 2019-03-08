//
//  ArticleDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleDetailTimeTableViewCell.h"
#import "ArticleCommentTableViewCell.h"
#import "WriteArticleViewController.h"
#import "HomePublicInfo.h"
#import "CommentInfo.h"
#import "FileNoticceInfo.h"
#import "AppShared.h"
#import <WebKit/WebKit.h>
#import "TInvitationlistableViewCell.h"

@interface ArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *headerView;
@property (nonatomic ,strong) WQTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *leaveView;
@property (strong, nonatomic) IBOutlet UIView *aboutView;
@property (strong, nonatomic) IBOutlet UIView *lookMoreView;
@property (weak, nonatomic) IBOutlet QMUIButton *lookMoreButton;
@property (nonatomic ,assign) NSInteger count;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *lodingView;

/**
 精彩留言
 */
@property (nonatomic ,strong) NSMutableArray *arrMessage;

/**
 相关推荐
 */
@property (nonatomic ,strong) NSMutableArray *arrAbout;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,assign) NSInteger articleID;
@property (nonatomic ,assign) NSInteger fromType;

@property (nonatomic ,assign) NSInteger pageIndexAbout;
@property (nonatomic ,assign) NSInteger pageSizeAbout;
@property (nonatomic ,strong) HomePublicInfo *publicInfo;
@property (nonatomic ,strong) QMUIButton *collectButton;
@end

@implementation ArticleDetailViewController
- (instancetype)initWithArticleID:(NSInteger)articleID fromType:(NSInteger)fromType{
    if (self = [super init]) {
        _articleID = articleID;
        _fromType = fromType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"详情"];
    _pageSize = 3;
    _pageIndex = 1;
    _pageSizeAbout = DEFAULT_PAGE_SIZE;
    _pageIndexAbout = 1;

    _count = 2;
    [_lodingView stopAnimating];
    _lodingView.hidesWhenStopped = YES;
    [self.tableView reloadData];
    [self showLoadingView];
    if (_fromType == 1) {
        [self getData];

    }else if(_fromType == 2){
        [self getPublic];

    }else{
        [self getData];

    }

    
}


- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(1) forKey:@"startnum"];
    [paraDict setObject:@(1) forKey:@"endnum"];
    [paraDict setObject:@(_articleID) forKey:@"id"];

    if ([UserInfoEngine getUserInfo].userID) {
        [paraDict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];

    }
    NSString *urlStr = @"";
    
    if (_fromType == 3) {
        urlStr = BaseUrl(@"IndustryInformationController/findarticlenoticexqszzfnumbyid.action");
        
    }else{
        urlStr = BaseUrl(@"ArticleNotices/findarticlenoticexqszzfnumbyid.action");
    }
    [_netWorkEngine postWithDict:paraDict url:urlStr succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSDictionary *dict = [responseObject objectForKey:@"value"];
            _publicInfo = [[HomePublicInfo alloc]init];
            _publicInfo.publicID = [dict objectForKey:@"id"];
            _publicInfo.announcement_label = [dict objectForKey:@"article_label"];
            _publicInfo.create_date = [dict objectForKey:@"create_date"];
            _publicInfo.yonghushoucangid = [[dict objectForKey:@"yonghushoucangid"] integerValue];
            _publicInfo.zfnum = [[dict objectForKey:@"zfnum"] integerValue];
            _publicInfo.sznum = [[dict objectForKey:@"sznum"] integerValue];
            _publicInfo.announcement_describe = [dict objectForKey:@"article_describe"];
            _publicInfo.announcement_pictures = [dict objectForKey:@"article_pictures"];
            _publicInfo.page_title = [dict objectForKey:@"article_title"];

            _publicInfo.article_type = [[dict objectForKey:@"article_type"] integerValue];
            _publicInfo.announcement_details_url = [dict objectForKey:@"article_details_url"];
            
            
            [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_publicInfo.announcement_details_url dealToCanLoadUrl]]]];
            if (_fromType == 3) {
                [[[AddHistoryRecordNetwork alloc] init] addHistoryRecodeWithDataID:_articleID dataType:12 dataTypeTwo:_fromType data_title:_publicInfo.announcement_title data_sketch:_publicInfo.announcement_describe dataPictureUrl:_publicInfo.announcement_pictures];

            }else{
                [[[AddHistoryRecordNetwork alloc] init] addHistoryRecodeWithDataID:_articleID dataType:5 dataTypeTwo:_fromType data_title:_publicInfo.announcement_title data_sketch:_publicInfo.announcement_describe dataPictureUrl:_publicInfo.announcement_pictures];

            }

            [self getCommentList];
            [self getRecommend];
            
            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];
        }
        
    } errorBlock:^(NSError *error) {
        _pageIndex --;
        _pageIndex --;
        [self hideLoadingView];
        [self.tableView endRefresh];
        [self showGetDataErrorWithMessage:NET_ERROR_TOST reloadBlock:^{
            [self getData];
        }];

    }];
    
}
//MARK:获取评论列表
- (void)getCommentList{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(_pageIndex) forKey:@"startnum"];
    [paraDict setObject:@(_pageSize) forKey:@"endnum"];
    [paraDict setObject:@(_articleID) forKey:@"id"];
    NSString *urlStr = @"";
    
    if (_fromType == 3) {
        urlStr = BaseUrl(@"IndustryInformationController/selectcommentlist.action");
        
    }else{
        urlStr = BaseUrl(@"ArticleNotices/selectcommentlist.action");
    }

    [_netWorkEngine postWithDict:paraDict url:urlStr succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [_lodingView stopAnimating];

        _lookMoreButton.hidden = NO;
        

        if (code == 1) {
            _pageSize = DEFAULT_PAGE_SIZE;
            
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrMessage) {
                    _arrMessage = [NSMutableArray array];
                }
                if (_pageIndex == 1||_pageIndex == 1) {
                    [_arrMessage removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    CommentInfo *commentInfo = [CommentInfo mj_objectWithKeyValues:dict];
                    commentInfo.commen =[dict objectForKey:@"content"];
                    
                    [_arrMessage addObject:commentInfo];
                }
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

            }else{
                _pageIndex --;

            }
            
        }else{
        }
        
    } errorBlock:^(NSError *error) {
        [_lodingView stopAnimating];
        _lookMoreButton.hidden = NO;
        [self hideLoadingView];
        _pageIndex --;
        
    }];

}
//MARK:获取推荐列表
- (void)getRecommend{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(_pageIndexAbout) forKey:@"startnum"];
    [paraDict setObject:@(_pageSizeAbout) forKey:@"endnum"];
    [paraDict setObject:@(_publicInfo.article_type) forKey:@"article_type"];
    [paraDict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [paraDict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [paraDict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];
    [paraDict setObject:@(_articleID) forKey:@"id"];
    NSString *urlStr = @"";
    
    if (_fromType == 3) {
        urlStr = BaseUrl(@"IndustryInformationController/selectrecommend.action");
        
    }else{
        urlStr = BaseUrl(@"ArticleNotices/selectrecommend.action");
    }

    [_netWorkEngine postWithDict:paraDict url:urlStr succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrAbout) {
                    _arrAbout = [NSMutableArray array];
                }
                if (_pageIndexAbout == 1) {
                    [_arrAbout removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    FileNoticceInfo *info = [FileNoticceInfo mj_objectWithKeyValues:dict];
                    [_arrAbout addObject:info];
                }
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                
            }else{
                _pageIndexAbout --;
                
            }
            
        }else{
        }
        
    } errorBlock:^(NSError *error) {
        _lookMoreButton.hidden = NO;
        _pageIndexAbout --;
        
    }];
    
}
- (void)getPublic{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(1) forKey:@"startnum"];
    [paraDict setObject:@(1) forKey:@"endnum"];
    [paraDict setObject:@(_articleID) forKey:@"id"];
    
    if ([UserInfoEngine getUserInfo].userID) {
        [paraDict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
        
    }
    [_netWorkEngine postWithDict:paraDict url:BaseUrl(@"Announcement/findAnnouncementbyid.action") succed:^(id responseObject) {
        [self hideLoadingView];
        [self.tableView endRefresh];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSDictionary *dict = [responseObject objectForKey:@"value"];
            _publicInfo = [[HomePublicInfo alloc]init];
            _publicInfo.publicID = [dict objectForKey:@"id"];
            _publicInfo.announcement_label = [dict objectForKey:@"announcement_label"];
            _publicInfo.create_date = [dict objectForKey:@"create_date"];
            _publicInfo.yonghushoucangid = [[dict objectForKey:@"shoucangyonghuid"] integerValue];
            _publicInfo.zfnum = [[dict objectForKey:@"zfnum"] integerValue];
            _publicInfo.sznum = [[dict objectForKey:@"sznum"] integerValue];
            _publicInfo.announcement_details_url = [dict objectForKey:@"announcement_details_url"];
            _publicInfo.article_type = [[dict objectForKey:@"article_type"] integerValue];
            _publicInfo.announcement_title = [dict objectForKey:@"announcement_title"];
            _publicInfo.announcement_describe = [dict objectForKey:@"announcement_describe"];


            [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_publicInfo.announcement_details_url dealToCanLoadUrl]]]];

            [self getPublicCommentList];
            [self getPublicRecommend];
            [[[AddHistoryRecordNetwork alloc] init] addHistoryRecodeWithDataID:_articleID dataType:4 dataTypeTwo:_fromType data_title:_publicInfo.announcement_title data_sketch:_publicInfo.announcement_describe dataPictureUrl:@""];

            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];

                [self getPublic];
            }];
            
        }
        
    } errorBlock:^(NSError *error) {
        _pageIndex --;
        [self hideLoadingView];
        [self.tableView endRefresh];
        [self showGetDataErrorWithMessage:NET_ERROR_TOST reloadBlock:^{
            [self showLoadingView];

            [self getPublic];
        }];
    }];

}
- (void)getPublicCommentList{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(_pageIndex) forKey:@"startnum"];
    [paraDict setObject:@(_pageSize) forKey:@"endnum"];
    [paraDict setObject:@(_articleID) forKey:@"id"];
    
    [_netWorkEngine postWithDict:paraDict url:BaseUrl(@"Announcement/selectcommentlist.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [_lodingView stopAnimating];
        _lookMoreButton.hidden = NO;
        
        
        if (code == 1) {
            _pageSize = DEFAULT_PAGE_SIZE;

            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrMessage) {
                    _arrMessage = [NSMutableArray array];
                }
                if (_pageIndex == 1||_pageIndex == 2) {
                    [_arrMessage removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    CommentInfo *commentInfo = [CommentInfo mj_objectWithKeyValues:dict];
                    commentInfo.commen =[dict objectForKey:@"content"];
                    
                    [_arrMessage addObject:commentInfo];
                }
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                
            }else{
                _pageIndex --;
                
            }
            
        }else{
        }
        
    } errorBlock:^(NSError *error) {
        [_lodingView stopAnimating];
        _lookMoreButton.hidden = NO;
        [self hideLoadingView];
        _pageIndex --;
        
    }];
    

}
- (void)getPublicRecommend{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(_pageIndexAbout) forKey:@"startnum"];
    [paraDict setObject:@(_pageSizeAbout) forKey:@"endnum"];
    [paraDict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [paraDict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [paraDict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];
    [paraDict setObject:@(_articleID) forKey:@"id"];

    [_netWorkEngine postWithDict:paraDict url:BaseUrl(@"Announcement/selectrecommend.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrAbout) {
                    _arrAbout = [NSMutableArray array];
                }
                if (_pageIndexAbout == 1) {
                    [_arrAbout removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    FileNoticceInfo *info = [FileNoticceInfo mj_objectWithKeyValues:dict];
                    info.article_title = [dict objectForKey:@"announcement_title"];
                    info.article_details = [dict objectForKey:@"announcement_details"];

                    
                    [_arrAbout addObject:info];
                }
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                
            }else{
                _pageIndexAbout --;
                
            }
            
        }else{
        }
        
    } errorBlock:^(NSError *error) {
        _lookMoreButton.hidden = NO;
        _pageIndexAbout --;
        
    }];

}
- (WKWebView *)headerView {
    if (!_headerView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";

       WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

     WKUserContentController *wkUController = [[WKUserContentController alloc] init];

      [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
        wkWebConfig.userContentController = wkUController;

        _headerView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01) configuration:wkWebConfig];
        _headerView.navigationDelegate = self;
        _headerView.scrollView.bouncesZoom = NO;
        if (@available(iOS 11.0, *)) {
            _headerView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
//        [_headerView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"DJWebKitContext"];
        
    }
    return _headerView;
}
//实时改变webView的控件高度，使其高度跟内容高度一致
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (!_headerView.isLoading) {
        
        if([keyPath isEqualToString:@"scrollView.contentSize"]){
            
            CGRect frame = self.headerView.frame;
            frame.size.height = self.headerView.scrollView.contentSize.height;
            self.headerView.frame = frame;
            [self.tableView reloadData];

        }
        
    }
    
//
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGRect frame = self.headerView.frame;
//        frame.size.height = self.headerView.scrollView.contentSize.height;
//        self.headerView.frame = frame;
//        [self.tableView reloadData];
//    }
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return _arrMessage.count;
    }else{
        return _arrAbout.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        ArticleDetailTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleDetailTimeTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleDetailTimeTableViewCell" owner:nil options:nil] firstObject];
            [cell.shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        if (_publicInfo.yonghushoucangid) {
            cell.collectButton.selected = YES;
        }else{
            cell.collectButton.selected = NO;
        }
        _collectButton = cell.collectButton;
        
        [cell.collectButton setTitle:[NSString stringWithFormat:@"%@",@(_publicInfo.sznum)] forState:0];
        [cell.shareButton setTitle:[NSString stringWithFormat:@"%@",@(_publicInfo.zfnum)] forState:0];
        cell.timeLabel.text = [NSString timeReturnDateString:_publicInfo.create_date formatter:@"yyyy-MM-dd"];
        
        cell.selectionStyle = 0;
        
        return cell;

    }else if (indexPath.section == 1){
        ArticleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCommentTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleCommentTableViewCell" owner:nil options:nil] firstObject];
        }
        CommentInfo *info = _arrMessage[indexPath.row];
        cell.timeLabel.text = [NSString timeReturnDateString:info.create_date formatter:@"yyyy-MM-dd"] ;
        cell.contentLbel.text = info.commen;
        cell.naemLabel.text = info.username;
        [cell.headImageView sd_imageWithUrlStr:info.touxiang placeholderImage:@"头像"];

        cell.selectionStyle = 0;
        return cell;

    }else{
        TInvitationlistableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TInvitationlistableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TInvitationlistableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = 0;
            
        }
        FileNoticceInfo *info = _arrAbout[indexPath.row];

        cell.titleLabel.text = info.article_title;
        cell.timeLabel.text = [NSString timeReturnDate:[NSNumber numberWithInteger:[info.create_date integerValue]]];
        return cell;

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
        
    }else{
        return 40;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if(section == 1){
        return 50;
    }else{
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return _leaveView;
        
        
    }else if (section == 2){
        return _aboutView;
    }else{
        return [UIView new];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        [_lookMoreButton setImagePosition:QMUIButtonImagePositionRight];
        [_lookMoreButton setSpacingBetweenImageAndTitle:5];
        return _lookMoreView;
    }
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        FileNoticceInfo *info = _arrAbout[indexPath.row];
        
        ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]initWithArticleID:[info.article_id integerValue] fromType:_fromType];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
#pragma mark-
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self hideLoadingView];
    [self hideEmptyView];
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];

    [webView evaluateJavaScript:@"Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"
              completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                  if (!error) {
                      NSNumber *height = result;
                      CGRect frame = self.headerView.frame;
                      frame.size.height = [height doubleValue];
                      self.headerView.frame = frame;
                      [self.tableView reloadData];

                  }
              }];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self hideLoadingView];
    
    [self showGetDataFailViewWithReloadBlock:^{
        [self showLoadingView];
        
        [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_publicInfo.announcement_details_url dealToCanLoadUrl]]]];
    }];

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoadingView];

    [self showGetDataFailViewWithReloadBlock:^{
        [self showLoadingView];

        [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_publicInfo.announcement_details_url dealToCanLoadUrl]]]];
    }];
    
    
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


- (IBAction)lookMoreButtonClick:(id)sender {
    _pageIndex++;
    [_lodingView startAnimating];
    _lookMoreButton.hidden = YES;
    
    if (_fromType == 1) {
        [self getCommentList];

    }else if (_fromType == 2){
        [self getPublicCommentList];

    }else{
        [self getCommentList];

    }
    
}

- (IBAction)leaveMessageButtonClick:(id)sender {
    if ([UserInfoEngine isLogin]) {
        WriteArticleViewController *vc = [[WriteArticleViewController alloc]initWithArticleID:_articleID fromType:_fromType];
        vc.succeedBlcok = ^{
            if (_fromType == 1) {
                [self getCommentList];
            }else if(_fromType == 2){
                [self getPublicCommentList];
            }else{
                [self getCommentList];

            }

        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)shareButtonClick{
    
    id images;
    if (_publicInfo.announcement_pictures.length) {
        images = @[_publicInfo.announcement_pictures];
        
    } else {
        images = [UIImage imageNamed:@"AppIcon"];
    }
    __weak typeof(self) weakSelf = self;
    
    [AppShared shareParamsByText:_publicInfo.announcement_describe images:images url:DEFAULT_SHARE_URL title:_publicInfo.page_title succeedBlock:^(NSInteger type) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if ([UserInfoEngine getUserInfo].userID.length) {
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
            
        }else{
            [dict setObject:@(0) forKey:@"user_id"];
            
        }
        //        fromType 1 文件通知  2 公示公告 3行业信息
        NSString *urlStr = @"";
        
        NSString *forwar_where = @"";
        
        switch (type) {
            case 37:
                forwar_where = @"微信收藏";
                break;
                case 22:
                forwar_where = @"微信好友";
                break;
            case 23:
                forwar_where = @"微信朋友圈";
                break;
            case 24:
                forwar_where = @"QQ好友";
                break;
            case 6:
                forwar_where = @"QQ空间";
                break;

            default:
                break;
        }
        
        if (weakSelf.fromType == 1) {
            [dict setObject:@(_articleID) forKey:@"article_notice_id"];
            urlStr = BaseUrl(@"/ArticleNotices/insertarticlenoticeforword.action");
            [dict setObject:forwar_where forKey:@"forwar_where"];

        }else if (weakSelf.fromType == 2){
            urlStr = BaseUrl(@"/Announcement/insertannouncemeneforword.action");
            [dict setObject:@(_articleID) forKey:@"announcement_id"];
            [dict setObject:forwar_where forKey:@"forword_where"];

        }else{
            urlStr = BaseUrl(@"/IndustryInformationController/insertarticlenoticeforword.action");
            [dict setObject:@(_articleID) forKey:@"article_notice_id"];
            [dict setObject:forwar_where forKey:@"forwar_where"];
            
            
        }
        
        
        
        
        [weakSelf.netWorkEngine postWithDict:dict url:urlStr succed:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1) {
                weakSelf.publicInfo.zfnum++;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        } errorBlock:^(NSError *error) {
            
        }];
    }];

}
- (void)collectButtonClick:(QMUIButton *)button{
    if (![UserInfoEngine isLogin]) {
        return;
    }
    _collectButton.enabled = NO;
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *url = @"";
    if (_fromType == 1) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
        [dict setObject:@(_articleID) forKey:@"article_notice_id"];
        if (_publicInfo.yonghushoucangid) {
            [dict setObject:@(2) forKey:@"type"];
            [dict setObject:@(_publicInfo.yonghushoucangid) forKey:@"id"];
            
        }else{
            [dict setObject:@(1) forKey:@"type"];
        }
        
        url= BaseUrl(@"ArticleNotices/insertarticlenoticecollectible.action");
    }else if(_fromType == 2){
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
        [dict setObject:@(_articleID) forKey:@"announcement_id"];
        if (_publicInfo.yonghushoucangid) {
            [dict setObject:@(2) forKey:@"type"];
            [dict setObject:@(_publicInfo.yonghushoucangid) forKey:@"id"];
            
        }else{
            [dict setObject:@(1) forKey:@"type"];
        }
        
        url= BaseUrl(@"Announcement/insertannouncemenecollectible.action");

    }else{
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
        [dict setObject:@(_articleID) forKey:@"article_notice_id"];
        if (_publicInfo.yonghushoucangid) {
            [dict setObject:@(2) forKey:@"type"];
            [dict setObject:@(_publicInfo.yonghushoucangid) forKey:@"id"];
            
        }else{
            [dict setObject:@(1) forKey:@"type"];
        }
        
        url= BaseUrl(@"IndustryInformationController/insertarticlenoticecollectible.action");

    }
    [self showWithStatus:NET_WAIT_TOST];
    [_netWorkEngine postWithDict:dict url:url succed:^(id responseObject) {
        _collectButton.enabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
//            button.selected = ! button.selected;
            _publicInfo.yonghushoucangid = [[responseObject objectForKey:@"value"] integerValue];

            
            if (_publicInfo.yonghushoucangid) {
                [self showSuccessWithStatus:@"收藏成功"];
                _publicInfo.sznum++;
                
                
            }else{
                [self showSuccessWithStatus:@"取消收藏成功"];
                _publicInfo.sznum--;

            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
        
    } errorBlock:^(NSError *error) {
        _collectButton.enabled = YES;

        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (void)dealloc{
//    [_headerView.scrollView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
