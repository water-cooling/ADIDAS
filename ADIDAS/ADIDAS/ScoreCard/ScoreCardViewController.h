//
//  ScoreCardViewController.h
//  MobileApp
//
//  Created by 桂康 on 2017/10/25.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"

@interface ScoreCardViewController : UIViewController<UploadManagementDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) NSMutableArray* tableviewSourceArr;
@property (strong,nonatomic) NSMutableArray* resultPicArr;
@property (strong,nonatomic) NSMutableArray* resultArr;
@property (strong,nonatomic) UIView* waitView;
@property (strong,nonatomic) NSString *type ;
@property (retain, nonatomic) IBOutlet UITableView *scoreTableView;
@property (strong, nonatomic) NSArray *checkPhotoIdArray ;


@end
