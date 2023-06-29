//
//  HeadCountCustomCell.h
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import <UIKit/UIKit.h>

@protocol InputDelegate <NSObject>

- (void)tapInputLabel:(int)index labelType:(int)type ;

@end

@interface HeadCountCustomCell : UITableViewCell

@property (assign, nonatomic) int index ;
@property (assign, nonatomic) id<InputDelegate> delegate ;
@property (retain, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *leftInputLabel;
@property (retain, nonatomic) IBOutlet UILabel *rightInputLabel;
@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightBtn;
@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (retain, nonatomic) IBOutlet UIImageView *rightImageView;
- (IBAction)tapAction:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *leftStarLabel;
@property (retain, nonatomic) IBOutlet UILabel *rightStarLabel;

@property (retain, nonatomic) IBOutlet UIButton *thirdBtn;
@property (retain, nonatomic) IBOutlet UILabel *thirdTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *thirdStarLabel;
@property (retain, nonatomic) IBOutlet UILabel *thirdInputLabel;



@end
