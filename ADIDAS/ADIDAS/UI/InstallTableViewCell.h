//
//  InstallTableViewCell.h
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Utilities.h"

@protocol installcellDelegate <NSObject>

@required
-(void) openCamera:(UIImagePickerController*)picker;
-(void) showLargePic:(NSString*)pic_name;
-(void) resetSourceData:(int)index ;
-(void) inputComment:(int)index ;
@end

@interface InstallTableViewCell : UITableViewCell<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (assign, nonatomic) int currentIndex;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak,nonatomic) IBOutlet UIScrollView* textscrllview;
@property (weak,nonatomic) IBOutlet UIImageView* takephotoImage;
@property (weak,nonatomic) IBOutlet UIButton* demoPhoto;
@property (weak,nonatomic) IBOutlet UILabel* resultLabel;
@property (strong,nonatomic) NSMutableString* pic_name;
@property (strong,nonatomic) NSMutableString* pic_name_thumb;


@property (strong,nonatomic) NSString* picpath;
@property (strong,nonatomic) NSString* campaign_id;
@property (strong,nonatomic) NSString* pop_id;

@property (strong,nonatomic) IBOutlet UILabel* describeLabel;
@property (strong,nonatomic) NSString* describeStr;
@property (weak,nonatomic) IBOutlet UILabel* number_label;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (assign,nonatomic) NSInteger scroll_width;
@property (strong,nonatomic) UIImagePickerController* photoPicker;

- (IBAction)inputAction:(id)sender;
@property (assign,nonatomic) NSTimer* timer;

- (IBAction)picAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *picButton;
@property (weak,nonatomic) id<installcellDelegate>delegate;

-(void)configUI;
-(void)downloadImage:(NSString*)string;

@end
