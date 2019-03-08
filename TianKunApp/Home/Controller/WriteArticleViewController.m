//
//  WriteArticleViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WriteArticleViewController.h"

@interface WriteArticleViewController ()
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic, assign) NSInteger articleID;
@property (nonatomic, assign) NSInteger fromType;
@end


@implementation WriteArticleViewController
- (instancetype)initWithArticleID:(NSInteger)articleID fromType:(NSInteger)fromType{
    if (self = [super init]) {
        _articleID = articleID;
        _fromType = fromType;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"留言"];
    _commitButton.layer.masksToBounds = YES;
    _commitButton.layer.cornerRadius = _commitButton.qmui_height/2;
    [_commitButton setBackgroundColor:COLOR_THEME];
    QMUIEmotionInputManager *inputManager = [[QMUIEmotionInputManager alloc]init];
    inputManager.boundTextView = _textView;
    
 
    
}
- (IBAction)commentButtonClick:(id)sender {
    if (!_textView.text.length) {
        [self showErrorWithStatus:@"请输入留言内容"];
        return;
    }
    [self showWithStatus:NET_WAIT_TOST];
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }

    if (_fromType == 1) {
        [_netWorkEngine postWithDict:@{@"user_id":[UserInfoEngine getUserInfo].userID,@"article_notice_id":@(_articleID),@"content":_textView.text} url:BaseUrl(@"ArticleNotices/insertarticlenoticecomment.action") succed:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1) {
                self.view.userInteractionEnabled = NO;

                [self showSuccessWithStatus:@"评论成功"];
                if (_succeedBlcok) {
                    _succeedBlcok();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            }
            
        } errorBlock:^(NSError *error) {
            [self showErrorWithStatus:NET_ERROR_TOST];
            
        }];

    }else if(_fromType == 2){
        [_netWorkEngine postWithDict:@{@"user_id":[UserInfoEngine getUserInfo].userID,@"announcement_id":@(_articleID),@"content":_textView.text} url:BaseUrl(@"Announcement/insertannouncemenecomment.action") succed:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1) {
                self.view.userInteractionEnabled = NO;
                [self showSuccessWithStatus:@"评论成功"];
                if (_succeedBlcok) {
                    _succeedBlcok();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            }
            
        } errorBlock:^(NSError *error) {
            [self showErrorWithStatus:NET_ERROR_TOST];
            
        }];

    }else{
        [_netWorkEngine postWithDict:@{@"user_id":[UserInfoEngine getUserInfo].userID,@"article_notice_id":@(_articleID),@"content":_textView.text} url:BaseUrl(@"IndustryInformationController/insertarticlenoticecomment.action") succed:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1) {
                self.view.userInteractionEnabled = NO;
                
                [self showSuccessWithStatus:@"评论成功"];
                if (_succeedBlcok) {
                    _succeedBlcok();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            }
            
        } errorBlock:^(NSError *error) {
            [self showErrorWithStatus:NET_ERROR_TOST];
            
        }];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
