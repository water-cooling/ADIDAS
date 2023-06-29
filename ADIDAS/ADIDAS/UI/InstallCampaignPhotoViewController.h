//
//  InstallCampaignPhotoViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/7/11.
//

#import <UIKit/UIKit.h>
#import "CampaignPopData.h"

@interface InstallCampaignPhotoViewController : UIViewController

@property (strong, nonatomic) NSArray *popListData ;
@property (strong,nonatomic) UITableView* campaignPopTable;
@property (strong,nonatomic) CampaignPopData *campData ;


@end
