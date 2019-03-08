//
//  InteractionViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "InteractionViewController.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "InteractionListViewController.h"
#import "ClassTypeInfo.h"
#import "IQKeyboardManager.h"

@interface InteractionViewController ()<FSSegmentTitleViewDelegate,FSPageContentViewDelegate>
@property (nonatomic ,strong) FSSegmentTitleView *segmentTitleView;
@property (nonatomic ,strong) FSPageContentView *pageContentView;
@property (nonatomic ,strong) NSMutableArray *arrClass;

@end

@implementation InteractionViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"互动交流"];
    [self getClass];
    [self showLoadingView];
    
}
- (void)getClass{
    [[[NetWorkEngine alloc]init] getWithUrl:BaseUrl(@"find.forum.type.ancestor") succed:^(id responseObject) {
        [self hideLoadingView];
        if(!_arrClass){
            _arrClass = [NSMutableArray array];
            
        }
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1){
            
            NSMutableArray *arrClass = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            for(NSDictionary *dict in arrClass){
                ClassTypeInfo *info = [ClassTypeInfo mj_objectWithKeyValues:dict];
                [_arrClass addObject:info];
            }
            [self setupUI];
            
        }else{
            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getClass];
            }];
            
        }
        
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getClass];
        }];
        
    }];
    
    
}

- (void)setupUI{
    NSMutableArray *titlesArr = [NSMutableArray arrayWithCapacity:_arrClass.count];
    [_arrClass enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ClassTypeInfo *info = obj;
        [titlesArr addObject:info.typeName];
        
        
    }];

    _segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:titlesArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    _segmentTitleView.backgroundColor =COLOR_WHITE;
    
    [self.view addSubview:_segmentTitleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    [_arrClass enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ClassTypeInfo *info = obj;
        InteractionListViewController *vc = [[InteractionListViewController alloc]initWithClassID:info.typeID                                       ];
        [childVCs addObject:vc];

        
    }];

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
