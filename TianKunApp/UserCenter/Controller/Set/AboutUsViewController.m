//
//  AboutUsViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIView+AddTapGestureRecognizer.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIView *callView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"关于我们"];
    [_callView addTapGestureRecognizerWithActionBlock:^{
        [self callWithTel:@"4008601333"];
    }];
    
}
- (void)callWithTel:(NSString *)tel{
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", tel];
    
    NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
    
    if (compare == NSOrderedDescending || compare == NSOrderedSame) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        
    }}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
