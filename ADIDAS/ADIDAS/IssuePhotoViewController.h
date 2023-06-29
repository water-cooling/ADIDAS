//
//  IssuePhotoViewController.h
//  VM
//
//  Created by leo.you on 14-7-25.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVM_ISSUE_PHOTO_ZONE_Entity.h"
#import "EditPicViewController.h"

@interface IssuePhotoViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,selectPicDelegate,UIActionSheetDelegate>
{
    BOOL isShow;
    NSString *userType ;
}
@property (strong,nonatomic) UIImagePickerController* picker;

@property (weak,nonatomic) IBOutlet UIButton* before;
@property (weak,nonatomic) IBOutlet UIButton* after;
@property (weak,nonatomic) IBOutlet UIImageView* beforeimage;
@property (weak,nonatomic) IBOutlet UIImageView* afterimage;

@property (strong,nonatomic) NSString* beforePath;
@property (strong,nonatomic) NSString* afterPath;
@property (strong,nonatomic) NVM_ISSUE_PHOTO_ZONE_Entity* entity;
@property (strong,nonatomic) NSString* comment;
@property (weak,nonatomic) IBOutlet UITextView* textview;

@property (weak,nonatomic) IBOutlet UILabel* label;

@property (weak,nonatomic) IBOutlet UIButton* delete1;
@property (weak,nonatomic) IBOutlet UIButton* delete2;
@property (retain, nonatomic) IBOutlet UIImageView *bigImageView;
@property (retain, nonatomic) IBOutlet UIView *ImageBGView;
@property (retain, nonatomic) IBOutlet UIButton *firButton;
- (IBAction)firPicAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *receiveButton;
- (IBAction)selectAction:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *secButton;

- (IBAction)secPicAction:(id)sender;

@end
