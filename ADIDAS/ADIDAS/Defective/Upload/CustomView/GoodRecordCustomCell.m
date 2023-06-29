//
//  GoodRecordCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "GoodRecordCustomCell.h"
#import "CommonUtil.h"

@implementation GoodRecordCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.createDateLabel.textColor = [CommonUtil colorWithHexString:@"#1d1e1f"];
    self.goodNumberLabel.textColor = [CommonUtil colorWithHexString:@"#1d1e1f"];
    self.sizeLabel.textColor = [CommonUtil colorWithHexString:@"#1d1e1f"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
