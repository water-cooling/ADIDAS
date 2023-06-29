//
//  FeedBackCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/20.
//
//

#import "FeedBackCustomCell.h"
#import "CommonUtil.h"

@implementation FeedBackCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.feedContentTextView.textColor = [CommonUtil colorWithHexString:@"#cb2a37"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
