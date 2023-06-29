//
//  SysSettingViewController.h
//  ADIDAS
//
//  Created by wendy on 14-5-6.
//
//

#import <UIKit/UIKit.h>
#import <AMapLocationKit/AMapLocationManager.h>

@interface VMSysSettingViewController : UIViewController <UIAlertViewDelegate,AMapLocationManagerDelegate>
{
    BOOL ISDelete ;
}

@property (weak,nonatomic) IBOutlet UILabel* accountLabel;
@property (weak,nonatomic) IBOutlet UILabel* usernameLabel;
@property (weak,nonatomic) IBOutlet UILabel* positionLabel;
@property (weak,nonatomic) IBOutlet UIImageView* notiImageView;
@property (weak,nonatomic) IBOutlet UILabel* notiNumLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *BGScroll;
@property (weak,nonatomic) IBOutlet UILabel* LoinTimesLabel;
@property (weak,nonatomic) IBOutlet UILabel* VisitHoursLabel;
@property (weak,nonatomic) IBOutlet UIButton* button;
@property (weak,nonatomic) IBOutlet UILabel* label1;
@property (weak,nonatomic) IBOutlet UILabel* label2;
@property (weak,nonatomic) IBOutlet UIButton* btn1;
@property (weak,nonatomic) IBOutlet UIButton* btn2;
@property (weak,nonatomic) IBOutlet UIButton* btn3;
@property (strong,nonatomic) UIView* waitView;
@property (retain, nonatomic) IBOutlet UIButton *HistoryButton;
@property (retain, nonatomic) IBOutlet UIButton *DeleteCacheButton;
@property (strong, nonatomic) AMapLocationManager *locationManager ;

- (IBAction)DeleteCache:(id)sender;
- (IBAction)SearchHistory:(id)sender;

@end
