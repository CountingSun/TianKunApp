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
#import "HomeListTableViewCell.h"
#import "WriteArticleViewController.h"
#import "HomePublicInfo.h"
#import "CommentInfo.h"
#import "FileNoticceInfo.h"
#import "AppShared.h"

@interface ArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *headerView;
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
    _pageSize = DEFAULT_PAGE_SIZE;
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

    }else{
        [self getPublic];

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
    [_netWorkEngine postWithDict:paraDict url:BaseUrl(@"ArticleNotices/findarticlenoticexqszzfnumbyid.action") succed:^(id responseObject) {
        
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

            _publicInfo.article_type = [[dict objectForKey:@"article_type"] integerValue];
            _publicInfo.announcement_details_url = [dict objectForKey:@"article_details_url"];
            
            
            [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_publicInfo.announcement_details_url dealToCanLoadUrl]]]];

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
    
    [_netWorkEngine postWithDict:paraDict url:BaseUrl(@"ArticleNotices/selectcommentlist.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [_lodingView stopAnimating];

        _lookMoreButton.hidden = NO;
        

        if (code == 1) {
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrMessage) {
                    _arrMessage = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
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
    
    [_netWorkEngine postWithDict:paraDict url:BaseUrl(@"ArticleNotices/selectrecommend.action") succed:^(id responseObject) {
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
            _publicInfo.yonghushoucangid = [[dict objectForKey:@"yonghushoucangid"] integerValue];
            _publicInfo.zfnum = [[dict objectForKey:@"zfnum"] integerValue];
            _publicInfo.sznum = [[dict objectForKey:@"sznum"] integerValue];\
            _publicInfo.announcement_details_url = [dict objectForKey:@"announcement_details_url"];
            _publicInfo.article_type = [[dict objectForKey:@"article_type"] integerValue];

            [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_publicInfo.announcement_details_url dealToCanLoadUrl]]]];

            [self getPublicCommentList];
            [self getPublicRecommend];
            
            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self getPublic];
            }];
            
        }
        
    } errorBlock:^(NSError *error) {
        _pageIndex --;
        [self hideLoadingView];
        [self.tableView endRefresh];
        [self showGetDataErrorWithMessage:NET_ERROR_TOST reloadBlock:^{
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
        
        _lookMoreButton.hidden = NO;
        
        
        if (code == 1) {
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrMessage) {
                    _arrMessage = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
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
- (UIWebView *)headerView {
    if (!_headerView) {
        _headerView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        _headerView.delegate = self;
        _headerView.scrollView.bouncesZoom = NO;
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
        HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeListTableViewCell" owner:nil options:nil] firstObject];
        }
        FileNoticceInfo *info = _arrAbout[indexPath.row];
        
        [cell.titleImageView sd_imageDef11WithUrlStr:[NSString stringWithFormat:@"%@%@",BaseUrl(@"image/appIcon/"),info.article_pictures]];
        cell.titleLabel.text = info.article_title;
        cell.detailLabel.text = info.article_details;

        cell.selectionStyle = 0;
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
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoadingView];

    [self showGetDataNullWithReloadBlock:^{
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
    
    [self getCommentList];
    
}

- (IBAction)leaveMessageButtonClick:(id)sender {
    if ([UserInfoEngine isLogin]) {
        WriteArticleViewController *vc = [[WriteArticleViewController alloc]initWithArticleID:_articleID fromType:_fromType];
        vc.succeedBlcok = ^{
            if (_fromType == 1) {
                [self getCommentList];
            }else{
                [self getPublicCommentList];
            }

        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)shareButtonClick{
    [AppShared shared] ;
    
}
- (void)collectButtonClick:(QMUIButton *)button{
    button.enabled = NO;
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *url = @"";
    if (_fromType) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
        [dict setObject:@(_articleID) forKey:@"article_notice_id"];
        if (button.selected) {
            [dict setObject:@(2) forKey:@"type"];
            [dict setObject:@(_publicInfo.yonghushoucangid) forKey:@"id"];
            
        }else{
            [dict setObject:@(1) forKey:@"type"];
        }
        
        url= BaseUrl(@"ArticleNotices/insertarticlenoticecollectible.action");
    }else{
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
        [dict setObject:@(_articleID) forKey:@"announcement_id"];
        if (button.selected) {
            [dict setObject:@(2) forKey:@"type"];
            [dict setObject:@(_publicInfo.yonghushoucangid) forKey:@"id"];
            
        }else{
            [dict setObject:@(1) forKey:@"type"];
        }
        
        url= BaseUrl(@"Announcement/insertannouncemenecollectible.action");

    }
    [self showWithStatus:NET_WAIT_TOST];
    [_netWorkEngine postWithDict:dict url:url succed:^(id responseObject) {
        button.enabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            button.selected = ! button.selected;
            _publicInfo.yonghushoucangid = [[responseObject objectForKey:@"value"] integerValue];

            if (button.selected) {
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
        button.enabled = YES;

        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (void)dealloc{
    [_headerView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
