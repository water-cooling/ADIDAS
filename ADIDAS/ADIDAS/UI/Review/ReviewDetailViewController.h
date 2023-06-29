//
//  ReviewDetailViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/6/13.
//

#import <UIKit/UIKit.h>

@protocol RefreshStoreDelegate <NSObject>

- (void)refershList ;

@end

@interface ReviewDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (retain, nonatomic) IBOutlet UITableView *campaginListTableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (assign, nonatomic) id<RefreshStoreDelegate> delegate ;
@property (strong, nonatomic) NSArray *dataSourceArray ;
@property (strong, nonatomic) NSDictionary *selectedDic ;
@end
