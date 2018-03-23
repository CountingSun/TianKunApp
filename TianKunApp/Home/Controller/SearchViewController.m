//
//  SearchViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionCell.h"
#import "SearchTableViewCell.h"
#import "UITableView+EmpayData.h"
#import "UICollectionView+EmpayData.h"

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, strong) NSMutableArray *liShiArray;//数据源
@property (nonatomic, strong) NSMutableArray *reSouArray;//数据源
@property (nonatomic ,copy) NSString *filePath;


@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    ///获取文件路径
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _filePath = [doucumentPath stringByAppendingPathComponent:@"QXStoresearch"];
    
    [self getHistoryList];
    
    //Nav搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(35, 0, SCREEN_WIDTH - 100, 44))];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = @"请输入关键词搜索";
    self.searchBar.tintColor = COLOR_THEME;
    [self.searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除Nav搜索框
    [self.searchBar removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_VIEW_BACK;
    
    _liShiArray = [[NSMutableArray alloc] initWithCapacity:0];//历史记录数据源
    _reSouArray = [[NSMutableArray alloc] initWithCapacity:0];//热搜数据源
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    
    self.curPage = 1;//默认当前热搜列表为第一页
    //请求热搜数据列表
    //    [self showWithStatus:@""];
    [self requestListDataArrray];
    [self.collectionView reloadData];
}

#pragma mark - 请求搜索信息
- (void)requestSearchInfo:(NSString *)searchKeyWord {
    
    //    ShaiXuanVC *vc = [[ShaiXuanVC alloc] init];
    //    vc.keyWord = searchKeyWord;
    //    vc.type = @"搜索";
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 换一换
- (void)topRightBtnClick {
    self.curPage ++;
    [self requestListDataArrray];//请求换一批数据
}

#pragma mark - 清除历史记录
- (void)botRightBtnClick {
    
    [self.liShiArray removeAllObjects];
    BOOL result = [NSKeyedArchiver archiveRootObject:self.liShiArray toFile:_filePath];
    if (result) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"保存失败");
    }
    
    
}

#pragma mark - 请求热搜数据列表
- (void)requestListDataArrray {
    
    //    NSString *urlS = [NSString stringWithFormat:@"%@/Api/ProductSearch/List/", Server_Int_Url];
    //    NSMutableDictionary *paraDic = kBaseParaDic;
    //    [paraDic setObject:@(_curPage) forKey:@"Page"];// 第几页
    //    [paraDic setObject:@10 forKey:@"PageSize"];// 每页数量
    //    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
    //
    //
    //        if ([responseObjeck[@"Code"] integerValue] == 0) {
    //            [self.reSouArray removeAllObjects];
    //            NSArray *arr = responseObjeck[@"Data"];
    //            if (arr.count < 6) {
    //                self.curPage = 0;
    //            }
    //            self.reSouArray = [NSMutableArray arrayWithArray:arr];
    //            [self.collectionView reloadData];
    //
    //        } else {
    //            [self showMessage:responseObjeck[@"Msg"]];
    //        }
    //    } failure:^(NSError *error) {
    //
    //        [self showMessage:@"连接不到服务器"];
    //    }];
    
    
    
}

#

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.liShiArray addObject:searchBar.text];
    BOOL result = [NSKeyedArchiver archiveRootObject:self.liShiArray toFile:_filePath];
    if (result) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"保存失败");
    }
    [self requestSearchInfo:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - Table view Datasource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitMsg:@"您还没有进行任何搜索记录哦!" ifNecessaryForRowCount:self.liShiArray.count];
    return self.liShiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = self.liShiArray[indexPath.row];
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchTableViewCell class]) forIndexPath:indexPath];
    cell.titleLab.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    headerView.backgroundColor = COLOR_VIEW_BACK;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.liShiArray[indexPath.row];
    [self requestSearchInfo:str];
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [collectionView collectionViewDisplayWitMsg:@"暂无热搜记录了哦!  试试手动搜索?" ifNecessaryForRowCount:self.reSouArray.count widthDuiQi:1000];
    return self.reSouArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.reSouArray[indexPath.row];
    SearchCollectionCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SearchCollectionCell class]) forIndexPath:indexPath];
    [item setDataDic:dataDic];
    return item;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.reSouArray[indexPath.row];
    
    
    [self requestSearchInfo:dataDic[@"Title"]];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.reSouArray[indexPath.row];
    CGSize itemWidth = [dataDic[@"Title"] boundingRectWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    
    CGFloat width = (SCREEN_WIDTH - 80)/2;
    
    if (itemWidth.width >= width) {
        itemWidth.width = width;
    }
    
    CGSize size = CGSizeMake(itemWidth.width+20, 30);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - collectionView布局
- (UICollectionViewFlowLayout *)getFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //每一行的分割线(——)
    layout.minimumLineSpacing = 10;
    //每一列的分割线（|）
    layout.minimumInteritemSpacing = 10;
    return layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self getFlowLayout]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = COLOR_VIEW_BACK;
        [_collectionView registerClass:[SearchCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([SearchCollectionCell class])];
    }
    return  _collectionView;
}

#pragma mark - 取消回去上级页面
- (void)rightBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///获取历史数据
- (void)getHistoryList {
    [self.liShiArray removeAllObjects];
    NSArray *unarchiverArr = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
    if (unarchiverArr != nil) {
        [self.liShiArray addObjectsFromArray:unarchiverArr];
    } else {
        NSLog(@"没有数");
    }
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

