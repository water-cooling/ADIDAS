//
//  LoginViewController.h
//  WSE
//
//  Created by sow3 on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoManagement.h"
#import "UserInfoEntity.h"
#import "IssueManagement.h"
#import "IssueCategoryEntity.h"
#import "SyncParaVersionEntity.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,
                    UserManagementDelegate,IssueManagementDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    UserInfoManagement *_usermanagement;
    IssueManagement *_issueManagement;
    NSMutableArray *needSyncVersions;
    int timespent;
    BOOL isSave;
    CLLocationManager *locManager;
}

@property (retain,nonatomic) CLLocation *currentLoc;
@property (retain, nonatomic) IBOutlet UIImageView *naviTitleImageView;

@property (retain, nonatomic) NSMutableArray *needSyncVersions;
@property (retain, nonatomic) IBOutlet UILabel *WaitingLabel;

@property (retain, nonatomic) IBOutlet UITextField *txtUserName;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;

@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property (retain, nonatomic) IBOutlet UIButton *btnForget;
@property (retain, nonatomic) IBOutlet UIButton *btnIsSavePwd;
@property (retain, nonatomic) IBOutlet UILabel* saveLabel;


@property (retain,nonatomic) IBOutlet UIView* waitview;

@property(nonatomic)BOOL isTimeOut;

- (IBAction)saveUserEvent:(id)sender;
- (IBAction)loginEvent:(id)sender;


@end
