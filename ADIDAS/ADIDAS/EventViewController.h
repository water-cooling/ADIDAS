//
//  EventViewController.h
//  VM
//
//  Created by leo.you on 14-7-28.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueManagement.h"

@class PlanDetailViewController;
@interface EventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,IssueManagementDelegate>
{
    IssueManagement *_issueManagement;
}

@property (strong,nonatomic) NSMutableArray* eventArray;
@property (weak,nonatomic) IBOutlet UITableView* tableview;
@property (weak,nonatomic) PlanDetailViewController* superViewController;

@end
