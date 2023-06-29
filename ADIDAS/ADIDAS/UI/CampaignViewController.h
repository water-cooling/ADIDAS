//
//  CampaignViewController.h
//  ADIDAS
//
//  Created by wendy on 14-5-6.
//
//

#import <UIKit/UIKit.h>
#import "CampaignData.h"
#import "StoreManagement.h"

@interface CampaignViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StoreManagementDelegate>
{
    StoreManagement *_management;
}

@property (strong,nonatomic) NSMutableArray* campaignList;
@property (strong,nonatomic) NSString* storeCode;
@property (weak,nonatomic) IBOutlet UITableView* campaigntableview;
@property (weak,nonatomic) IBOutlet UILabel* label;

@end
