//
//  InstallNoteTableViewCell.h
//  ADIDAS
//
//  Created by wendy on 14-5-7.
//
//

#import <UIKit/UIKit.h>

@protocol installnotecelldelegate <NSObject>

@required

-(void)showAc:(UIActionSheet*)ac;

-(void)configCellHeightWithReason:(NSInteger)index;

@end

@interface InstallNoteTableViewCell : UITableViewCell<UITextViewDelegate,UIActionSheetDelegate>

@property (weak,nonatomic) IBOutlet UITextView* textview;
@property (weak,nonatomic) IBOutlet UITextView* reasontextview;
@property (weak,nonatomic) IBOutlet UIView* selectReasonView;

@property (weak,nonatomic) IBOutlet UIButton* reasonBtn;
@property (weak,nonatomic) IBOutlet UILabel* holderlabel;
@property (weak,nonatomic) IBOutlet UITextField* textfield;
@property (weak,nonatomic) IBOutlet UIView* commentview;

@property (weak,nonatomic) IBOutlet UILabel* reasonholderlabel;
@property (weak,nonatomic) IBOutlet UIView* reasonview;


@property (strong,nonatomic) UIActionSheet* ac;
@property (weak,nonatomic) id<installnotecelldelegate>delegate;

@property (assign) CGRect commentViewFrame;
@property (assign) BOOL isDelay;


-(IBAction)selectReason:(id)sender;



@end
