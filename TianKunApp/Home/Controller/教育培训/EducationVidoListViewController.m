//
//  EducationVidoListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationVidoListViewController.h"
#import "EducationVidoCollectionViewCell.h"
#import "PlayViewController.h"


@interface EducationVidoListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)  UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@end

@implementation EducationVidoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrData = [NSMutableArray array];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];
    [_arrData addObject:@""];

    self.view.backgroundColor = [UIColor redColor];
    [self.collectionView reloadData];
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/2-1, SCREEN_WIDTH/2-1);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        [_collectionView registerNib:[UINib nibWithNibName:@"EducationVidoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EducationVidoCollectionViewCell"];
        
    }
    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _arrData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EducationVidoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EducationVidoCollectionViewCell" forIndexPath:indexPath];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayViewController *vc = [[PlayViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
