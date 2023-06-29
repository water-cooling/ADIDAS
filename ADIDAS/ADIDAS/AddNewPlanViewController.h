//
//  AddNewPlanViewController.h
//  VM
//
//  Created by leo.you on 14-7-28.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManagement.h"

@class PlanDetailViewController;

@interface AddNewPlanViewController : UIViewController<UITableViewDelegate,
UITableViewDataSource,UITextFieldDelegate,StoreManagementDelegate,UISearchBarDelegate>
{
    StoreManagement *_management;
    NSMutableArray * _storeList;
    UITextField * storeCodeField;
}

@property (weak, nonatomic) IBOutlet UITableView *storeListView;
@property (weak,nonatomic) IBOutlet UISearchBar* searchbar;
@property (nonatomic, strong) NSMutableArray * storeList;
//@property (nonatomic,strong) NSMutableArray* existStoreList;
@property (strong,nonatomic) UIRefreshControl* refreshcontrol;
@property (weak,nonatomic) PlanDetailViewController* superViewController;

@end
