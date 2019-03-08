//
//  MyPointViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPointViewController.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "MyPointListViewController.h"

@interface MyPointViewController ()<FSSegmentTitleViewDelegate,FSPageContentViewDelegate>
@property (nonatomic ,strong) FSSegmentTitleView *segmentTitleView;
@property (nonatomic ,strong) FSPageContentView *pageContentView;

@end

@implementation MyPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"积分明细"];
    [self setupUI];
}
- (void)setupUI{
    NSArray *titlesArr = @[@"全部记录",@"收入记录",@"支出记录"];
    
    _segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:titlesArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    _segmentTitleView.backgroundColor =COLOR_WHITE;
    
    [self.view addSubview:_segmentTitleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    
    
    for (NSString *title in titlesArr) {
        MyPointListViewController *vc = [[MyPointListViewController alloc]initWithViewTitle:title];
        [childVCs addObject:vc];
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, CGRectGetHeight(self.view.bounds) - 40) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_pageContentView];
    
    
}
/**
 切换标题
 
 @param titleView FSSegmentTitleView
 @param startIndex 切换前标题索引
 @param endIndex 切换后标题索引
 */
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    [self.pageContentView setContentViewCurrentIndex:endIndex];
    
}
/**
 FSPageContentView结束滑动
 
 @param contentView FSPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    [self.segmentTitleView setSelectIndex:endIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
