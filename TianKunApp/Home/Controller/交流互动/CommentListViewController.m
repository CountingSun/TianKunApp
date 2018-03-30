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

@interface CommentListViewController ()<UITableViewDataSource,UITableViewDelegate,QMUIKeyboardManagerDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (weak, nonatomic) IBOutlet UIView *keyboardBaseView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (nonatomic ,strong) QMUIKeyboardManager *keyboardManager;

@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"评论详情"];

    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:0];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InteractionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InteractionListTableViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView endRefresh];
        
    });
    
    [self.tableView reloadData];
    [self setupView];
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
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [_tableView headerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView endRefresh];
                
            });
            
        }];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.equalTo(self.view);
            make.bottom.equalTo(_keyboardBaseView.mas_top);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;
        
    }
    [cell.commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
    }];
    
    return cell;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
