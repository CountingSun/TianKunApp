//
//  XTGuidePagesViewController.m
//  XTGuidePagesView
//
//  Created by zjwang on 16/5/30.
//  Copyright © 2016年 夏天. All rights reserved.
//

#import "XTGuidePagesViewController.h"

#define s_w [UIScreen mainScreen].bounds.size.width
#define s_h [UIScreen mainScreen].bounds.size.height
#define VERSION_INFO_CURRENT @"currentversion"
@interface XTGuidePagesViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic ,strong) UIButton *inButton;
@property (nonatomic ,strong) NSArray *arrImage;
;
@end

@implementation XTGuidePagesViewController

- (void)guidePageControllerWithImages:(NSArray *)images
{
    _arrImage = images;
    UIScrollView *gui = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    gui.delegate = self;
    gui.pagingEnabled = YES;
    // 隐藏滑动条
    gui.showsHorizontalScrollIndicator = NO;
    gui.showsVerticalScrollIndicator = NO;
    // 取消反弹
    gui.bounces = NO;
    for (NSInteger i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:images[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.layer.masksToBounds = YES;
        [gui addSubview:imageView];
        
        
        
        
    }
    gui.contentSize = CGSizeMake(SCREEN_WIDTH * images.count, 0);
    [self.view addSubview:gui];
    
    UIButton *inButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inButton addTarget:self action:@selector(clickEnter) forControlEvents:UIControlEventTouchUpInside];
    [inButton setTitle:@"点击进入" forState:0];
    [inButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    inButton.backgroundColor = COLOR_WHITE;
    inButton.layer.masksToBounds = YES;
    inButton.layer.cornerRadius = 5;
    [self.view addSubview:inButton];
    [inButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(40);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-100);
    }];
    _inButton = inButton;
    _inButton.alpha = 0;


}
- (void)clickEnter
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickEnter)]) {
        [XTGuidePagesViewController saveCurrentVersion];

        [self.delegate clickEnter];
    }
}
+ (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:VERSION_INFO_CURRENT];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        return YES;
    }else
    {
        return NO;
    }
}
// 保存版本信息
+ (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
}
#pragma mark - ScrollerView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    if (index == _arrImage.count-1) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _inButton.alpha = 1;
        }];

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _inButton.alpha = 0;
        }];
        

        
    }
    
}

@end


