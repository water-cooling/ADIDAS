//
//  TrackingCustomCell.h
//  MobileApp
//
//  Created by 桂康 on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrackingCustomCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *rightShowImageView;
@property (retain, nonatomic) IBOutlet UILabel *downDetailLabel;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (retain, nonatomic) IBOutlet UILabel *descriptionHintLabel;
@property (retain, nonatomic) IBOutlet UISwitch *issueSwitch;



@end

NS_ASSUME_NONNULL_END
