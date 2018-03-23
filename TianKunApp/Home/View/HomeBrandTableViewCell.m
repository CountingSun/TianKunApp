//
//  HomeBrandTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeBrandTableViewCell.h"
#import "HomeBrandCollectionViewCell.h"

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
    return 6;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBrandCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522132646&di=4353633ae497bc82e1e3586a187e0758&imgtype=jpg&er=1&src=http%3A%2F%2Fs2.sinaimg.cn%2Fmw690%2F00348Lt3zy6QnS8eP9n21%26amp%3B690"] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_21]];
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 1;
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3-2, 40-1);
        
    }
    return _flowLayout;
}

- (NSMutableArray *)arrMenu{
    if (!_arrMenu) {
        _arrMenu = [NSMutableArray array];
        
    }
    return _arrMenu;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
