//
//  VM_CHECK_ITEM_Cell.h
//  VM
//
//  Created by leo.you on 14-7-21.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VM_CHECK_ITEM_Cell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel* no_label;
@property (weak,nonatomic) IBOutlet UILabel* title_label;
@property (weak,nonatomic) IBOutlet UILabel* history_score_label;
@property (weak,nonatomic) IBOutlet UILabel* score_label;
@property (weak,nonatomic) IBOutlet UIImageView* done_image;
@property (retain, nonatomic) IBOutlet UIImageView *scorecard_image;
@property (retain, nonatomic) IBOutlet UIImageView *arrow_imageview;
@property (retain, nonatomic) IBOutlet UILabel *monthScoreLabel;


@property (strong,nonatomic) NSString* item_ID;
@property (strong,nonatomic) NSString* VM_CATEGORY_ID ;


@end
