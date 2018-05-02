//
//  CollectionViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionListViewController.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"

@interface CollectionViewController ()<FSSegmentTitleViewDelegate,FSPageContentViewDelegate>
@property (nonatomic ,strong) QMUIButton *editButton;
@property (nonatomic ,strong) FSSegmentTitleView *segmentTitleView;
@property (nonatomic ,strong) FSPageContentView *pageContentView;
@property (nonatomic ,assign) NSInteger currectIndex;
@property (nonatomic ,strong) NSMutableArray *arrChildController;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"我的收藏"];
    [self setupUI];
}
- (void)setupUI{
    
    _editButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_editButton setImage:[UIImage imageNamed:@"删除"] forState:0];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_editButton addTarget:self action:@selector(editButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_editButton];

    NSArray *titlesArr = @[@"文件通知",@"公示公告",@"企业招聘",@"人才求职",@"互动交流",@"教育培训",@"企业收藏"];
    
    _segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:titlesArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    _segmentTitleView.backgroundColor =COLOR_WHITE;
    _segmentTitleView.titleSelectColor = COLOR_THEME;
    _segmentTitleView.indicatorColor = COLOR_THEME;

    [self.view addSubview:_segmentTitleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSInteger i = 0;i<titlesArr.count;i++) {
        CollectionListViewController *vc = [[CollectionListViewController alloc]initWithViewType:i];
        [childVCs addObject:vc];
    }
    _arrChildController = childVCs;
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_pageContentView];
    
    
}
- (void)editButtonEvent{
    self.pageContentView.contentViewCanScroll = NO;
    CollectionListViewController *vc = _arrChildController[_currectIndex];
    [vc beginEditWithEditButton:_editButton FinishBlock:^{
        self.pageContentView.contentViewCanScroll = YES;
    }];
    
    
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
    
}
/**
 FSPageContentView结束滑动
 
 @param contentView FSPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    [self.segmentTitleView setSelectIndex:endIndex];
    _currectIndex = endIndex;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
