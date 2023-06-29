//
//  UploadTableViewCell.h
//  VM
//
//  Created by leo.you on 14-8-7.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadFileEntity.h"

@interface UploadTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel* storeCodeLabel;
@property (weak,nonatomic) IBOutlet UILabel* storeNameLabel;
@property (weak,nonatomic) IBOutlet UILabel* timeLabel;
@property (weak,nonatomic) IBOutlet UILabel* vmchecklabel;
@property (weak,nonatomic) IBOutlet UILabel* vmphotolabel;
@property (weak,nonatomic) IBOutlet UILabel* vmissuelabel;
@property (weak,nonatomic) IBOutlet UILabel* vmsignlabel;
@property (weak, nonatomic) IBOutlet UILabel *scorecardLabel;

@property (weak,nonatomic) IBOutlet UILabel* railchecklabel;
@property (weak,nonatomic) IBOutlet UILabel* installlabel;

@property (strong,nonatomic) UploadFileEntity* uploadEntity;
@property (weak, nonatomic) IBOutlet UILabel *ARSMSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *RoIssueLabel;
@property (weak, nonatomic) IBOutlet UILabel *headCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *trainingLabel;
@property (retain, nonatomic) IBOutlet UILabel *issueTrackingLabel;

@end
