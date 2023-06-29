//
//  PlanViewController.h
//  VM
//
//  Created by wendy on 14-7-14.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanListCell.h"
#import "StoreManagement.h"
#import "StoreEntity.h"
#import "IssueManagement.h"

@interface PlanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StoreManagementDelegate,IssueManagementDelegate>
{
    StoreManagement *_management;
    IssueManagement *_issueManagement;
}

@property (weak,nonatomic) IBOutlet UITableView* planTableView;

@property (weak,nonatomic) IBOutlet UILabel* label;

@property (strong,nonatomic) NSMutableArray* planListArray;

@property (strong,nonatomic) UIRefreshControl* refreshcontrol;

@property (strong,nonatomic) NSMutableArray* eventArray;

@property (strong,nonatomic) StoreManagement* _management;

//-(void)getPlanList;
-(void)RefreshView:(UIRefreshControl*)refresh;
@end
