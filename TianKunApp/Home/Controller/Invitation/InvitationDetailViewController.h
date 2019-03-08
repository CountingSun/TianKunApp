//
//  InvitationDetailViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface InvitationDetailViewController : WQBaseViewController

/**
 <#Description#>

 @param invitationID <#invitationID description#>
 @param fromType 1 招标 2  中标
 @return <#return value description#>
 */
-(instancetype)initWithInvitationID:(NSInteger)invitationID fromType:(NSInteger)fromType;

@property (nonatomic, copy) dispatch_block_t deleteCollectBlock;
@end
