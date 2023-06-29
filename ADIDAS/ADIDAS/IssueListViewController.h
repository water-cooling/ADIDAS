//
//  IssueListViewController.h
//  VM
//
//  Created by leo.you on 14-7-21.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"
#import "TakePhotoListCell.h"
#import "UIImage+resize.h"

@interface IssueListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UploadManagementDelegate,UIAlertViewDelegate,installcellDelegate>
{
    UITableView* Issue_list_TableView;
    UploadManagement* uploadManage;
}

@property (strong,nonatomic) UITableView* Issue_list_TableView;
@property (strong,nonatomic) UploadManagement* uploadManage;

@property (strong,nonatomic) NSMutableArray* issueListArr;
@property (strong,nonatomic) NSMutableArray* originissueListArr;

@property (strong,nonatomic) NSMutableArray* resultPicArr;
@property (strong,nonatomic) NSMutableArray* resultPicNameArr;
@property (strong,nonatomic) NSMutableArray* resultArr;
@property (strong,nonatomic) NSMutableArray* zone_codeArr;

@property (strong) NSIndexPath* refreshIndexPath;

@property (assign) NSInteger originIndex;
@property (assign) NSInteger insertIndex;
@property (strong,nonatomic) NVM_ISSUE_PHOTO_ZONE_Entity* currentEntity_1;
@property (strong,nonatomic) NVM_ISSUE_PHOTO_ZONE_Entity* currentEntity_2;
@property (strong,nonatomic) NVM_ISSUE_PHOTO_ZONE_Entity* currentEntity_3;
@property (strong,nonatomic) NVM_ISSUE_PHOTO_ZONE_Entity* currentEntity_4;
@property (strong,nonatomic) NVM_ISSUE_PHOTO_ZONE_Entity* currentEntity_5;

@property (strong,nonatomic) UIView* waitView;

@end
