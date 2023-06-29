//
//  CampgainStoreCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2018/6/11.
//

#import "CampgainStoreCustomCell.h"

@implementation CampgainStoreCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_titleLabel release];
    [_subTitleLabel release];
    [_rightStatusImageView release];
    [_finishStatusImageView release];
    [super dealloc];
}
@end
