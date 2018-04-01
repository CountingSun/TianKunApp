//
//  AddFindJobViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddFindJobViewController.h"
#import "AddinputTextTableViewCell.h"
#import "UIView+AddTapGestureRecognizer.h"
#import "WQUploadSingleImage.h"

@interface AddFindJobViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation AddFindJobViewController
- (void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI{
    self.title = @"编辑简历";

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    _tableView.tableHeaderView = _headView;
    _tableView.tableFooterView = [UIView new];
    [_tableView  registerNib:[UINib nibWithNibName:@"AddinputTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddinputTextTableViewCell"];

    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius =  _headImageView.qmui_width/2;
    _headImageView.userInteractionEnabled = YES;
    [_headImageView addTapGestureRecognizerWithActionBlock:^{
        
        [[WQUploadSingleImage manager] showUpImagePickerWithVC:self compression:0.5 selectSucceedBlock:^(UIImage *image, NSString *filePath) {
            
        }];
    }];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AddinputTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddinputTextTableViewCell" forIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(texeFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.textField.textColor = COLOR_TEXT_LIGHT;
        cell.textField.placeholder = @"请输入简历名称";
        
        cell.titleLabel.text = @"简历名称";
        
        return cell;

    }else{
        static NSString *cellID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.selectionStyle = 0;
            cell.textLabel.textColor = COLOR_TEXT_BLACK;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = COLOR_TEXT_LIGHT;
            cell.detailTextLabel.font =[UIFont systemFontOfSize:13];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"个人信息";
                cell.detailTextLabel.text = @"完整";
                
                break;
            case 2:
                cell.textLabel.text = @"求职意向";
                cell.detailTextLabel.text = @"完整";
                
                break;
            case 3:
                cell.textLabel.text = @"个人介绍";
                cell.detailTextLabel.text = @"完整";
                
                break;

            default:
                break;
        }
        return cell;
        
    }
    
    
}
- (void)texeFieldTextChange:(UITextField *)textField{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
