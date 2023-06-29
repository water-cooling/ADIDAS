//
//  TakePhotoListCell.h
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVM_STORE_PHOTO_ZONE_Entity.h"
#import "NVM_ISSUE_PHOTO_ZONE_Entity.h"
#import "FrIssuePhotoZoneEntity.h"

@protocol installcellDelegate <NSObject>

@optional

- (void)addNew:(id)cell;
- (void)openCamera:(NSInteger)index beforeafter:(int)type;
- (void)showDetailImage:(NSInteger)index beforeafter:(int)type;

@end

@interface TakePhotoListCell : UITableViewCell<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak,nonatomic) IBOutlet UIImageView* before;
@property (weak,nonatomic) IBOutlet UIImageView* after;
@property (weak,nonatomic) IBOutlet UILabel* titleLabel;
@property (weak,nonatomic) IBOutlet UIImageView* doneImage;
@property (weak,nonatomic) IBOutlet UIButton* addNewbtn;

@property (strong,nonatomic) NVM_STORE_PHOTO_ZONE_Entity* entity;
@property (strong,nonatomic) NVM_ISSUE_PHOTO_ZONE_Entity* issueEntity;
@property (strong,nonatomic) FrIssuePhotoZoneEntity* roIssueEntity;
@property (assign,nonatomic) NSInteger indexType;


@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightBtn;

- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;

- (IBAction)leftDetailAction:(id)sender;
- (IBAction)rightDetailAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *leftDetailButton;
@property (retain, nonatomic) IBOutlet UIButton *rightDetailButton;


@property (weak,nonatomic) id<installcellDelegate>delegate;


@end
