//
//  CooperationSelectAddressView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CooperationSelectAddressView.h"
#import "AddressInfo.h"
#import "AddressView.h"
#import "AddressTableViewCell.h"
#import "UIView+Extension.h"
#import "CitiesDataTool.h"
#import "AddressTableView.h"
static  CGFloat  const  kHYTopViewHeight = 40; //顶部视图的高度
static  CGFloat  const  kHYTopTabbarHeight = 30; //地址标签栏的高度

@interface CooperationSelectAddressView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,weak) AddressView * topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;

@property (nonatomic,strong) NSMutableArray * arrProvince;
@property (nonatomic,strong) NSMutableArray * arrCity;
@property (nonatomic,strong) NSMutableArray * arrCounties;
@property (nonatomic,strong) NSMutableArray * tableViews;
@property (nonatomic,strong) NSMutableArray * arrResult;

@property (nonatomic,strong) AddressTableView * provinceTableView;
@property (nonatomic,strong) AddressTableView * cityTableView;
@property (nonatomic,strong) AddressTableView * countiesTableView;


@property (nonatomic,strong) NSMutableArray * topTabbarItems;
@property (nonatomic,weak) UIButton * selectedBtn;
@property (nonatomic ,strong) CitiesDataTool *citiesDataTool;
@property (nonatomic ,strong) UIView *hiddenView;
@property (nonatomic ,strong) UIButton *sureButton;
@property (nonatomic ,strong) QMUITips *tips;

@property (nonatomic ,strong) AddressInfo *addresInfo;



@end
@implementation CooperationSelectAddressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0);
        [self setUp];
    }
    return self;
}

#pragma mark - setUp UI

- (void)setUp{
    _hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self addSubview:_hiddenView];
    _hiddenView.backgroundColor = UIColorMask;
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:0];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sureButton.backgroundColor = COLOR_THEME;
    [sureButton setTitleColor:[UIColor whiteColor] forState:0];
    sureButton.layer.masksToBounds = YES;
    sureButton.layer.cornerRadius = 5;
    sureButton.frame = CGRectMake(SCREEN_WIDTH-100, 5, 80, kHYTopViewHeight-10);
//    [topView addSubview:sureButton];
    
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.qmui_top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];
    
    
    AddressView * topTabbar = [[[NSBundle mainBundle] loadNibNamed:@"AddressView" owner:nil options:nil] firstObject];
    topTabbar.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), self.frame.size.width, kHYTopViewHeight);
    [topTabbar.firstButton addTarget:self action:@selector(firstButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topTabbar.secondButton addTarget:self action:@selector(secondButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topTabbar.thirdButton addTarget:self action:@selector(thirdButtonClick) forControlEvents:UIControlEventTouchUpInside];
    topTabbar.secondButton.hidden = YES;
    topTabbar.thirdButton.hidden = YES;

    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.qmui_top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 1)];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 1.0f;
    [self changeUnderLineFrameWithIndex:0];
    underLine.qmui_top = separateLine1.qmui_top - underLine.height;
    
    _underLine.backgroundColor = COLOR_THEME;
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kHYTopViewHeight - kHYTopTabbarHeight-74)];
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    _contentView.scrollEnabled = NO;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.delegate = self;
    [_contentView addSubview:self.provinceTableView];
    [_contentView addSubview:self.cityTableView];
    [_contentView addSubview:self.countiesTableView];
    self.provinceTableView.frame = CGRectMake(0*_contentView.qmui_width, 0, _contentView.qmui_width, _contentView.qmui_height);
    self.cityTableView.frame = CGRectMake(1*_contentView.qmui_width, 0, _contentView.qmui_width, _contentView.qmui_height);
    self.countiesTableView.frame = CGRectMake(2*_contentView.qmui_width, 0, _contentView.qmui_width, _contentView.qmui_height);

    [self getProvinces];
    
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    tapBack.delegate = self;
    [_hiddenView addGestureRecognizer:tapBack];
    
    

}
- (void)sureButtonClick{
    if (_arrResult.count) {
        if (_selectSucceed) {
            _selectSucceed(_arrResult);
            [self removeView];
            
        }
        
    }else{
        [QMUITips showError:@"请选择区域" inView:self hideAfterDelay:2];
        
    }
    
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//    if ([gestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
//        return NO;
//    }
//    return YES;
//}

- (void)removeView{
    self.hidden = YES;
}
- (void)firstButtonClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(0 * SCREEN_WIDTH, 0);

        [self changeUnderLineFrameWithIndex:0];
    }];

}
- (void)secondButtonClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(1 * SCREEN_WIDTH, 0);
        [self changeUnderLineFrameWithIndex:1];
    }];

}
- (void)thirdButtonClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(2 * SCREEN_WIDTH, 0);
        [self changeUnderLineFrameWithIndex:2];
    }];

}


//调整指示条位置
- (void)changeUnderLineFrameWithIndex:(NSInteger)index{
    [UIView animateWithDuration:0.5 animations:^{
        self.underLine.qmui_left = SCREEN_WIDTH/3*index;
        
    }];

}
- (void)getProvinces{
    _tips = [QMUITips showLoading:@"请稍候" detailText:@"" inView:self];
    self.userInteractionEnabled = NO;
    [self.citiesDataTool getAllProvinceWithBlock:^(NSInteger code, NSMutableArray *arrData) {
        [_tips hideAnimated:YES];

        if (code == 1) {
            self.userInteractionEnabled = YES;

            _arrProvince = arrData;
            self.provinceTableView.arrData = _arrProvince;
        }else{
            self.userInteractionEnabled = YES;
            [QMUITips showError:NET_ERROR_TOST inView:self hideAfterDelay:2];
        }
    }];
    
}

