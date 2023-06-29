//
//  ChangePasswordController.h
//  ADIDAS
//
//  Created by testing on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoManagement.h"
#import "TextFieldValidator.h"

@interface ChangePasswordController : UIViewController<UITextFieldDelegate,UserManagementDelegate,UIAlertViewDelegate>
{
    UserInfoManagement *_usermanagement;
}

@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;

@property (retain,nonatomic) IBOutlet UITextField* usernametextfield;
@property (retain,nonatomic) IBOutlet UITextField* passwdtextfield;
@property (retain,nonatomic) IBOutlet TextFieldValidator* newpasswdtextfield;
@property (retain,nonatomic) IBOutlet UITextField* confirmpasswdtextfield;

@property (retain,nonatomic) IBOutlet UILabel* label1;
@property (retain,nonatomic) IBOutlet UILabel* label2;
@property (retain,nonatomic) IBOutlet UILabel* label3;
@property (retain,nonatomic) IBOutlet UIButton* btn1;

@property (retain,nonatomic) IBOutlet UILabel* titlelabel;

@end
