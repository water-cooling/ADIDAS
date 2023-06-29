//
//  OnSiteViewController.h
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NvmMstOnSitePhotoZoneEntity.h"
#import "EditPicViewController.h"

@interface OnSiteViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,selectPicDelegate>
{
    NSArray *allZoneArray;
}
@property (strong,nonatomic) UIImagePickerController* picker;
@property (weak,nonatomic) IBOutlet UIButton* before;
@property (weak,nonatomic) IBOutlet UIButton* after;
@property (weak,nonatomic) IBOutlet UIImageView* beforeimage;
@property (weak,nonatomic) IBOutlet UIImageView* afterimage;

@property (strong,nonatomic) NSArray* PhotoListArr;
@property (strong,nonatomic) NSString* beforePath;
@property (strong,nonatomic) NSString* afterPath;
@property (strong,nonatomic) NvmMstOnSitePhotoZoneEntity* entity;
@property (retain,nonatomic) IBOutlet UITextView* textview;
@property (retain, nonatomic) IBOutlet UILabel *label;


@property (retain, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak,nonatomic) IBOutlet UIButton* delete1;
@property (weak,nonatomic) IBOutlet UIButton* delete2;
@property (retain, nonatomic) IBOutlet UIButton *firButton;
@property (retain, nonatomic) IBOutlet UIButton *secButton;
@property (retain, nonatomic) IBOutlet UILabel *addZoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *nextZoneLabel;
- (IBAction)firBigPicAction:(id)sender;
- (IBAction)secBigPicAction:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *BigBGView;
@property (retain, nonatomic) IBOutlet UIImageView *BigImageView;

@property (retain, nonatomic) IBOutlet UITextField *beforTextField;
@property (retain, nonatomic) IBOutlet UITextField *afterTextField;

- (IBAction)beforeSelectAction:(id)sender;
- (IBAction)afterSelectAction:(id)sender;

- (IBAction)addAction:(id)sender;
- (IBAction)nextZoneAction:(id)sender;


@end
