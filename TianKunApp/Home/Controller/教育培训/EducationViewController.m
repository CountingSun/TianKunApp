//
//  EducationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationViewController.h"
#import "EducationTableViewCell.h"
#import "HomeClassCollectionViewCell.h"
#import "MenuInfo.h"
#import "HomeViewModel.h"

#import "EducationDetailViewController.h"
#import "EducationMeansViewController.h"

@interface EducationViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,strong) NSMutableArray *arrMenu;

@end

@implementation EducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"教育信息"];
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:0];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];

    }
    [self.tableView registerNib:[UINib nibWithNibName:@"EducationTableViewCell" bundle:nil] forCellReuseIdentifier:@"EducationTableViewCell"];
    self.tableView.tableHeaderView = self.headView;
    [self setCollectionView];

}
#pragma mark collectionview

- (void)setCollectionView{
    _collectionView.collectionViewLayout = self.flowLayout;

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeClassCollectionViewCell"];
    [_pageControl setNumberOfPages:(self.arrMenu.count-1)/3 +1];
    _pageControl.hidden = YES;
    
    [self.collectionView reloadData];
    

    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrMenu.count;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeClassCollectionViewCell" forIndexPath:indexPath];
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];
    cell.label.text = menuInfo.menuName;
    cell.imageView.image = [UIImage imageNamed:menuInfo.menuIcon];
    return cell;
    
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3, 100);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
    }
    return _flowLayout;
}

- (NSMutableArray *)arrMenu{
    if (!_arrMenu) {
        _arrMenu = [HomeViewModel arrMenu];
        
    }
    return _arrMenu;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EducationMeansViewController *vc = [[EducationMeansViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _collectionView) {

        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        [_pageControl setCurrentPage:index];


    }
}
#pragma mark - tableview
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120;
        _tableView.separatorStyle = 0;
        
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [_tableView headerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView endRefresh];
                
            });
            
        }];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationDetailViewController *vc = [[EducationDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

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
