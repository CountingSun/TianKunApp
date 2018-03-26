
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


@interface InteractionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,QMUIKeyboardManagerDelegate>
@property (nonatomic, strong) UIWebView *headerView;
@property (nonatomic ,strong) WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrMessage;
@property (strong, nonatomic) IBOutlet UIView *commentTitleView;
@property (nonatomic ,strong) CommentViewController  * customViewController;
@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (nonatomic ,strong) QMUIKeyboardManager *keyboardManager;

@end

@implementation InteractionDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"正文"];
    _arrMessage = [NSMutableArray array];
    [_arrMessage addObject:@"AAAAAAA0"];
    [_arrMessage addObject:@"AAAAAAA1"];
    [_arrMessage addObject:@"AAAAAAA2"];
    [self.tableView reloadData];
    [self.headerView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
//    [self showLoadingView];
    
    _keyboardManager = [[QMUIKeyboardManager alloc]initWithDelegate:self];

    [_keyboardManager addTargetResponder:_textView];
    
    [_keyBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_offset(50);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(_keyBoardView).offset(10);
        
    }];
    
    
    
    
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
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(_keyBoardView.mas_top);
            
        }];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
    [cell.commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (!self.customViewController) {
            self.customViewController = [[CommentViewController alloc] init];
        }
        if (!self.customViewController.view.superview) {
            [self.customViewController showInParentViewController:self.navigationController];
        } else {
            [self.customViewController.textView resignFirstResponder];
        }

    }];
    
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
#pragma mark - <QMUIKeyboardManagerDelegate>

- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    __weak __typeof(self)weakSelf = self;
    [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:weakSelf.view keyboardRect:keyboardUserInfo.endFrame];
            
            [_keyBoardView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);

                make.height.offset(150);

            }];
            [_keyBoardView layoutIfNeeded];

            
        } completion:NULL];
    } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{

            [_keyBoardView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);

                make.height.offset(50);
                
            }];
            [_keyBoardView layoutIfNeeded];

        } completion:NULL];
    }];
}
/**
 *  键盘已经显示
 */
- (void)keyboardDidShowWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo{
    [_keyBoardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(150);
    }];
    [_keyBoardView layoutIfNeeded];


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
