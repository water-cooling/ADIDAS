//
//  CampaignPhotoListViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/7/11.
//

#import <UIKit/UIKit.h>

@protocol RefreshDelegate <NSObject>

@optional
- (void)refreshListData ;
@end

@interface CampaignPhotoListViewController : UIViewController

@property (assign, nonatomic) id<RefreshDelegate> delegate ;
@property (strong, nonatomic) NSArray *dataSource ;
@property (strong, nonatomic) NSDictionary *dataDic ;
@property (strong, nonatomic) NSString *campaignName ;
@property (strong, nonatomic) NSString *CampaignInstallId;
@property (retain, nonatomic) IBOutlet UITableView *photoTableView;
@property (strong, nonatomic) UIImageView *sampleImageView ;
@property (retain, nonatomic) IBOutlet UIImageView *statusImageView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
