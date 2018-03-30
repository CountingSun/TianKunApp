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

@interface EducationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *headerView;
@property (nonatomic ,strong) WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@end

@implementation EducationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"正文"];
    
    _arrData = [NSMutableArray array];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];

    
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return  _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EducationTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EducationTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = 0;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=2721528669,2849290984&fm=173&app=25&f=JPEG?w=218&h=146&s=5229B044DADEFE9ED03B559E0300D09F"] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_11]];
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return CGFLOAT_MIN;
        
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return CGFLOAT_MIN;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationDetailViewController *vc = [[EducationDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
