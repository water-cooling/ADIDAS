//
//  GoodDetailCustomCell.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/16.
//
//

#import <UIKit/UIKit.h>

typedef void(^BackAction)(NSInteger index);

@interface GoodDetailCustomCell : UITableViewCell

@property (assign, nonatomic) NSInteger index ;
@property (retain, nonatomic) IBOutlet UIImageView *goodImageView;
@property (retain, nonatomic) IBOutlet UILabel *orderLabel;
@property (retain, nonatomic) IBOutlet UILabel *goodLabel;
@property (retain, nonatomic) IBOutlet UILabel *kindLabel;
@property (retain, nonatomic) IBOutlet UILabel *submitLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;

@end
