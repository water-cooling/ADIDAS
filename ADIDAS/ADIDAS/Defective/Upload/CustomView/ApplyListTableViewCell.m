//
//  ApplyListTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import "ApplyListTableViewCell.h"

@implementation ApplyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_orderNumerLab release];
    [_orderTimeLab release];
    [_orderStatusLab release];
    [super dealloc];
}
@end
