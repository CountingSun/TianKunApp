//
//  AgreementPreviewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AgreementPreviewController.h"

@interface AgreementPreviewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@end

@implementation AgreementPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    if (IOS_VERSION>10) {
        [NSTimer scheduledTimerWithTimeInterval:0.01
         
                                         target:self
         
                                       selector:@selector(hideRightButton)
         
                                       userInfo:nil
         
                                        repeats:YES];

    }
    

}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
//    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.toolbar.hidden = YES;
    
    // custom view demonstrate
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    topView.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:topView];

}
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController*)controller
{
    return 1; //需要显示的文件的个数
}

-(id<QLPreviewItem>)previewController:(QLPreviewController*)controller previewItemAtIndex:(NSInteger)index

{
    
    //返回要打开文件的地址，包括网络或者本地的地址
    NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"建筑一秘用户服务协议" ofType:@"docx"];

    NSURL * url =[NSURL fileURLWithPath:pdfPath];
    
    return url;
    
}
- (void)hideRightButton{
    
    [[self navigationItem] setRightBarButtonItem:nil animated:NO];
    
}


#pragma mark - previewControllerDelegate



-(CGRect)previewController:(QLPreviewController*)controller frameForPreviewItem:(id<QLPreviewItem>)iteminSourceView:(UIView *)view

{
    
    //提供变焦的开始rect，扩展到全屏
    
    return  CGRectMake(0, 0, SCREEN_WIDTH, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
