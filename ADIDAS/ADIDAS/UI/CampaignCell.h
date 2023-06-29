//
//  CampaignCell.h
//  ADIDAS
//
//  Created by wendy on 14-5-6.
//
//

#import <UIKit/UIKit.h>

@interface CampaignCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel* namelabel;
@property (weak,nonatomic) IBOutlet UILabel* startdatelabel;
@property (weak,nonatomic) IBOutlet UILabel* submitdatelabel;
@property (strong,nonatomic) NSString* installDate;
@property (strong,nonatomic) NSString* campaignID;

@end
