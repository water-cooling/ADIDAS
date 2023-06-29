//
//  OnSiteFirstViewController.h
//  MobileApp
//
//  Created by 桂康 on 2021/3/26.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"


NS_ASSUME_NONNULL_BEGIN

@interface OnSiteFirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UploadManagementDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray* PhotoListArr;
@property (strong,nonatomic) NSMutableArray* zoneIDArr;
@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) UITableView* takePhoto_list_TableView;
@property (strong,nonatomic) UIView* waitView;

@end

NS_ASSUME_NONNULL_END
