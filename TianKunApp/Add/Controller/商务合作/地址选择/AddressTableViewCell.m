//
//  AddressTableViewCell.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressInfo.h"


@interface AddressTableViewCell ()
@end
@implementation AddressTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _selectFlag.hidden = NO;
}
- (void)setAddressInfo:(AddressInfo *)addressInfo{
    
    
    _addressLabel.text = addressInfo.addressName;
    
    if (addressInfo.isSelect) {
        _selectFlag.image = [UIImage imageNamed:@"选择框"];
        
    }else{
        _selectFlag.image = [UIImage imageNamed:@"选择-未选"];
    }
    
    
    
}
@end
