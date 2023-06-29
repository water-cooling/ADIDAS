//
//  RoIssuePhotoViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/1/4.
//

#import <UIKit/UIKit.h>
#import "FrIssuePhotoZoneEntity.h"
#import "EditPicViewController.h"


@interface RoIssuePhotoViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,selectPicDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) UIImagePickerController* picker;

@property (weak,nonatomic) IBOutlet UIButton* before;
@property (weak,nonatomic) IBOutlet UIButton* after;
@property (weak,nonatomic) IBOutlet UIImageView* beforeimage;
@property (weak,nonatomic) IBOutlet UIImageView* afterimage;
@property (retain, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (strong,nonatomic) NSString* beforePath;
@property (strong,nonatomic) NSString* afterPath;
@property (strong,nonatomic) FrIssuePhotoZoneEntity* entity;
@property (strong,nonatomic) NSString* comment;
@property (weak,nonatomic) IBOutlet UITextView* textview;

@property (weak,nonatomic) IBOutlet UILabel* label;
@property (retain, nonatomic) IBOutlet UITextField *userTextField;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak,nonatomic) IBOutlet UIButton* delete1;
@property (weak,nonatomic) IBOutlet UIButton* delete2;
@property (retain, nonatomic) IBOutlet UIImageView *bigImageView;
@property (retain, nonatomic) IBOutlet UIView *ImageBGView;
@property (retain, nonatomic) IBOutlet UIButton *firButton;
- (IBAction)firPicAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *selectDatePicker;
- (IBAction)SelectDateAction:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *solutionTextField;
@property (retain, nonatomic) IBOutlet UILabel *solutionLabel;
@property (retain, nonatomic) IBOutlet UILabel *peopleLeftLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLeftLabel;

- (IBAction)TapBGAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *secButton;

- (IBAction)secPicAction:(id)sender;

@end
