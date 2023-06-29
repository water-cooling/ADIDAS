//
//  PhotoViewController.h
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVM_STORE_PHOTO_ZONE_Entity.h"
#import "EditPicViewController.h"

@protocol RefreshDelegate <NSObject>

- (void)AddToDBWithCode:(NVM_STORE_PHOTO_ZONE_Entity *)newEntity ;

@end

@interface PhotoViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,selectPicDelegate>

@property (strong,nonatomic) UIImagePickerController* picker;
@property (weak,nonatomic) IBOutlet UIButton* before;
@property (weak,nonatomic) IBOutlet UIButton* after;
@property (weak,nonatomic) IBOutlet UIImageView* beforeimage;
@property (weak,nonatomic) IBOutlet UIImageView* afterimage;

@property (strong,nonatomic) NSString* beforePath;
@property (strong,nonatomic) NSString* afterPath;
@property (strong,nonatomic) NVM_STORE_PHOTO_ZONE_Entity* entity;
@property (strong,nonatomic) NSString* comment;
@property (retain,nonatomic) IBOutlet UITextView* textview;
@property (retain, nonatomic) IBOutlet UILabel *label;

@property (retain, nonatomic) IBOutlet UIView *picView;
@property (weak,nonatomic) IBOutlet UIButton* delete1;
@property (weak,nonatomic) IBOutlet UIButton* delete2;
@property (retain, nonatomic) IBOutlet UIButton *firButton;
@property (retain, nonatomic) IBOutlet UIButton *secButton;
- (IBAction)firBigPicAction:(id)sender;
- (IBAction)secBigPicAction:(id)sender;

@property (strong, nonatomic) id<RefreshDelegate> PhotoDelegate ;
@property (assign) BOOL IsNew ;
@property (retain, nonatomic) IBOutlet UIView *BigBGView;
@property (retain, nonatomic) IBOutlet UIImageView *BigImageView;

- (id)initWithDelegate:(id)dgate ;

@end
