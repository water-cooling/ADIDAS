//
//  StoreListViewController.h
//  ADIDAS
//
//  Created by testing on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManagement.h"
#import "StoreEntity.h"
#import <AMapLocationKit/AMapLocationManager.h>

@interface StoreListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,StoreManagementDelegate,UISearchBarDelegate,AMapLocationManagerDelegate>
{
    StoreManagement *_management;
    NSMutableArray * _storeList;
    UITextField * storeCodeField;
}

@property (retain, nonatomic) IBOutlet UITableView *storeListView;
@property (retain,nonatomic) IBOutlet UISearchBar* searchbar;
@property (nonatomic, retain) NSMutableArray * storeList;
@property (retain,nonatomic) UIRefreshControl* refreshcontrol;
@property (strong, nonatomic) AMapLocationManager *locationManager ;


-(void)UpdateWorkMain:(StoreEntity*) entity;


@end
