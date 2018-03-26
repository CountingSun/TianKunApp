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

@interface ArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *headerView;
@property (nonatomic ,strong) WQTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *leaveView;
@property (strong, nonatomic) IBOutlet UIView *aboutView;
@property (strong, nonatomic) IBOutlet UIView *lookMoreView;
@property (weak, nonatomic) IBOutlet QMUIButton *lookMoreButton;
@property (nonatomic ,assign) NSInteger count;


/**
 精彩留言
 */
@property (nonatomic ,strong) NSMutableArray *arrMessage;

/**
 相关推荐
 */
@property (nonatomic ,strong) NSMutableArray *arrAbout;


@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"详情"];

    _arrAbout = [NSMutableArray array];
    [_arrAbout addObject:@""];
    [_arrAbout addObject:@""];
    [_arrAbout addObject:@""];
    [_arrAbout addObject:@""];
    [_arrAbout addObject:@""];
    [_arrAbout addObject:@""];
    [_arrAbout addObject:@""];
    [_arrAbout addObject:@""];
    [_arrAbout addObject:@""];

    _arrMessage = [NSMutableArray array];
    [_arrMessage addObject:@"AAAAAAA0"];
    [_arrMessage addObject:@"AAAAAAA1"];
    [_arrMessage addObject:@"AAAAAAA2"];

    _count = 2;

    [self.tableView reloadData];
    [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baike.baidu.com/item/iOS/45705?fr=aladdin"]]];
    [self showLoadingView];

    
}
- (UIWebView *)headerView {
    if (!_headerView) {
        _headerView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
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
        }
        cell.selectionStyle = 0;
        return cell;

    }else if (indexPath.section == 1){
        ArticleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCommentTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleCommentTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.naemLabel.text = _arrMessage[indexPath.row];
        cell.selectionStyle = 0;
        return cell;

    }else{
        HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeListTableViewCell" owner:nil options:nil] firstObject];
        }
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

        [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baike.baidu.com/item/iOS/45705?fr=aladdin"]]];
    }];
    
    
}


- (IBAction)lookMoreButtonClick:(id)sender {
    for (NSInteger i = 0; i<4; i++) {
        _count++;
        
        [_arrMessage addObject:[NSString stringWithFormat:@"AAAAAA%@",@(_count)]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_arrMessage.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        

    }
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]] withRowAnimation:UITableViewRowAnimationFade];

}

- (IBAction)leaveMessageButtonClick:(id)sender {
    WriteArticleViewController *vc = [[WriteArticleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc{
    [_headerView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