#pragma mark - <UIScrollView>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView != self.contentView) return;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [weakSelf changeUnderLineFrameWithIndex:index];
    }];
}



#pragma mark - getter 方法

//分割线
- (UIView *)separateLine{
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return separateLine;
}

- (NSMutableArray *)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}


- (CitiesDataTool *)citiesDataTool{
    if (!_citiesDataTool) {
        _citiesDataTool = [[CitiesDataTool alloc]init];
    }
    return _citiesDataTool;
    
}
- (AddressTableView *)provinceTableView{
    if (!_provinceTableView) {
        _provinceTableView = [[AddressTableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _provinceTableView.isSingSelect = YES;
        
        __weak typeof(self) weakSelf = self;

        _provinceTableView.selectSucceedBlock = ^(NSMutableArray *arrResult) {
            AddressInfo *provinceInfo = arrResult[0];
            weakSelf.addresInfo.provinceName = provinceInfo.addressName;
            weakSelf.addresInfo.provinceID = provinceInfo.addressID;

            [weakSelf.topTabbar.firstButton setTitle:provinceInfo.addressName forState:0];
            weakSelf.topTabbar.secondButton.hidden = YES;
            weakSelf.topTabbar.thirdButton.hidden = YES;
            _tips = [QMUITips showLoading:@"请稍候" detailText:@"" inView:self];
            weakSelf.userInteractionEnabled = NO;
            
            [weakSelf.citiesDataTool getCityWithProvinceID:provinceInfo.addressID getAddressBlock:^(NSInteger code, NSMutableArray *arrData) {
                if (code == 1) {
                    [weakSelf.tips hideAnimated:YES];
                    weakSelf.userInteractionEnabled = YES;
                    [weakSelf changeUnderLineFrameWithIndex:1];
                    weakSelf.topTabbar.secondButton.hidden = NO;
                    [weakSelf.topTabbar.secondButton setTitle:@"请选择" forState:0];
                    weakSelf.arrCity = arrData;
                    weakSelf.cityTableView.arrData = weakSelf.arrCity;
                    [weakSelf.contentView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
                }else{
                    [QMUITips showError:NET_ERROR_TOST inView:weakSelf hideAfterDelay:2];
                    weakSelf.userInteractionEnabled = YES;

                }
            }];
            
            
        };

    }
    
    return _provinceTableView;
}

- (AddressTableView *)cityTableView{
    if (!_cityTableView) {
        _cityTableView = [[AddressTableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _cityTableView.isSingSelect = YES;
        
        __weak typeof(self) weakSelf = self;

        _cityTableView.selectSucceedBlock = ^(NSMutableArray *arrResult) {
            AddressInfo *addressInfo = arrResult[0];
            weakSelf.addresInfo.cityID = addressInfo.addressID;
            weakSelf.addresInfo.cityName = addressInfo.addressName;

            [weakSelf.topTabbar.secondButton setTitle:addressInfo.addressName forState:0];
            _tips = [QMUITips showLoading:@"请稍候" detailText:@"" inView:self];
            weakSelf.userInteractionEnabled = NO;

            [weakSelf.citiesDataTool getCountiesWithCityID:addressInfo.addressID getAddressBlock:^(NSInteger code, NSMutableArray *arrData) {
                if (code == 1) {
                    [weakSelf.tips hideAnimated:YES];
                    weakSelf.userInteractionEnabled = YES;

                    weakSelf.topTabbar.thirdButton.hidden = NO;
                    [weakSelf.topTabbar.thirdButton setTitle:@"县、区" forState:0];

                    weakSelf.arrCounties = arrData;
                    [weakSelf changeUnderLineFrameWithIndex:2];
                    weakSelf.countiesTableView.arrData = weakSelf.arrCounties;
                    [weakSelf.contentView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];

                }else{
                    [QMUITips showError:NET_ERROR_TOST inView:weakSelf hideAfterDelay:2];
                    weakSelf.userInteractionEnabled = YES;

                }

            }];
            

        };

    }
    return _cityTableView;

}

- (AddressTableView *)countiesTableView{
    if (!_countiesTableView) {

        _countiesTableView = [[AddressTableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _countiesTableView.isSingSelect = YES;
        __weak typeof(self) weakSelf = self;

        _countiesTableView.selectSucceedBlock = ^(NSMutableArray *arrResult) {
            for (AddressInfo *resultAddress in arrResult) {
                AddressInfo *returnAddress = [[AddressInfo alloc] init];
                returnAddress.provinceID = weakSelf.addresInfo.provinceID;
                returnAddress.provinceName = weakSelf.addresInfo.provinceName;
                returnAddress.cityID = weakSelf.addresInfo.cityID;
                returnAddress.cityName = weakSelf.addresInfo.cityName;
                returnAddress.countiesName = resultAddress.addressName;
                returnAddress.countiesID = resultAddress.addressID;
                [weakSelf.arrResult addObject:returnAddress];
            }
            [weakSelf sureButtonClick];
            
        };

    }
    return _countiesTableView;
    
}
- (AddressInfo *)addresInfo{
    if (!_addresInfo) {
        _addresInfo = [[AddressInfo alloc] init];
        
    }
    return _addresInfo;
    
}
- (NSMutableArray *)arrResult{
    if (!_arrResult) {
        _arrResult = [NSMutableArray array];
    }
    return _arrResult;
}





@end
