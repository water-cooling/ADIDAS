//
//  OnSiteListViewController.h
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NvmMstOnSitePhotoZoneEntity.h"

@interface OnSiteListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic) NSMutableArray* PhotoListArr;
@property (strong,nonatomic) UITableView* takePhoto_list_TableView;
@property (strong,nonatomic) NvmMstOnSitePhotoZoneEntity *currentEntity;


@end
