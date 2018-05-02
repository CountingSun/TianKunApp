
//
//  InteractionDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "InteractionDetailViewController.h"
#import "CommentTableViewCell.h"
#import "CommentViewController.h"
#import <YYCategories/YYCategories.h>
#import "UIView+Extension.h"
#import "CommentListViewController.h"
#import "InteractionInfo.h"
#import "CommentInfo.h"
//#import <WebKit/WebKit.h>
#import "AppShared.h"

@interface InteractionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,QMUIKeyboardManagerDelegate>
//@property (nonatomic, strong) WKWebView *headerView;
@property (nonatomic ,strong) WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrMessage;
@property (strong, nonatomic) IBOutlet UIView *commentTitleView;
@property (nonatomic ,strong) CommentViewController  * customViewController;
@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet QMUIButton *shareButton;

@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;
@property (nonatomic ,strong) QMUIKeyboardManager *keyboardManager;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;

@property (weak, nonatomic) IBOutlet UIView *twoButtonBaseView;

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) InteractionInfo *interactionInfo;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (strong, nonatomic) UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (nonatomic ,assign) BOOL isCommentSucced;
@property (strong, nonatomic) UIView *blankFootView;
@property (strong, nonatomic) IBOutlet UIView *noDataFootView;
@property (strong, nonatomic) IBOutlet UIView *noMoreDataFootView;

@property (nonatomic, copy) NSString *interactionID;

/**
 是否是对评论的回复
 */
@property (nonatomic ,assign) BOOL isReplyUser;
@property (nonatomic ,strong) CommentInfo *currectCommentInfo;

@end

@implementation InteractionDetailViewController
- (instancetype)initWithInteractionID:(NSString *)interactionID{
    if (self = [super init]) {
        _interactionID = interactionID;
    }
    return self;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"正文"];
    
    
    

