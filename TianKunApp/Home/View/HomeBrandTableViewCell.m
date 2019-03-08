//
//  HomeBrandTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeBrandTableViewCell.h"
#import "HomeBrandCollectionViewCell.h"
#import "CompanyInfo.h"


@interface HomeBrandTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@end

@implementation HomeBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = self.flowLayout;
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeBrandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBrandCollectionViewCell"];
    _collectionView.backgroundColor = COLOR_VIEW_BACK;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrData.count;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBrandCollectionViewCell" forIndexPath:indexPath];
    CompanyInfo *info = self.arrData[indexPath.row];
    [cell.imageView sd_imageDef21WithUrlStr:info.picture_url];
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CompanyInfo *info = self.arrData[indexPath.row];
    if (_collectionViewDidSelectItemBlock) {
        _collectionViewDidSelectItemBlock(info,indexPath);
    }
    

}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 1;
        _flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-2)/3, 40-0.5);
        
    }
    return _flowLayout;
}
- (void)setArrData:(NSMutableArray *)arrData{
    _arrData = arrData;
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
