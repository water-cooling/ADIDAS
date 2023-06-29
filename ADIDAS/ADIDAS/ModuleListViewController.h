//
//  ModuleListViewController.h
//  MobileApp
//
//  Created by 桂康 on 2017/11/3.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"


@interface ModuleListViewController : UIViewController<UploadManagementDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSString *type ;
@property (strong,nonatomic) NSString *commentInsertTimeForWorkMain ;
@property (strong,nonatomic) NSString *commentDate ;
@property (strong, nonatomic) NSArray *scoreArray ;
@property (strong, nonatomic) NSArray *commentDataArray ;
@property (strong, nonatomic) NSArray *remarkDataArray ;
@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) NSMutableArray* tableviewSourceArr;
@property (strong,nonatomic) NSMutableArray* resultPicArr;
@property (strong,nonatomic) NSMutableArray* resultArr;
@property (strong,nonatomic) UIView* waitView;

@property (strong, nonatomic) NSArray *MonthlyScore ;

@property (retain, nonatomic) IBOutlet UITableView *scoreTableView;

@property (strong, nonatomic) NSString *workmainid ;
@property (strong, nonatomic) NSString *selectedDate ;
@property (strong, nonatomic) NSString *storename ;

@property (strong, nonatomic) NSArray *checkPhotoIdArray ;


@end
