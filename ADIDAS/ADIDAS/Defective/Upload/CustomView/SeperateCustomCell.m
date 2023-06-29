//
//  SeperateCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/20.
//
//

#import "SeperateCustomCell.h"
#import "CommonUtil.h"


@implementation SeperateCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgLineLabel.backgroundColor = [UIColor whiteColor];
    self.dateLabel.backgroundColor = [CommonUtil colorWithHexString:@"#c8c7cc"];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.closeDateLabel.textColor = [UIColor blackColor];
    self.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (IBAction)closeAction:(id)sender {
    
    [self.delegate operateType:0 withIndex:self.index];
}

- (IBAction)openAction:(id)sender {
    
    [self.delegate operateType:1 withIndex:self.index];
}


@end
