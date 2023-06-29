//
//  AuditDetailViewController.h
//  ADIDAS
//
//  Created by wendy on 14-4-24.
//
//

#import <UIKit/UIKit.h>
#import "VMStoreAuditScoreEntity.h"
#import "TapLongPressImageView.h"
#import "EditPicViewController.h"

@interface AuditDetailViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,selectPicDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    NSUInteger currentIndex ;
    NSUInteger currentResultCollectIndex;
    NSUInteger currentResultTableIndex;
    NSMutableArray *subArray ;
}


@property (weak,nonatomic) IBOutlet UIButton* No_label;
@property (retain, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (weak,nonatomic) IBOutlet UIButton* Yes_btn, *No_btn;
@property (weak,nonatomic) IBOutlet UIButton* lastBtn,* nextBtn;
@property (weak,nonatomic) IBOutlet UITextField* pagetextfield;
@property (weak,nonatomic) IBOutlet UIScrollView* scrollview;
@property (weak,nonatomic) IBOutlet UIView* pagectrview;

@property (strong,nonatomic) UIActionSheet* ac;
@property (strong, nonatomic) NSMutableArray *labelArray ;

@property (weak,nonatomic) IBOutlet UIView* page_view;
@property (weak,nonatomic) IBOutlet UIView* small_pageview;

@property (strong,nonatomic) UIImagePickerController* photoPicker;
@property (retain, nonatomic) IBOutlet UIView *ImageBGView;
@property (retain, nonatomic) IBOutlet UIImageView *bigImage;
@property (retain, nonatomic) IBOutlet UIButton *gobuttom;
@property (retain, nonatomic) IBOutlet UICollectionView *PicCollectView;
@property (retain, nonatomic) IBOutlet UICollectionView *scoreCollectView;
@property (retain, nonatomic) IBOutlet UITableView *scoreTableView;
@property (retain, nonatomic) IBOutlet UIView *NAView;
@property (retain, nonatomic) IBOutlet UILabel *NALabel;
@property (retain, nonatomic) IBOutlet UIButton *NAButton;


@property (strong,nonatomic) VMStoreAuditScoreEntity* CurrentmanageResultEntity;


@property (strong,nonatomic) NSString *item_id;
@property (assign,nonatomic) NSInteger No;
@property (strong,nonatomic) NSString *subTitleNo;
@property (strong,nonatomic) NSString *item_name;
@property (strong,nonatomic) NSString *scoreResult;
@property (strong,nonatomic) NSString *maxPicCount;
@property (strong,nonatomic) NSString *mustComment;
@property (strong,nonatomic) NSString *isSpecial;
@property (strong,nonatomic) NSString *standardScore;
@property (strong,nonatomic) NSString *parentTitle ;
@property (strong,nonatomic) NSString *item_description ;

- (IBAction)closeKeyBoard:(id)sender;

@end
