//
//  TrackingCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2020/12/2.
//

#import "TrackingCustomCell.h"
#import "CommonUtil.h"

@implementation TrackingCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.descriptionTextView.layer.borderWidth = 1 ;
    self.descriptionTextView.layer.borderColor = [CommonUtil colorWithHexString:@"#c6c6c8"].CGColor;
    self.descriptionTextView.layer.cornerRadius = 5 ;
    self.descriptionTextView.layer.masksToBounds = YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
