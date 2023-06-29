//
//  ManageScoreViewController.h
//  ADIDAS
//
//  Created by wendy on 14-4-24.
//
//

#import <UIKit/UIKit.h>
#import "ManageScoreEntity.h"
#import "TapLongPressImageView.h"
#import "FilterView.h"

@interface ManageScoreViewController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextViewDelegate,
UITextFieldDelegate,
UIActionSheetDelegate,
TapLongPressImageViewDelegate>

@property (weak,nonatomic) IBOutlet UIButton* No_label;
@property (weak,nonatomic) IBOutlet UITextView* Item_textview;
@property (weak,nonatomic) IBOutlet UILabel* Remark_label;
@property (weak,nonatomic) IBOutlet UITextView* comment_textview;
@property (weak,nonatomic) IBOutlet TapLongPressImageView* photo_1;
@property (weak,nonatomic) IBOutlet TapLongPressImageView* photo_2;
@property (weak,nonatomic) IBOutlet UIButton* Yes_btn, *No_btn, *NA_btn;
@property (weak,nonatomic) IBOutlet UILabel* Y_label, *N_label, *NA_label;
@property (weak,nonatomic) IBOutlet UIButton* lastBtn,* nextBtn;
@property (weak,nonatomic) IBOutlet UITextField* pagetextfield;
@property (weak,nonatomic) IBOutlet UIScrollView* scrollview;
@property (weak,nonatomic) IBOutlet UIView* pagectrview;
@property (weak,nonatomic) IBOutlet UIButton* reasonBtn;
@property (weak,nonatomic) IBOutlet UIView* secondpageview;
@property (strong,nonatomic) FilterView* filterview;
@property (strong,nonatomic) UIActionSheet* ac;

@property (retain, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (retain, nonatomic) IBOutlet UIButton *gobuttom;

// 上次总分
@property (assign,nonatomic) NSInteger Y_num;
@property (assign,nonatomic) NSInteger N_num;
@property (assign,nonatomic) NSInteger NA_num;
@property (assign,nonatomic) NSInteger TOTAL_num;


@property (weak,nonatomic) IBOutlet UIView* page_view;
@property (weak,nonatomic) IBOutlet UIView* small_pageview;

@property (strong,nonatomic) UIImagePickerController* photoPicker;
@property (strong,nonatomic) NSString* picpath_1;
@property (strong,nonatomic) NSString* picpath_2;
@property (assign,nonatomic) CGRect frame;


@property (strong,nonatomic) ManageScoreEntity* CurrentmanageResultEntity;
@property (strong,nonatomic) NSString* item_id;
@property (assign,nonatomic) NSInteger No;
@property (strong,nonatomic) NSString* item_name;
@property (strong,nonatomic) NSString* remark;
@property (strong,nonatomic) NSMutableArray* imageArray;
@property (strong,nonatomic) NSString* scoreOption;
@property (strong,nonatomic) NSArray* reasonsArr;
@property (strong,nonatomic) NSString* reason;

@property (assign,nonatomic) NSInteger scoreResult;
@property (assign,nonatomic) NSInteger totalIssueCount;
@property (strong,nonatomic) NSMutableArray* resultArray;

@property (assign) BOOL iscamera;
@property (retain, nonatomic) IBOutlet UIButton *leftButton;
- (IBAction)leftPicAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)rightPicAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *BGPicView;
@property (retain, nonatomic) IBOutlet UIImageView *picBGView;


@end
