//
//  FileNoticceViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FileNoticceViewController.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "FileNoticceListViewController.h"

@interface FileNoticceViewController ()<FSSegmentTitleViewDelegate,FSPageContentViewDelegate>
@property (nonatomic ,strong) FSSegmentTitleView *segmentTitleView;
@property (nonatomic ,strong) FSPageContentView *pageContentView;
@end

@implementation FileNoticceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"文件通知"];
    [self setupUI];
}
- (void)setupUI{
    NSArray *titlesArr = @[@"全部",@"服饰穿搭",@"生活百货",@"美食吃货",@"美容护理",@"母婴儿童",@"数码家电",@"其他"];
    
    _segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:titlesArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    _segmentTitleView.backgroundColor =COLOR_WHITE;
    
    [self.view addSubview:_segmentTitleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in titlesArr) {
        FileNoticceListViewController *vc = [[FileNoticceListViewController alloc]init];
        vc.title = title;
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
