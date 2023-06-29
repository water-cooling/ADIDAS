//
//  VM_CHECK_ITEM_ViewController.h
//  VM
//
//  Created by leo.you on 14-7-21.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"
#import "VMFilterView.h"

@interface VM_CHECK_ITEM_ViewController : UIViewController<UploadManagementDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITableView* vm_check_item_TableView;
    UploadManagement* uploadManage;
    NSString *countString ;
}

@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) UITableView* vm_check_item_TableView;

@property (strong,nonatomic) NSMutableArray* tableviewSourceArr;
@property (strong,nonatomic) NSMutableArray* historyScoreArr;
@property (assign,nonatomic) NSInteger Four_num;
@property (assign,nonatomic) NSInteger Zero_num;
@property (assign,nonatomic) NSInteger NA_num;
@property (assign,nonatomic) NSInteger TOTAL_num;

@property (assign) NSInteger totalScore;
@property (strong,nonatomic) NSMutableArray* resultPicArr;
@property (strong,nonatomic) NSMutableArray* resultArr;

@property (strong,nonatomic)VMFilterView* filterview;

@property (strong,nonatomic) UIView* waitView;

@end
