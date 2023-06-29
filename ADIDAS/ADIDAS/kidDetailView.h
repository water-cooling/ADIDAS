//
//  kidDetailView.h
//  ADIDAS
//
//  Created by 桂康 on 2017/7/31.
//
//

#import <UIKit/UIKit.h>
#import "TapLongPressImageView.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"


@protocol KidDelegate <NSObject>

- (void)showBigImage:(NSString *)path ;

@end


@interface kidDetailView : UIView<UIActionSheetDelegate,UITextViewDelegate,TapLongPressImageViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WBGImageEditorDelegate,WBGImageEditorDataSource>

@property (retain, nonatomic) IBOutlet UIButton *YES_btn;
@property (retain, nonatomic) IBOutlet UIButton *NO_btn;
@property (retain, nonatomic) IBOutlet UIButton *NA_btn;
@property (retain, nonatomic) IBOutlet UILabel *Y_label;
@property (retain, nonatomic) IBOutlet UILabel *N_label;
@property (retain, nonatomic) IBOutlet UILabel *na_label;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UITextView *comment_textview;
@property (retain, nonatomic) IBOutlet UIButton *reasonBtn;
@property (retain, nonatomic) IBOutlet UIView *secondpageview;
@property (retain, nonatomic) IBOutlet TapLongPressImageView *photo_1;
@property (retain, nonatomic) IBOutlet TapLongPressImageView *photo_2;
@property (retain, nonatomic) IBOutlet UIButton *firButton;
@property (retain, nonatomic) IBOutlet UIButton *secButton;
@property (retain, nonatomic) IBOutlet UIButton *No_label;
@property (retain, nonatomic) IBOutlet UITextView *item_textview;
@property (retain, nonatomic) IBOutlet UIScrollView *itemScrollView;
@property (retain, nonatomic) IBOutlet UIView *itemView;
@property (assign,nonatomic) NSInteger No;

@property (assign, nonatomic) id<KidDelegate> delegate ;
@property (strong, nonatomic) NSString *maxScore ;
@property (strong, nonatomic) NSString *item_id ;
@property (strong, nonatomic) NSString *scoreResult ;
@property (strong, nonatomic) NSString* picpath_1 ;
@property (strong, nonatomic) NSString* picpath_2 ;
@property (strong, nonatomic) NSString* reason;
@property (strong, nonatomic) NSArray* reasonsArr ;
@property (strong, nonatomic) UIView *bgview ;


- (IBAction)scor:(id)sender;
- (IBAction)selectreason:(id)sender;
- (IBAction)leftPicDetailAction:(id)sender;
- (IBAction)rightPicDetailAction:(id)sender;


@end
