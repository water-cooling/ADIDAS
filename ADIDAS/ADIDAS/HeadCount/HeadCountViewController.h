//
//  HeadCountViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"

@interface HeadCountViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UploadManagementDelegate,UIAlertViewDelegate>
{
    int selectLine;
    int selectPosition ;
}
@property (strong, nonatomic) NSMutableArray *dataSourceArray ;
@property (strong,nonatomic) UITableView* Issue_list_TableView;
@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) UIView* waitView;
@end