//    [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cpc.people.com.cn/n1/2018/0405/c64094-29908833.html"]]];
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    _blankFootView = [UIView new];
    

    [self showLoadingView];

    [self getInteractionInfo];
    

}
- (void)getInteractionInfo{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@"1" forKey:@"startnum"];
    [paraDict setObject:@"1" forKey:@"endnum"];
    [paraDict setObject:_interactionID forKey:@"id"];
    if ([UserInfoEngine getUserInfo].userID) {
        [paraDict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    }

    
    [self.netWorkEngine postWithDict:paraDict url:BaseUrl(@"Forums/selectForumbyid.action") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _interactionInfo = [InteractionInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            [self setupView];
            [self getData];

        }else{
            
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getInteractionInfo];
            }];
            
        }


    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getInteractionInfo];
        }];
        
    }];

}
- (void)getData{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(_pageIndex) forKey:@"startnum"];
    [paraDict setObject:@(_pageSize) forKey:@"endnum"];
    [paraDict setObject:_interactionID forKey:@"id"];
    if ([UserInfoEngine getUserInfo].userID) {
        [paraDict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    }

    [self.netWorkEngine postWithDict:paraDict url:BaseUrl(@"Forums/selectForumbyid.action") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if(!_arrMessage){
                _arrMessage = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrMessage removeAllObjects];
            }
            NSMutableArray *arrComment = [[responseObject objectForKey:@"value"] objectForKey:@"comments"];
            for (NSDictionary *dict in arrComment) {
                CommentInfo *info = [CommentInfo mj_objectWithKeyValues:dict];
                [_arrMessage addObject:info];
            }
            [self.tableView reloadData];
            if (_arrMessage.count == 0) {
                self.tableView.tableFooterView = _noDataFootView;
                
            }else{
                self.tableView.tableFooterView = _blankFootView;

            }
            if (_isCommentSucced) {
                [self.tableView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
                _isCommentSucced = NO;
                
            }
            [self.tableView endRefresh];

            if (!arrComment.count) {
                self.tableView.tableFooterView = _noMoreDataFootView;
                _tableView.canLoadMore = NO;

            }
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            if (_arrMessage.count == 0) {
                self.tableView.tableFooterView = _noMoreDataFootView;
                
            }else{
                self.tableView.tableFooterView = _noDataFootView;
                
            }

        }
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        
//        [self showGetDataFailViewWithReloadBlock:^{
//            [self showLoadingView];
//            [self getData];
//        }];
        if (_arrMessage.count == 0) {
            self.tableView.tableFooterView = _noDataFootView;
            
        }else{
            self.tableView.tableFooterView = _noMoreDataFootView;
            
        }

    }];
    
    
}
#pragma mark - view
- (void)setupView{
    self.tableView.tableHeaderView = _headView;
    _titleLabel.text = _interactionInfo.title;
    _timeLabel.text = [NSString timeReturnDateString:_interactionInfo.create_date formatter:@"MM-dd hh:mm"];
    _headLabel.text = _interactionInfo.content;
    
    _titleLabel.textColor = COLOR_TEXT_BLACK;
    _timeLabel.textColor = COLOR_TEXT_LIGHT;
    _headLabel.textColor = COLOR_TEXT_BLACK;
    
    
    CGSize size = [_interactionInfo.content boundingRectWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)];
    
    CGSize titleSize = [_interactionInfo.title boundingRectWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(_headView).offset(10);
        make.right.equalTo(_headView).offset(-10);

        make.height.offset(titleSize.height);
        
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headView).offset(10);
        make.right.equalTo(_headView).offset(-10);

        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.height.offset(20);
        
    }];
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headView).offset(10);
        make.right.equalTo(_headView).offset(-10);

        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        make.bottom.equalTo(_headView.mas_bottom).offset(-10);
        
    }];
    
    
    _headView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, size.height+titleSize.height+40+20);
    

    
    [_collectButton setImagePosition:QMUIButtonImagePositionLeft];
    [_shareButton setImagePosition:QMUIButtonImagePositionLeft];
    
    [_collectButton setSpacingBetweenImageAndTitle:5];
    [_shareButton setSpacingBetweenImageAndTitle:5];
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];

    if (_interactionInfo.shoucangid) {
        _collectButton.selected = YES;
    }else{
        _collectButton.selected = NO;

    }
    
    _keyboardManager = [[QMUIKeyboardManager alloc]initWithDelegate:self];

    _twoButtonBaseView.backgroundColor = COLOR_VIEW_BACK;
    [_keyboardManager addTargetResponder:_textView];
    _publicButton.hidden = YES;
    _cancelButton.hidden = YES;
    _twoButtonBaseView.hidden = NO;
    
    _keyBoardView.backgroundColor = COLOR_VIEW_BACK;
    
    
    [_keyBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(60);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_keyBoardView).offset(10);
        make.right.equalTo(_keyBoardView).offset(-140);
        make.bottom.equalTo(_keyBoardView.mas_bottom).offset(-10);
        make.top.equalTo(_keyBoardView.mas_top).offset(10);
        
    }];
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = COLOR_VIEW_SEGMENTATION.CGColor;
    
    
    [_twoButtonBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_keyBoardView).offset(-10);
        make.bottom.equalTo(_keyBoardView.mas_bottom).offset(-10);
        make.top.equalTo(_keyBoardView.mas_top).offset(10);
        make.width.mas_offset(120);
    }];
    [_collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(_twoButtonBaseView);
        make.width.offset(60);
        
        
    }];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(_twoButtonBaseView);
        make.width.offset(60);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_keyBoardView);
        make.width.offset(60);
        make.height.offset(30);
        
        
    }];
    [_publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_keyBoardView);
        make.right.equalTo(_keyBoardView.mas_right);
        make.width.offset(60);
        make.height.offset(30);
        
        
    }];


}
- (void)keyboardShowMason{
    _twoButtonBaseView.hidden = YES;
    _cancelButton.hidden = NO;
    _publicButton.hidden = NO;
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_keyBoardView).offset(-10);
        make.top.equalTo(_keyBoardView).offset(30);
    }];
    [_keyBoardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(150);

    }];

    

    
}
- (void)keyboardHidenMason{
    _twoButtonBaseView.hidden = NO;
    _cancelButton.hidden = YES;
    _publicButton.hidden = YES;
    [_keyBoardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(60);

    }];
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_keyBoardView).offset(10);
        make.right.equalTo(_keyBoardView).offset(-140);

    }];
    

}
#pragma lazy load
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_tableView];
        __weak typeof(self) weakSelf = self;
        
