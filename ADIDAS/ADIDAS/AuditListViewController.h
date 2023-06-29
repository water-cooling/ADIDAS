//
//  AuditListViewController.h
//  VM
//
//  Created by leo.you on 14-7-21.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"
#import "VMFilterView.h"

@interface AuditListViewController : UIViewController<UploadManagementDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITableView* vm_check_item_TableView;
    UploadManagement* uploadManage;
    NSArray *totalScoreArray;
    BOOL finish;
}

@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) UITableView* vm_check_item_TableView;
@property (strong,nonatomic) NSMutableArray* tableviewSourceArr;
@property (strong,nonatomic) NSMutableArray* resultPicArr;
@property (strong,nonatomic) NSMutableArray* resultArr;
@property (strong,nonatomic) UIView* waitView;

@end
