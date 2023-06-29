//
//  ManageScoreViewController.h
//  ADIDAS
//
//  Created by wendy on 14-4-24.
//
//

#import <UIKit/UIKit.h>
#import "VMManageScoreEntity.h"
#import "TapLongPressImageView.h"
#import "VMFilterView.h"
#import "EditPicViewController.h"

@interface VMManageScoreViewController : UIViewController
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
@property (weak,nonatomic) IBOutlet TapLongPressImageView* photo_1,*photo_2;
@property (weak,nonatomic) IBOutlet UIButton* Yes_btn, *No_btn, *NA_btn;
@property (weak,nonatomic) IBOutlet UILabel* Y_label, *N_label, *NA_label;
@property (weak,nonatomic) IBOutlet UIButton* lastBtn,* nextBtn;
@property (weak,nonatomic) IBOutlet UITextField* pagetextfield;
@property (weak,nonatomic) IBOutlet UIScrollView* scrollview;
@property (weak,nonatomic) IBOutlet UIView* pagectrview;
@property (weak,nonatomic) IBOutlet UIButton* reasonBtn;
@property (weak,nonatomic) IBOutlet UIView* secondpageview;
@property (strong,nonatomic) VMFilterView* filterview;
@property (strong,nonatomic) UIActionSheet* ac;
@property (strong, nonatomic) NSMutableArray *labelArray ;
@property (strong, nonatomic) NSString *maxScore ;
// 上次总分
@property (assign,nonatomic) NSInteger Y_num;
@property (assign,nonatomic) NSInteger N_num;
@property (assign,nonatomic) NSInteger NA_num;
@property (assign,nonatomic) NSInteger TOTAL_num;

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



@property (strong,nonatomic) VMManageScoreEntity* CurrentmanageResultEntity;
@property (strong,nonatomic) NSString* item_id;
@property (assign,nonatomic) NSInteger No;

@property (strong,nonatomic) NSString* item_name;
@property (strong,nonatomic) NSString* remark;
@property (strong,nonatomic) NSMutableArray* imageArray;
@property (strong,nonatomic) NSString* scoreOption;
@property (strong,nonatomic) NSArray* reasonsArr;
@property (strong,nonatomic) NSString* reason;

@property (strong,nonatomic) NSString *scoreResult;
@property (assign,nonatomic) NSInteger totalIssueCount;
@property (strong,nonatomic) NSMutableArray* resultArray;
@property (retain, nonatomic) IBOutlet UIButton *firButton;
@property (retain, nonatomic) IBOutlet UIButton *secButton;


@property (assign) BOOL iscamera;
@property (strong, nonatomic) NSString *vmCategoryID ;
@property (strong, nonatomic) NSMutableArray *kidsDataArray ;
@property (strong, nonatomic) NSMutableArray *viewArray ;

@end
