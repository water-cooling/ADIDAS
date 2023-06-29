//
//  GoodDetailCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/16.
//
//

#import "GoodDetailCustomCell.h"
#import "CommonUtil.h"

@implementation GoodDetailCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodLabel.textColor = [CommonUtil colorWithHexString:@"#1d1e1f"];
    self.orderLabel.textColor = [CommonUtil colorWithHexString:@"#1d1e1f"];
    self.kindLabel.textColor = [CommonUtil colorWithHexString:@"#1d1e1f"];
    self.submitLabel.textColor = [CommonUtil colorWithHexString:@"#1d1e1f"];
    
    self.goodImageView.layer.cornerRadius = 2 ;
    self.goodImageView.layer.masksToBounds = YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
