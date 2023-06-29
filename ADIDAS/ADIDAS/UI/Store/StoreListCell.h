//
//  StoreListCell.h
//  ADIDAS
//
//  Created by wendy on 14-5-6.
//
//

#import <UIKit/UIKit.h>
#import "StoreEntity.h"
#import "ASIHTTPRequest.h"

@interface StoreListCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel* nameLabel;
@property (weak,nonatomic) IBOutlet UILabel* remarkLabel;
@property (strong,nonatomic) StoreEntity* currentstore;
@property (weak, nonatomic) IBOutlet UILabel *remindRedPotLabel;

@end
