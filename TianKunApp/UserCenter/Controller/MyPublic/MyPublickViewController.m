//
//  MyPublickViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublickViewController.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "FindJodDetailViewController.h"
#import "MyPublicFindTalentViewController.h"
#import "CompanyDetailViewController.h"
#import "MyPublicInteractiveViewController.h"
#import "MyPublicCooperationViewController.h"
#import "MyPublicResumeViewController.h"
#import "MyPublicCompanyViewController.h"

@interface MyPublickViewController ()<FSSegmentTitleViewDelegate,FSPageContentViewDelegate>
@property (nonatomic ,strong) QMUIButton *editButton;
@property (nonatomic ,strong) FSSegmentTitleView *segmentTitleView;
@property (nonatomic ,strong) FSPageContentView *pageContentView;
@property (nonatomic ,assign) NSInteger currectIndex;
@property (nonatomic ,strong) NSMutableArray *arrChildController;

@end

@implementation MyPublickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"我的发布"];
    [self setupView];
    
}
- (void)setupView{
    
    _editButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_editButton setImage:[UIImage imageNamed:@"user_center_edit"] forState:0];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _editButton.hidden = YES;
    [_editButton addTarget:self action:@selector(editButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [view addSubview:_editButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    

    NSArray *titlesArr = @[@"招聘信息",@"我的简历",@"企业信息",@"互动交流",@"商务合作"];
    
    _segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:titlesArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    _segmentTitleView.backgroundColor =COLOR_WHITE;
    _segmentTitleView.titleSelectColor = COLOR_THEME;
    _segmentTitleView.indicatorColor = COLOR_THEME;
    
    [self.view addSubview:_segmentTitleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    MyPublicFindTalentViewController *findTalentViewController = [[MyPublicFindTalentViewController alloc] init];
    [childVCs addObject:findTalentViewController];
    
    MyPublicResumeViewController *findJodDetailViewController = [[MyPublicResumeViewController alloc] init];
    [childVCs addObject:findJodDetailViewController];
    
    MyPublicCompanyViewController *companyDetailViewController = [[MyPublicCompanyViewController alloc] init];
    [childVCs addObject:companyDetailViewController];
    
    MyPublicInteractiveViewController *interactiveViewController = [[MyPublicInteractiveViewController alloc] init];
    [childVCs addObject:interactiveViewController];
    
    MyPublicCooperationViewController *cooperationViewController = [[MyPublicCooperationViewController alloc] init];
    [childVCs addObject:cooperationViewController];


    for (NSInteger i = 0;i<titlesArr.count;i++) {
//        CollectionListViewController *vc = [[CollectionListViewController alloc]initWithViewType:i];
//        [childVCs addObject:vc];
    }
    _arrChildController = childVCs;
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_pageContentView];
    
    
}
-(void)editButtonEvent{
    if (_currectIndex == 1) {
        MyPublicResumeViewController *findJodDetailViewController = _arrChildController[1];
        [findJodDetailViewController clickEditButton];
        
    }else if(_currectIndex == 2){
        MyPublicCompanyViewController *companyDetailViewController = _arrChildController[2];
        [companyDetailViewController clickEditButton];

    }

}
/**
 切换标题
 
 @param titleView FSSegmentTitleView
 @param startIndex 切换前标题索引
 @param endIndex 切换后标题索引
 */
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    [self.pageContentView setContentViewCurrentIndex:endIndex];
    _currectIndex = endIndex;
    if (endIndex == 1||endIndex == 2) {
        _editButton.hidden = NO;
    }else{
        _editButton.hidden = YES;
    }

}
/**
 FSPageContentView结束滑动
 
 @param contentView FSPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    [self.segmentTitleView setSelectIndex:endIndex];
    
    if (endIndex == 1||endIndex == 2) {
        _editButton.hidden = NO;
    }else{
        _editButton.hidden = YES;
    }
    _currectIndex = endIndex;
    
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
