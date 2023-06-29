//
//  AddNewPlanTableViewCell.m
//  VM
//
//  Created by leo.you on 14-7-28.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "AddNewPlanTableViewCell.h"
#import "AddNewPlanViewController.h"
#import "PlanDetailViewController.h"

@implementation AddNewPlanTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.added = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)addStore:(id)sender
{
    [self.superviewcontroller.superViewController.storelist addObject:self.currentstore];
}

@end
