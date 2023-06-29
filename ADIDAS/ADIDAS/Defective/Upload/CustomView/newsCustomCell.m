//
//  newsCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/16.
//
//

#import "newsCustomCell.h"
#import "CommonUtil.h"

@implementation newsCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgImageView.backgroundColor = [CommonUtil colorWithHexString:@"#dbdcdd"] ;
    self.newsLabel.textColor = [CommonUtil colorWithHexString:@"#1b1c1d"] ;
    self.dateLabel.textColor = [CommonUtil colorWithHexString:@"#636465"] ;
    
    self.newLabel.textColor = [CommonUtil colorWithHexString:@"#ed6c6f"] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
