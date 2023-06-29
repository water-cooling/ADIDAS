//
//  StoreMenuViewController.h
//  ADIDAS
//
//  Created by wendy on 14-5-9.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IssueManagement.h"
#import <AMapLocationKit/AMapLocationManager.h>

@interface VMStoreMenuViewController : UIViewController<UIScrollViewDelegate,IssueManagementDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ASIHTTPRequestDelegate,AMapLocationManagerDelegate>

@property (retain,nonatomic) UIImagePickerController* photoPicker;
@property (assign, nonatomic) BOOL ShowLeftButton ;

@property (weak,nonatomic) IBOutlet UILabel* locationLabel;
@property (strong,nonatomic) IssueManagement* issueManagement;
@property (weak, nonatomic) IBOutlet UIButton *scoreCardBtn;
@property (weak,nonatomic) IBOutlet UIButton* issueBtn;
@property (weak, nonatomic) IBOutlet UIButton *roIssueBtn;
@property (weak,nonatomic) IBOutlet UIButton* signBtn;
@property (weak,nonatomic) IBOutlet UIButton* takephotoBtn;
@property (weak,nonatomic) IBOutlet UIButton* VMrailmanageBtn;
@property (weak,nonatomic) IBOutlet UIButton* railmanageBtn;
@property (weak,nonatomic) IBOutlet UIButton* popBtn;
@property (weak, nonatomic) IBOutlet UIButton *employeBtn;
@property (retain, nonatomic) IBOutlet UIButton *exerciseBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *BGScrollViewNew;
@property (retain, nonatomic) IBOutlet UIButton *auditButton;
@property (retain, nonatomic) IBOutlet UIButton *onSiteButton;

@property (strong,nonatomic) NSMutableArray* picarray;
@property (strong,nonatomic) NSMutableArray* buttonarr;
@property (assign,nonatomic) BOOL allDone;

@property (strong, nonatomic) AMapLocationManager *locationManager ;
@property (weak, nonatomic) IBOutlet UIButton *railSignBtn;
- (IBAction)railSingAction:(id)sender;
- (IBAction)scoreCardAction:(id)sender;
- (IBAction)roIssueAction:(id)sender;
- (IBAction)employeAction:(id)sender;
- (IBAction)exerciseAction:(id)sender;
- (IBAction)auditAction:(id)sender;
- (IBAction)VMrailmanage:(id)sender;
- (IBAction)onSiteAction:(id)sender;
- (void)checkout;


@end