//        [_tableView headerWithRefreshingBlock:^{
//            _pageIndex = 1;
//
//            [weakSelf getData];
//        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex++;
            [weakSelf getData];
            
        }];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(_keyBoardView.mas_top);
            
        }];
    }
    return _tableView;
}
//- (WKWebView *)headerView {
//    if (!_headerView) {
//        _headerView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40)];
//        _headerView.navigationDelegate = self;
//        [_headerView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//
////        [_headerView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
//    }
//    return _headerView;
//}
//- (UIProgressView *)progressView
//{
//    if(!_progressView)
//    {
//        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
//        self.progressView.tintColor = COLOR_THEME;
//        self.progressView.trackTintColor = [UIColor whiteColor];
//        [self.view addSubview:self.progressView];
//    }
//    return _progressView;
//}

/*
#pragma mark - observe
//实时改变webView的控件高度，使其高度跟内容高度一致
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect frame = self.headerView.frame;
        frame.size.height = self.headerView.scrollView.contentSize.height;
        self.headerView.frame = frame;
        [self.tableView reloadData];
    }
    
    if (object == self.headerView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }

}
 */
#pragma mark- ======================= tableview delegate datasource ==================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _arrMessage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = 0;

        }
    CommentInfo *info = _arrMessage[indexPath.row];
    cell.commentInfo = info;
    cell.clickButtonBlock = ^(CommentInfo *commentInfo) {
        
        _isReplyUser = YES;
        
        [_textView becomeFirstResponder];
        _textView.placeholder = [NSString stringWithFormat:@"回复：%@",commentInfo.pinglunrenname];
        _currectCommentInfo = commentInfo;
    };
    
    [cell.headImage sd_imageWithUrlStr:info.pinglunrentouxiang placeholderImage:@"头像"];
    cell.contentLabel.text = info.commen;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@回复",[NSString updateTimeForTimeString:info.create_date],@(info.hfnum)];
    
    cell.nameLabel.text = info.pinglunrenname;
    
//    cell.nameLabel.text = [NSString timeReturnDateString:info.create_date];
    
    
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        return _commentTitleView;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentInfo *info = _arrMessage[indexPath.row];

    CommentListViewController *commentListViewController = [[CommentListViewController alloc]initWithCommentInfo:info];
    [self.navigationController pushViewController:commentListViewController animated:YES];
}
/*
#pragma mark - WKWebView代理
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self hideLoadingView];
    __block CGFloat webViewHeight;
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        NSLog(@"%f",webViewHeight);
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect frame = self.headerView.frame;
            frame.size.height = webViewHeight;
            self.headerView.frame = frame;
            [self.tableView reloadData];
        });
    }];
    
    NSLog(@"结束加载");
    

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[self.tableView class]]) {
        
        [self.headerView setNeedsLayout];
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self hideLoadingView];
    
    [self showGetDataFailViewWithReloadBlock:^{
        [self showLoadingView];
        
        [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baike.baidu.com/item/iOS/45705?fr=aladdin"]]];
    }];

}
//// 如果不添加这个，那么wkwebview跳转不了AppStore
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}
*/

#pragma mark - <QMUIKeyboardManagerDelegate>

- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            
            [self keyboardShowMason];
            
            
        } completion:NULL];
    } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{

            [self keyboardHidenMason];


        } completion:NULL];
    }];
}

