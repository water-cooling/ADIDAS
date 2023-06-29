//
//  MakeScoreCustomCell.h
//  MobileApp
//
//  Created by 桂康 on 2017/11/28.
//

#import <UIKit/UIKit.h>
#import "VmScoreCardScoreEntity.h"

@interface MakeScoreCustomCell : UITableViewCell<UITextViewDelegate>

@property (strong, nonatomic) NSString *buttonType ;
@property (retain, nonatomic) IBOutlet UIView *scoreView;
@property (retain, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;
@property (retain, nonatomic) IBOutlet UILabel *showLabel;
@property (retain, nonatomic) IBOutlet UITextView *remarkTextView;
@property (strong, nonatomic) NSArray *scoredArray ;

- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;
- (VmScoreCardScoreEntity *)getScoreCardItem ;


@property (retain, nonatomic) IBOutlet UIButton *leftButton;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) NSString *ScoreCardItemDetailId ;
@property (strong, nonatomic) NSString *scoreCardCheckPhotoId ;
@property (strong, nonatomic) NSString *ScoreCardItemId ;

@end
