//
//  ConstructionSearchSelectTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ConstructionSearchSelectTableViewCell.h"
#import "ConstructionSearchCollectionViewCell.h"
#import "AptitudeSelectViewController.h"
#import "ClassTypeInfo.h"

#define itemHeight 40
#define MinLineSpacing 10
#define MinInteritemSpacing 10


@interface ConstructionSearchSelectTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>
@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,strong) AptitudeSelectViewController *aptitudeSelectViewController;
@property (nonatomic ,strong) NSIndexPath *currectIndexPath;
@end


@implementation ConstructionSearchSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _collectionView.collectionViewLayout = self.flowLayout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    _collectionView.indexDisplayMode = UIScrollViewIndexDisplayModeAutomatic;
    [_collectionView registerNib:[UINib nibWithNibName:@"ConstructionSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ConstructionSearchCollectionViewCell"];

}
- (void)setArrData:(NSMutableArray *)arrData{
    
        CGFloat height = ((arrData.count-1)/2+1 ) * itemHeight + (arrData.count-1)/2*10;
        
        if (_reloadHeightBlock) {
            _reloadHeightBlock();
        }
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(5);
            make.right.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(10);
            make.height.offset(height+1);
            
        }];

    _arrData = arrData;
    
    [self.collectionView reloadData];
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        
    }
    return _flowLayout;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((_collectionView.qmui_width-10)/2, 40);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrData.count;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConstructionSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ConstructionSearchCollectionViewCell" forIndexPath:indexPath];
    NSMutableArray *arr = self.arrData[indexPath.row];
    [arr enumerateObjectsUsingBlock:^(ClassTypeInfo *classTypeInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        if (classTypeInfo.isSelect) {
            cell.titleLabel.text = classTypeInfo.typeName;

            *stop = YES;
        }else{
            cell.titleLabel.text = @"请选择";
        }

    }];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 3;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = COLOR_VIEW_SEGMENTATION.CGColor;
    
    cell.statueImageView.image = [UIImage imageNamed:@"三角上"];
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _currectIndexPath = indexPath;
    
    ConstructionSearchCollectionViewCell *cell = (ConstructionSearchCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.statueImageView.image = [UIImage imageNamed:@"三角下"];

    if (!_aptitudeSelectViewController) {
        _aptitudeSelectViewController = [[AptitudeSelectViewController alloc]initWithSelectSucceedBlock:^(ClassTypeInfo *classTypeInfo,NSIndexPath *indexPaths) {
            
            ConstructionSearchCollectionViewCell *cell = (ConstructionSearchCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPaths];
            cell.titleLabel.text = classTypeInfo.typeName;
            cell.statueImageView.image = [UIImage imageNamed:@"三角上"];
            classTypeInfo.isSelect = YES;

            if (_delegate) {
                [_delegate selectWithClassTypeInfo:classTypeInfo index:indexPaths.row];
            }
        }];

    }
    _aptitudeSelectViewController.modalPresentationStyle = UIModalPresentationPopover;

    _aptitudeSelectViewController.preferredContentSize = CGSizeMake(cell.frame.size.width, 200);
    // 需要通过 sourceView 来判断位置的
    _aptitudeSelectViewController.popoverPresentationController.sourceView = cell;
    // 指定箭头所指区域的矩形框范围（位置和尺寸）,以sourceView的左上角为坐标原点
    // 这个可以 通过 Point 或  Size 调试位置
    _aptitudeSelectViewController.popoverPresentationController.sourceRect = cell.bounds;
    // 箭头方向
    _aptitudeSelectViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    // 设置代理
    _aptitudeSelectViewController.popoverPresentationController.delegate = self;
    NSMutableArray *arr = self.arrData[indexPath.row];
    [arr enumerateObjectsUsingBlock:^(ClassTypeInfo *classTypeInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        classTypeInfo.isSelect = NO;
    }];
    
    _aptitudeSelectViewController.arrData = self.arrData[indexPath.row];
    _aptitudeSelectViewController.indexPath = indexPath; 
    [[ConstructionSearchSelectTableViewCell topViewController] presentViewController:_aptitudeSelectViewController animated:YES completion:nil];

    
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone; //不适配
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    ConstructionSearchCollectionViewCell *cell = (ConstructionSearchCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:_currectIndexPath];
    cell.statueImageView.image = [UIImage imageNamed:@"三角上"];

    return YES;   //点击蒙版popover消失， 默认YES
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+(CGFloat)getCellHeightWithArr:(NSMutableArray *)arr{
    CGFloat height = ((arr.count-1)/2+1 ) * itemHeight + (arr.count-1)/2*10;
    return height+20;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