- (void)dealloc{
//    [_headerView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//    [_headerView removeObserver:self forKeyPath:@"estimatedProgress"];

}
- (IBAction)cancelButtonClick:(id)sender {
    _isReplyUser = NO;
    _textView.placeholder = @"说点什么吧";
    [_textView endEditing:YES];
}

#pragma makr =====发送评论=======
- (IBAction)publicButtobClick:(id)sender {
    if ([UserInfoEngine isLogin]) {
        
        
        if (!_textView.text.length) {
            [self showErrorWithStatus:@"请输入评论内容"];
            return;

        }
        if (_isReplyUser) {
            [self showWithStatus:@"正在发送，请稍候"];
            [self.netWorkEngine postWithDict:@{@"comments_id":_currectCommentInfo.commen_id,@"reply_user_id":_currectCommentInfo.user_id,@"user_id":[UserInfoEngine getUserInfo].userID,@"commen":_textView.text} url:BaseUrl(@"Forums/insertforumcommentsreply.action") succed:^(id responseObject) {
                NSInteger code  = [[responseObject objectForKey:@"code"] integerValue];
                if (code == 1) {

                [self showSuccessWithStatus:@"评论成功"];
                //                CommentInfo *info = [[CommentInfo alloc]init];
                //                info.commen = _textView.text;
                _pageIndex = 1;
                _isCommentSucced = YES;
                
                [self getData];
                
                _textView.text = @"";
                [_textView endEditing:YES];
                    _isReplyUser = NO;
                    _textView.placeholder = @"说点什么吧";

                    
                    
                    
                }else{
                    [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                }
                
                
            } errorBlock:^(NSError *error) {
                
                [self showErrorWithStatus:NET_ERROR_TOST];
            }];

        }else{
            [self showWithStatus:@"正在发送，请稍候"];
            [self.netWorkEngine postWithDict:@{@"forum_id":_interactionInfo.interactionID,@"user_id":[UserInfoEngine getUserInfo].userID,@"commen":_textView.text} url:BaseUrl(@"Forums/insertforumcomment.action") succed:^(id responseObject) {
                
                NSInteger code  = [[responseObject objectForKey:@"code"] integerValue];
                if (code == 1) {
                    [self showSuccessWithStatus:@"评论成功"];
                    //                CommentInfo *info = [[CommentInfo alloc]init];
                    //                info.commen = _textView.text;
                    _pageIndex = 1;
                    _isCommentSucced = YES;
                    
                    [self getData];
                    
                    _textView.text = @"";
                    [_textView endEditing:YES];
                    
                }else{
                    [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                }
                
                
            } errorBlock:^(NSError *error) {
                [self showErrorWithStatus:NET_ERROR_TOST];
                
            }];

        }
    }
    
}
- (IBAction)shareButtonClick:(id)sender {
    [AppShared shared];
}
- (IBAction)colloctButtonClicl:(id)sender {
    
    if (![UserInfoEngine isLogin]) {
        return;
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (_collectButton.selected) {
        [dictionary setObject:@(_interactionInfo.shoucangid) forKey:@"Id"];
        [dictionary setObject:@(2) forKey:@"type"];
    }else{
        [dictionary setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
        [dictionary setObject:@(1) forKey:@"type"];
        [dictionary setObject:_interactionInfo.interactionID forKey:@"article_notice_id"];
    }
    [self showWithStatus:NET_WAIT_TOST];
    
    [self.netWorkEngine postWithDict:dictionary url:BaseUrl(@"Forums/insertforumcollectible.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _collectButton.selected =! _collectButton.selected;
            if (_collectButton.selected) {
                [self showSuccessWithStatus:@"收藏成功"];
                _interactionInfo.shoucangid = [[responseObject objectForKey:@"value"] integerValue];
                
            }else{
                [self showSuccessWithStatus:@"取消收藏成功"];
            }
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
    
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


@end
