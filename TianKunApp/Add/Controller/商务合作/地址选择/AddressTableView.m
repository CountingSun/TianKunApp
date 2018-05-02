//
//  AddressTableView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddressTableView.h"
#import "AddressTableViewCell.h"
#import "AddressInfo.h"

@interface AddressTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray *resultArr;
@end

@implementation AddressTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.delegate = self;
    self.dataSource = self;
    self.rowHeight = 45;
    self.tableFooterView = [UIView new];
    [self registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
    if (_isSingSelect) {
        self.allowsMultipleSelection = NO;
    }else{
        self.allowsMultipleSelection = YES;

    }

    
}
- (void)setArrData:(NSMutableArray *)arrData{
    if (_resultArr) {
        [_resultArr removeAllObjects];
    }
    _arrData = arrData;
    [self reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    cell.addressInfo = _arrData[indexPath.row];

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressInfo *addressInfo = self.arrData[indexPath.row];

    if (_isSingSelect) {
        [self.arrData enumerateObjectsUsingBlock:^(AddressInfo *addressInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            addressInfo.isSelect = NO;
            
        }];
        
        addressInfo.isSelect = YES;
        if (_selectSucceedBlock) {
            _selectSucceedBlock([NSMutableArray arrayWithObject:addressInfo]);
            
        }

    }else{
        addressInfo.isSelect =! addressInfo.isSelect;
        if (addressInfo.isSelect) {
            [self.resultArr addObject:addressInfo];
            
        }else{
            [self.resultArr removeObject:addressInfo];
            
        }
        if (_selectSucceedBlock) {
            _selectSucceedBlock(self.resultArr);
            
        }


    }
    [self reloadData];
    
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressInfo *addressInfo = self.arrData[indexPath.row];
    
    if (_isSingSelect) {
        addressInfo.isSelect = NO;
    }
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

}
- (NSMutableArray *)resultArr{
    if (!_resultArr) {
        _resultArr = [NSMutableArray array];
    }
    return _resultArr;
    
}

@end
