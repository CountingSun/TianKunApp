//
//  JumpToAssignVC.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "JumpToAssignVC.h"
#import "JobDetailViewController.h"
#import "FindJodDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "InteractionDetailViewController.h"
#import "InvitationDetailViewController.h"
#import "PlayViewController.h"
#import "EducationDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "EducationDetailViewController.h"
#import "PlayViewController.h"
#import "CooperationDetailViewController.h"
#import "HomePeopleInfoViewController.h"

@implementation JumpToAssignVC
+(void)jumpToAssignVCWithDataID:(NSString *)dataID dataType:(NSInteger)dataType documentType:(NSInteger)documentType{
    //  private Short data_type;//资料(信息)类型: 1岗位信息,2简历信息,3文件通知,4公示公告,5招投标信息,6教育培训,7互动交流,8企业信息(APP发布),9企业信息(WEB发布) 11 商务合作 12 行业资讯
    switch (dataType) {
        case 1:
        {
            JobDetailViewController *viewController = [[JobDetailViewController alloc] initWithJobID:dataID];
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:{
            
            FindJodDetailViewController *viewController = [[FindJodDetailViewController alloc] initWithResumeID:dataID];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 3:{
            
            ArticleDetailViewController *viewController = [[ArticleDetailViewController alloc] initWithArticleID:[dataID integerValue] fromType:1];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4:{
            
            ArticleDetailViewController *viewController = [[ArticleDetailViewController alloc] initWithArticleID:[dataID integerValue] fromType:2];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 5:{
            InvitationDetailViewController *viewController = [[InvitationDetailViewController alloc] initWithInvitationID:[dataID integerValue] fromType:documentType];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];

            
        }
            break;
        case 6:{
            
            if (documentType == 1) {
                EducationDetailViewController *viewController = [[EducationDetailViewController alloc]initWithDocumentID:[dataID integerValue]];
                viewController.hidesBottomBarWhenPushed = YES;
                [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
            }else{
                PlayViewController *viewController = [[PlayViewController alloc]initWithDocumentID:[dataID integerValue]];
                viewController.hidesBottomBarWhenPushed = YES;
                [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
            }
        }
            break;
            
            
        case 7:{
            
            InteractionDetailViewController *viewController = [[InteractionDetailViewController alloc] initWithInteractionID:dataID];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case 8:{
            
            CompanyDetailViewController *viewController = [[CompanyDetailViewController alloc] initWithCompanyID:[dataID integerValue]];
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 9:{
            
            CompanyDetailViewController *viewController = [[CompanyDetailViewController alloc] initWithCompanyID:[dataID integerValue]];
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 10:{
            
            HomePeopleInfoViewController *viewController = [[HomePeopleInfoViewController alloc] initWithPeopleID:[dataID integerValue]];
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
            
        }
            break;

        case 11:{
            
            CooperationDetailViewController *viewController = [[CooperationDetailViewController alloc] initWithcooperationID:[dataID integerValue]];
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];

        }
            break;
        case 12:{
            
            ArticleDetailViewController *viewController = [[ArticleDetailViewController alloc] initWithArticleID:[dataID integerValue] fromType:3];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [[JumpToAssignVC topViewController].navigationController pushViewController:viewController animated:YES];
        }
            break;

        default:
            break;
    }

}
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
