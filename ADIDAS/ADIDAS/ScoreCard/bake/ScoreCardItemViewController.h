//
//  ScoreCardItemViewController.h
//  MobileApp
//
//  Created by 桂康 on 2017/10/25.
//

#import <UIKit/UIKit.h>
#import "VMManageCardEntity.h"
#import "TapLongPressImageView.h"
#import "EditPicViewController.h"


@interface ScoreCardItemViewController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextViewDelegate,
UITextFieldDelegate,
UIActionSheetDelegate,
selectPicDelegate,
TapLongPressImageViewDelegate,UIScrollViewDelegate>

@property (weak,nonatomic) IBOutlet UIButton* No_label;
@property (weak,nonatomic) IBOutlet UITextView* Item_textview;
@property (weak,nonatomic) IBOutlet UILabel* Remark_label;
@property (weak,nonatomic) IBOutlet UITextView* comment_textview;
@property (retain, nonatomic) IBOutlet TapLongPressImageView *photo_1;
@property (retain, nonatomic) IBOutlet TapLongPressImageView *photo_2;

@property (retain, nonatomic) IBOutlet UIButton *lastBtn;
@property (retain, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak,nonatomic) IBOutlet UITextField* pagetextfield;
@property (weak,nonatomic) IBOutlet UIScrollView* scrollview;
@property (weak,nonatomic) IBOutlet UIView* pagectrview;
@property (weak,nonatomic) IBOutlet UIView* secondpageview;
@property (retain, nonatomic) IBOutlet UILabel *scorecardLabel;

@property (strong,nonatomic) UIActionSheet* ac;
@property (strong, nonatomic) NSMutableArray *labelArray ;


- (IBAction)leftPicDetailAction:(id)sender;
- (IBAction)rightPicDetailAction:(id)sender;

@property (weak,nonatomic) IBOutlet UIView* page_view;
@property (weak,nonatomic) IBOutlet UIView* small_pageview;
@property (weak,nonatomic) IBOutlet UILabel* label;

@property (strong,nonatomic) UIImagePickerController* photoPicker;
@property (strong,nonatomic) NSString* picpath_1,*picpath_2;

@property (retain, nonatomic) IBOutlet UIView *ImageBGView;
@property (retain, nonatomic) IBOutlet UIImageView *bigImage;
@property (retain, nonatomic) IBOutlet UIButton *gobuttom;



@property (strong,nonatomic) VMManageCardEntity* CurrentmanageResultEntity;
@property (strong,nonatomic) NSString* item_id;
@property (assign,nonatomic) NSInteger No;

@property (strong,nonatomic) NSString* item_name;
@property (strong,nonatomic) NSString* remark;
@property (strong,nonatomic) NSString* standard_score;


@property (retain, nonatomic) IBOutlet UIButton *firButton;
@property (retain, nonatomic) IBOutlet UIButton *secButton;

@property (assign) BOOL iscamera;



@end
