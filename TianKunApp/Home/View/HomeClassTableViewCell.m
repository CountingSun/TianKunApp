//
//  HomeClassTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeClassTableViewCell.h"
#import "HomeClassCollectionViewCell.h"
#import "MenuInfo.h"
#import "HomeViewModel.h"

@interface HomeClassTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@end

@implementation HomeClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = self.flowLayout;
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeClassCollectionViewCell"];


    
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
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/5, 70);
        
    }
    return _flowLayout;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];

    if (_delegate) {
        [_delegate didSelectCellWithMenuInfo:menuInfo];
    }
    
}
- (NSMutableArray *)arrMenu{
    if (!_arrMenu) {
        _arrMenu = [HomeViewModel arrMenu];
        
    }
    return _arrMenu;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
