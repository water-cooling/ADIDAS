//
//  TakePhotoListViewController.h
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"
#import "TakePhotoListCell.h"
#import "UIImage+resize.h"
#import "PhotoViewController.h"

@interface TakePhotoListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UploadManagementDelegate,UIAlertViewDelegate,installcellDelegate,RefreshDelegate>
{
    UITableView* takePhoto_list_TableView;
    UploadManagement* uploadManage;
}

@property (strong,nonatomic) NSMutableArray* PhotoListArr;


@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) UITableView* takePhoto_list_TableView;

@property (strong,nonatomic) NSMutableArray* resultPicArr;
@property (strong,nonatomic) NSMutableArray* resultPicNameArr;
@property (strong,nonatomic) NSMutableArray* resultArr;
@property (strong,nonatomic) NSMutableArray* mustArr;

@property (strong,nonatomic) UIView* waitView;

-(void)UpdateNVM_IST_STORE_TAKE_PHOTO;

@end
