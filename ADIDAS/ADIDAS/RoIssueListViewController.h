//
//  RoIssueListViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/1/4.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"
#import "TakePhotoListCell.h"
#import "UIImage+resize.h"


@interface RoIssueListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UploadManagementDelegate,UIAlertViewDelegate,installcellDelegate>
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
@property (strong) NSIndexPath* refreshIndexPath;
@property (strong,nonatomic) UIView* waitView;

@end
