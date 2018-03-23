//
//  LoadingView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame loadingText:(NSString *)loadingText{
    if (self = [super initWithFrame:frame]) {
        _loadingText = loadingText;
        self.backgroundColor = COLOR_VIEW_BACK;
        
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];

    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:@"样式" withExtension:@"gif"];
    //获取Gif图的原数据
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifImageUrl, NULL);
    //获取Gif图有多少帧
    size_t gifcount = CGImageSourceGetCount(gifSource);
    for (NSInteger i = 0; i < gifcount; i++) {
        //由数据源gifSource生成一张CGImageRef类型的图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageArr addObject:image];
        CGImageRelease(imageRef);
    }
    

    self.AnimationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 80)];
    
    
    self.AnimationImageView.animationImages = imageArr;
    self.AnimationImageView.animationDuration = 1;
    self.AnimationImageView.animationRepeatCount = 0;
    self.AnimationImageView.center = CGPointMake(self.center.x, self.center.y - 108);

    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(22, CGRectGetMaxY(self.AnimationImageView.frame) , CGRectGetWidth(self.frame) - 44, 30))];
    label.text = _loadingText;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.AnimationImageView];
    [self addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    [self.AnimationImageView startAnimating];


}
@end
