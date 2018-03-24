//
//  MyPublickViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublickViewController.h"

@interface MyPublickViewController ()
@property (weak, nonatomic) IBOutlet UIView *topBaseView;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;
@property (weak, nonatomic) IBOutlet UIButton *companyButton;
@property (weak, nonatomic) IBOutlet UIButton *communityButton;

@end

@implementation MyPublickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"我的发布"];
    [self setupView];
    
}
- (void)setupView{
    _topBaseView.layer.masksToBounds = YES;
    _topBaseView.layer.cornerRadius = _topBaseView.qmui_height/2;
    _topBaseView.layer.borderWidth = 1;
    _topBaseView.layer.borderColor = COLOR_THEME.CGColor;

    _inviteButton.layer.masksToBounds = YES;
    _inviteButton.layer.cornerRadius = _topBaseView.qmui_height/2;
    [_inviteButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_WHITE] forState:UIControlStateNormal];
    [_inviteButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_THEME] forState:UIControlStateSelected];
    [_inviteButton setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    [_inviteButton setTitleColor:COLOR_WHITE forState:UIControlStateSelected];
    _inviteButton.selected = YES;
    
    _resumeButton.layer.masksToBounds = YES;
    _resumeButton.layer.cornerRadius = _topBaseView.qmui_height/2;
    [_resumeButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_WHITE] forState:UIControlStateNormal];
    [_resumeButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_THEME] forState:UIControlStateSelected];
    [_resumeButton setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    [_resumeButton setTitleColor:COLOR_WHITE forState:UIControlStateSelected];

    _companyButton.layer.masksToBounds = YES;
    _companyButton.layer.cornerRadius = _topBaseView.qmui_height/2;
    [_companyButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_WHITE] forState:UIControlStateNormal];
    [_companyButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_THEME] forState:UIControlStateSelected];
    [_companyButton setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    [_companyButton setTitleColor:COLOR_WHITE forState:UIControlStateSelected];

    _communityButton.layer.masksToBounds = YES;
    _communityButton.layer.cornerRadius = _topBaseView.qmui_height/2;
    [_communityButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_WHITE] forState:UIControlStateNormal];
    [_communityButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_THEME] forState:UIControlStateSelected];
    [_communityButton setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    [_communityButton setTitleColor:COLOR_WHITE forState:UIControlStateSelected];


    [_inviteButton addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_resumeButton addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_companyButton addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_communityButton addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];

    
}
- (void)buttonClickEvent:(UIButton *)button{
    
    if (button == _inviteButton) {
        _inviteButton.selected = YES;
        _resumeButton.selected = NO;
        _companyButton.selected = NO;
        _communityButton.selected = NO;

    }else if (button == _resumeButton){
        _inviteButton.selected = NO;
        _resumeButton.selected = YES;
        _companyButton.selected = NO;
        _communityButton.selected = NO;

    }else if (button == _companyButton){
        _inviteButton.selected = NO;
        _resumeButton.selected = NO;
        _companyButton.selected = YES;
        _communityButton.selected = NO;

    }else{
        _inviteButton.selected = NO;
        _resumeButton.selected = NO;
        _companyButton.selected = NO;
        _communityButton.selected = YES;

    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
