//
//  InStallViewController.h
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import <UIKit/UIKit.h>
#import "StoreManagement.h"
#import "CampaignPopData.h"
#import "InstallNoteTableViewCell.h"
#import "ASIHTTPRequest.h"
#import "UploadManagement.h"
#import "InstallScoreEntity.h"
#import "LargeImageView.h"

@interface CampaignPopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StoreManagementDelegate,UINavigationControllerDelegate,installnotecelldelegate,ASIHTTPRequestDelegate,UploadManagementDelegate,LargeImageViewDelegate>
{
    StoreManagement *_management;
    UploadManagement* uploadmanagement;
}

@property (strong,nonatomic) UITableView* campaignPopTable;
@property (strong,nonatomic) NSString* campaignID;
@property (strong,nonatomic) NSMutableArray* campaignPopList;
@property (assign) BOOL isDelay;

@property (strong,nonatomic) NSMutableArray* photoArray;

@property (strong,nonatomic) LargeImageView* largepicView;

@property (assign) unsigned long long Recordull;

@property (strong,nonatomic) UploadManagement* uploadmanagement;
@property (strong,nonatomic) NSMutableArray* picResultArr;

@property (assign,nonatomic) CGFloat height;


@end
