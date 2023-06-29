//
//  StoreReviewViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/6/11.
//

#import <UIKit/UIKit.h>

@interface StoreReviewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *storeTableView;
@property (strong, nonatomic) NSArray *dataListArray ;
@property (strong, nonatomic) NSArray *filterArray ;
@property (strong, nonatomic) UIRefreshControl* refreshcontrol;
@property (strong, nonatomic) NSString *firCondition ;
@property (strong, nonatomic) NSString *secCondition ;
@property (strong, nonatomic) NSString *thiCondition ;
@property (strong, nonatomic) NSString *fourCondition ;


@property (retain, nonatomic) IBOutlet UIButton *monthBtn;
@property (retain, nonatomic) IBOutlet UIButton *campaignBtn;
@property (retain, nonatomic) IBOutlet UIButton *formatBtn;
@property (retain, nonatomic) IBOutlet UIButton *moreBtn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)filterAction:(id)sender;

@end
