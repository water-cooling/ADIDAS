//
//  PlanListCell.h
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanEntity.h"

@interface PlanListCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel* timeLabel;
@property (weak,nonatomic) IBOutlet UILabel* eventLabel;
@property (strong,nonatomic) PlanEntity* planentity;

@property (weak,nonatomic) IBOutlet UILabel* storelistlabel;

@end
