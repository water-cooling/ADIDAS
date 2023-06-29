//
//  DetailAnswerTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/6.
//

#import "DetailAnswerTableViewCell.h"

@implementation DetailAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_textView release];
    [super dealloc];
}
@end
