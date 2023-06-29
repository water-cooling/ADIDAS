//
//  CampaignListCustomCell.h
//  MobileApp
//
//  Created by 桂康 on 2018/6/13.
//

#import <UIKit/UIKit.h>

@protocol SubmitDelegate <NSObject>

@optional
- (void)submitCompaign:(NSString *)CampaignInstallDetailId ;
- (void)openDetailImage:(NSString *)type ;
@end

@interface CampaignListCustomCell : UITableViewCell


@property (assign, nonatomic) id<SubmitDelegate> delegate ;
@property (strong, nonatomic) NSString *leftImageUrl ;
@property (retain, nonatomic) IBOutlet UIImageView *leftImageView;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;
@property (retain, nonatomic) IBOutlet UILabel *codeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *statusImageView;
@property (retain, nonatomic) IBOutlet UILabel *commentLabel;
@property (retain, nonatomic) IBOutlet UILabel *photoLabel;
@property (retain, nonatomic) IBOutlet UIButton *leftButton;

- (IBAction)detailImageView:(id)sender;

@end
