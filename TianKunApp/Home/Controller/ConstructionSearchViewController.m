//
//  ConstructionSearchViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ConstructionSearchViewController.h"
#import "ConstructionSearchTableViewCell.h"
#import "ConstructionSearchSelectTableViewCell.h"
#import "ConstructionSearchTextTableViewCell.h"
#import "AptitudeSelectViewController.h"
#import "ClassTypeInfo.h"

@interface ConstructionSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,ConstructionSearchSelectDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NSMutableArray *arrAllAptitude;

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) UITextField *protertyTextField;
@property (nonatomic ,strong) UITextField *addressTextField;

@property (nonatomic ,strong) NSIndexPath *currectIndexPath;



@end

@implementation ConstructionSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleView setTintColor:[UIColor blackColor]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"筛选"];
    
    _arrData = [NSMutableArray array];

    
    [self setupUI];
    [self showLoadingView];
    
    [self getAptitude];
    
}
- (void)setupUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ConstructionSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConstructionSearchTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ConstructionSearchSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConstructionSearchSelectTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ConstructionSearchTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConstructionSearchTextTableViewCell"];
    _tableView.tableFooterView = [UIView new];
    
    QMUIButton *saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [saveButton setTitle:@"确定" forState:0];
    [saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];

}

- (void)getAptitude{
    [self.netWorkEngine getWithUrl:BaseUrl(@"find.certificate.type.ancestor") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            
            NSMutableArray *arrProperty = [NSMutableArray array];
            if (!_arrAllAptitude) {
                _arrAllAptitude = [NSMutableArray array];
                
            }
            [_arrAllAptitude removeAllObjects];

            for (NSDictionary *dict in arr) {
                ClassTypeInfo *classTypeInfo = [ClassTypeInfo mj_objectWithKeyValues:dict];
                [arrProperty addObject:classTypeInfo];
                ClassTypeInfo *classTypeInfoList = [ClassTypeInfo mj_objectWithKeyValues:dict];
                [_arrAllAptitude addObject:classTypeInfoList];

            }
            [_arrData addObject:arrProperty];

            [self.tableView reloadData];
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];

        }
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showErrorWithStatus:NET_ERROR_TOST];
        

    }];
    
    
}
- (void)seve{
    ClassTypeInfo *info = _arrAllAptitude[_currectIndexPath.row];

    if (_sureButtonClickBlock) {
        _sureButtonClickBlock(_addressTextField.text,info.typeID);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)getAptitudeDetailWithTypeID:(NSString *)typeID{

    QMUITips *tips = [QMUITips showLoadingInView:self.view];
    
    [self.netWorkEngine postWithDict:@{@"id":typeID} url:BaseUrl(@"find.certifications.name.all") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [tips hideAnimated:YES];
        self.view.userInteractionEnabled = YES;

        if (code == 1) {
            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            if (!_arrAllAptitude) {
                _arrAllAptitude = [NSMutableArray array];

            }
            if ([[responseObject objectForKey:@"value"] isKindOfClass:[NSString class]]) {
                [self.tableView reloadData];
            }else{
                NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
                
                if (arr.count) {
                    [_arrAllAptitude removeAllObjects];

                    NSMutableArray *arrProperty = [NSMutableArray array];
                    
                    for (NSDictionary *dict in arr) {
                        ClassTypeInfo *classTypeInfo = [ClassTypeInfo mj_objectWithKeyValues:dict];
                        [arrProperty addObject:classTypeInfo];
                        
                        ClassTypeInfo *classTypeList = [ClassTypeInfo mj_objectWithKeyValues:dict];
                        [_arrAllAptitude addObject:classTypeList];
                        
                    }
                    [_arrData addObject:arrProperty];
                    [self.tableView reloadData];
                    
                }

            }
            
        }else{
            
        }
    } errorBlock:^(NSError *error) {
        [tips hideAnimated:YES];
        self.view.userInteractionEnabled = YES;
//        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    return _arrAllAptitude.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        return  [ConstructionSearchSelectTableViewCell getCellHeightWithArr:self.arrData];
        
    }else{
        return 45;
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ConstructionSearchTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConstructionSearchTextTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"资质名称：";
            cell.textField.placeholder = @"请选择资质名称";
            _protertyTextField = cell.textField;
            cell.textField.enabled = NO;
            
            
        }else{
            cell.titleLabel.text = @"企业注册属地：";
            cell.textField.placeholder = @"请输入注册属地";
            _addressTextField = cell.textField;
            cell.textField.enabled = YES;
        }
        return cell;
    }else if (indexPath.section == 1){
        ConstructionSearchSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConstructionSearchSelectTableViewCell" forIndexPath:indexPath];
        cell.arrData = _arrData;
        cell.delegate = self;
        return cell;

    }else{
        ConstructionSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConstructionSearchTableViewCell" forIndexPath:indexPath];
        ClassTypeInfo *info = _arrAllAptitude[indexPath.row];
        cell.titleLabel.text = info.typeName;
        return cell;

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        ClassTypeInfo *info = _arrAllAptitude[indexPath.row];

        ConstructionSearchTableViewCell *cell = (ConstructionSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"选择框"];
        _protertyTextField.text = info.typeName;
        _currectIndexPath = indexPath;
        
    }else{
        [tableView selectRowAtIndexPath:_currectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        ConstructionSearchTableViewCell *cell = (ConstructionSearchTableViewCell *)[tableView cellForRowAtIndexPath:_currectIndexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"选择框"];

        
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        ConstructionSearchTableViewCell *cell = (ConstructionSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"选择-未选"];
    }

}
- (void)selectWithClassTypeInfo:(ClassTypeInfo *)classTypeInfo index:(NSInteger)index{
    self.view.userInteractionEnabled = NO;
    
    ConstructionSearchTableViewCell *cell = (ConstructionSearchTableViewCell *)[self.tableView cellForRowAtIndexPath:_currectIndexPath];
    cell.iconImageView.image = [UIImage imageNamed:@"选择-未选"];

    [self dealArrDataWithIndex:index];
    [self.tableView reloadData];
    [self getAptitudeDetailWithTypeID:classTypeInfo.typeID];
    
}
- (void)dealArrDataWithIndex:(NSInteger)index{
    
    if (_arrData.count == index+1) {
        
    }else{
        [_arrData removeLastObject];
        [self dealArrDataWithIndex:index];
    }
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}
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
