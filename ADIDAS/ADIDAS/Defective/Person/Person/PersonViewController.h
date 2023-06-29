//
//  PersonViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "BaseViewController.h"

@interface PersonViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    UISwitch *uploadSW ;
}

@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;

@property (retain, nonatomic) IBOutlet UILabel *bgLabel;
@property (retain, nonatomic) IBOutlet UIImageView *headImageView;
@property (retain, nonatomic) IBOutlet UILabel *accountLabel;
@property (retain, nonatomic) IBOutlet UILabel *storeLabel;
@property (retain, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutAction:(id)sender;


@end
