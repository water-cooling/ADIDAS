//
//  SignViewController.h
//  VM
//
//  Created by leo.you on 14-7-31.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawTouchPointView.h"
#import "IssueManagement.h"

@interface SignViewController : UIViewController<IssueManagementDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *type_path ;
    NSString *UseCurrentDate ;
}
-(IBAction)Back;
-(IBAction)clear;
-(IBAction)done;
@property (strong,nonatomic) DrawTouchPointView* signView;
@property (strong,nonatomic) IssueManagement* issueManagement;
@property (weak,nonatomic) IBOutlet UIButton* backButton;
@property (weak,nonatomic) IBOutlet UIImageView* bgimageview;
@property (weak,nonatomic) IBOutlet UILabel* signtextLabel;

@property (weak,nonatomic) IBOutlet UIButton* clearButton;
@property (weak,nonatomic) IBOutlet UIButton* doneButton;
@property (retain, nonatomic) IBOutlet UIButton *picButton;
@property (retain, nonatomic) IBOutlet UIImageView *picImageView;

@property (assign, nonatomic) BOOL isFromRailManage ;



- (IBAction)takePic:(id)sender;
@end
