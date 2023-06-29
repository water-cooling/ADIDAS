//
//  RailManageTableViewCell.h
//  ADIDAS
//
//  Created by wendy on 14-4-23.
//
//

#import <UIKit/UIKit.h>

@interface RailManageTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel* numLabel;
@property (weak,nonatomic) IBOutlet UILabel* issueLabel;
@property (weak,nonatomic) IBOutlet UILabel* scoreLabel;
@property (weak,nonatomic) IBOutlet UIImageView* lineimageview;
@property (weak,nonatomic) IBOutlet UIImageView* arrowimageview;

@property (strong,nonatomic) NSString* remark;
@property (strong,nonatomic) NSString* reasons;
@property (strong,nonatomic) NSString* scoreOption;
@property (strong,nonatomic) NSString* itemID;

-(void)configCellHeight:(NSString*) str;

@end
