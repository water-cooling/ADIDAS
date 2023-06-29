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
selectPicDelegate,
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (weak,nonatomic) IBOutlet UIButton* No_label;
@property (weak,nonatomic) IBOutlet UITextView* Item_textview;
@property (weak,nonatomic) IBOutlet UITextView* comment_textview;
@property (retain, nonatomic) IBOutlet UIButton *lastBtn;
@property (retain, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak,nonatomic) IBOutlet UITextField* pagetextfield;
@property (weak,nonatomic) IBOutlet UIScrollView* scrollview;
@property (weak,nonatomic) IBOutlet UIView* pagectrview;
@property (weak,nonatomic) IBOutlet UIView* page_view;
@property (weak,nonatomic) IBOutlet UIView* small_pageview;
@property (weak,nonatomic) IBOutlet UILabel* label;
@property (retain, nonatomic) IBOutlet UIView *ImageBGView;
@property (retain, nonatomic) IBOutlet UIImageView *bigImage;
@property (retain, nonatomic) IBOutlet UIButton *gobuttom;
@property (retain, nonatomic) IBOutlet UITableView *scoreItemTableView;
@property (retain, nonatomic) IBOutlet UITableView *scoreTableView;
@property (strong, nonatomic) NSArray *scoreArray ;
@property (assign, nonatomic) NSInteger currentSelectIndex;
@property (strong, nonatomic) NSString *currentSelectType ;
@property (strong, nonatomic) NSString* commentDate ;
@property (strong,nonatomic) UIImagePickerController* photoPicker;
@property (strong,nonatomic) VMManageCardEntity* CurrentmanageResultEntity;
@property (strong,nonatomic) NSString* item_id;
@property (assign,nonatomic) NSInteger No;
@property (strong,nonatomic) NSString* item_name;
@property (strong,nonatomic) NSString* remark;
@property (strong,nonatomic) NSString* photozone;
@property (strong,nonatomic) NSString* standard_score;

@property (strong, nonatomic) NSArray *scoreData ;
@property (strong, nonatomic) NSArray *commentData ;
@property (strong, nonatomic) NSArray *remarkData ;
@property (strong,nonatomic) NSString *type ;




@end
