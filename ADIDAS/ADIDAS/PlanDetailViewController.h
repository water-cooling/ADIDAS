//
//  PlanDetailViewController.h
//  VM
//
//  Created by leo.you on 14-7-28.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanEntity.h"

@class PlanViewController;

@interface PlanDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak,nonatomic) IBOutlet UILabel* monthlabel;
@property (weak,nonatomic) IBOutlet UILabel* daylabel;
@property (weak,nonatomic) IBOutlet UILabel* eventlabel;
@property (weak,nonatomic) IBOutlet UIButton* addButton;
@property (weak,nonatomic) IBOutlet UIImageView* menuimage;
@property (weak,nonatomic) PlanViewController* superViewController;

@property (strong,nonatomic) PlanEntity* planentity;
@property (weak,nonatomic) IBOutlet UITableView* storeListView;

@property (strong,nonatomic) NSString* originTaskName;
@property (strong,nonatomic) NSArray* originStore;

@property (strong,nonatomic) NSMutableArray* storelist;

@property (strong,nonatomic) NSMutableArray* handleList;
@property (strong,nonatomic) NSMutableArray* resultList;

@property (strong,nonatomic) UIView* waitView;

@property (assign ) BOOL changeAndSave;

@end
