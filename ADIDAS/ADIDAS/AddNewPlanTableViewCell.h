//
//  AddNewPlanTableViewCell.h
//  VM
//
//  Created by leo.you on 14-7-28.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreEntity.h"
@class AddNewPlanViewController;

@interface AddNewPlanTableViewCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel* titleLabel;
@property (weak,nonatomic) IBOutlet UILabel* nameLabel;
@property (weak,nonatomic) IBOutlet UILabel* remarkLabel;
@property (weak,nonatomic) IBOutlet UIButton* addButton;
@property (strong,nonatomic) StoreEntity* currentstore;
@property (weak,nonatomic) AddNewPlanViewController* superviewcontroller;

@property (assign) BOOL added;

-(IBAction)addStore:(id)sender;

@end
