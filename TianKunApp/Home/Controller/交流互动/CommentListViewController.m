//
//  CommentListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentTableViewCell.h"
#import <YYCategories/YYCategories.h>
#import "CommentInfo.h"
#import "CommentTableViewCell.h"

@interface CommentListViewController ()<UITableViewDataSource,UITableViewDelegate,QMUIKeyboardManagerDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *keyboardBaseView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (nonatomic ,strong) QMUIKeyboardManager *keyboardManager;
@property (nonatomic ,strong) CommentInfo *commentInfo;
@property (nonatomic ,strong) NSMutableArray *arrMessage;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (strong, nonatomic) IBOutlet UIView *noDataFootView;
@property (strong, nonatomic) IBOutlet UIView *noMoreDataFootView;
@property (strong, nonatomic) UIView *blankFootView;
@property (nonatomic ,assign) BOOL isCommentSucced;

@end

@implementation CommentListViewController
- (instancetype)initWithCommentInfo:(CommentInfo *)commentInfo{
    if (self = [super init]) {
        _commentInfo = commentInfo;
        
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"评论详情"];

    [self setupView];

    [self.tableView registerNib:[UINib nibWithNibName:@"InteractionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InteractionListTableViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    _blankFootView = [UIView new];
    [self showLoadingView];
    [self getData];
}
- (void)getData{
    [self.netWorkEngine postWithDict:@{@"id":_commentInfo.commen_id,@"startnum":@(_pageIndex),@"endnum":@(_pageSize)} url:BaseUrl(@"Forums/selectForumCommentsReplybyid.action") succed:^(id responseObject) {
        [self hideLoadingView];
        [self.tableView endRefresh];

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if(!_arrMessage){
                _arrMessage = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrMessage removeAllObjects];
            }
            NSMutableArray *arrComment = [[responseObject objectForKey:@"value"] objectForKey:@"pinglunhuineirong"];
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
        [self.tableView endRefresh];

        [self hideLoadingView];
        if (_arrMessage.count == 0) {
            self.tableView.tableFooterView = _noDataFootView;
            
        }else{
            self.tableView.tableFooterView = _noMoreDataFootView;
            
        }
        
    }];
    
    
}

- (void)publicReply{
    [self.netWorkEngine postWithDict:@{@"comments_id":_commentInfo.commen_id,@"reply_user_id":_commentInfo.user_id,@"user_id":[UserInfoEngine getUserInfo].userID,@"commen":_textView.text} url:BaseUrl(@"Forums/insertforumcommentsreply.action") succed:^(id responseObject) {

        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"回复成功"];
            _textView.text = @"";
            _isCommentSucced = YES;
            [_textView endEditing:YES];
            _pageIndex = 1;
            [_tableView beginRefreshing];
            [self getData];
            
            
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
        
    } errorBlock:^(NSError *error) {
        
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
    
}
- (void)setupView{
    _keyboardManager = [[QMUIKeyboardManager alloc]initWithDelegate:self];
    [_keyboardManager addTargetResponder:_textView];
    _publicButton.hidden = YES;
    _cancelButton.hidden = YES;
    _keyboardBaseView.backgroundColor = COLOR_VIEW_BACK;
    
    
    [_keyboardBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(60);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_keyboardBaseView).offset(10);
        make.right.equalTo(_keyboardBaseView).offset(-10);
        make.bottom.equalTo(_keyboardBaseView.mas_bottom).offset(-10);
        make.top.equalTo(_keyboardBaseView.mas_top).offset(10);
        
    }];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_keyboardBaseView);
        make.width.offset(60);
        make.height.offset(35);
        
        
    }];
    [_publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_keyboardBaseView);
        make.right.equalTo(_keyboardBaseView.mas_right);
        make.width.offset(60);
        make.height.offset(35);
        
        
    }];


}
- (void)keyboardShowMason{
    _cancelButton.hidden = NO;
    _publicButton.hidden = NO;
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_keyboardBaseView).offset(35);
    }];
    [_keyboardBaseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(150);
    }];
    
    
    
    
}
- (void)keyboardHidenMason{
    _cancelButton.hidden = YES;
    _publicButton.hidden = YES;
    [_keyboardBaseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(60);
        
    }];
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_keyboardBaseView).offset(10);
        
    }];
    
    
}

- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            _pageIndex = 1;
            [weakSelf getData];
            
        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex++;
            [weakSelf getData];

        }];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.equalTo(self.view);
            make.bottom.equalTo(_keyboardBaseView.mas_top);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return _arrMessage.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = 0;
            
        }
        CommentInfo *info = _commentInfo;
        
        [cell.commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [_textView becomeFirstResponder];
        }];
        [cell.headImage sd_imageWithUrlStr:info.pinglunrentouxiang placeholderImage:@"头像"];
        cell.contentLabel.text = info.commen;
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@回复",[NSString updateTimeForTimeString:info.create_date],@(info.hfnum)];
        cell.commentButton .hidden = YES;
        cell.nameLabel.text = info.pinglunrenname;
        return cell;
        
    }else{
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = 0;
            
        }
        CommentInfo *info = _arrMessage[indexPath.row];
        
        [cell.commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [_textView becomeFirstResponder];
        }];
        [cell.headImage sd_imageWithUrlStr:info.pinglunrentouxiang placeholderImage:@"头像"];
        cell.contentLabel.text = info.commen;
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@回复",[NSString updateTimeForTimeString:info.create_date],@(info.hfnum)];
        
        cell.nameLabel.text = info.pinglunrenname;
        [cell.commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        }];
        
        return cell;

    }
}


- (IBAction)cancelButtonClickEvent:(id)sender {
    [_textView endEditing:YES];
    
}
- (IBAction)publicButtonClickEvent:(id)sender {
    
    if (!_textView.text.length) {
        [self showErrorWithStatus:@"请输入回复内容"];
    }
    [self publicReply];
}





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
