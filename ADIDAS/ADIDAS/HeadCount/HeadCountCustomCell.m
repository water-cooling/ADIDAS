//
//  HeadCountCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import "HeadCountCustomCell.h"
#import "Utilities.h"

@implementation HeadCountCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftInputLabel.layer.cornerRadius = 4 ;
    self.leftInputLabel.layer.borderWidth = 1 ;
    self.leftInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#dddddd"] CGColor];
    self.rightInputLabel.layer.cornerRadius = 4 ;
    self.rightInputLabel.layer.borderWidth = 1 ;
    self.rightInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#dddddd"] CGColor];
    self.thirdInputLabel.layer.cornerRadius = 4 ;
    self.thirdInputLabel.layer.borderWidth = 1 ;
    self.thirdInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#dddddd"] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_leftTitleLabel release];
    [_rightTitleLabel release];
    [_leftInputLabel release];
    [_rightInputLabel release];
    [_leftStarLabel release];
    [_rightStarLabel release];
    [_bgImageView release];
    [_leftBtn release];
    [_rightBtn release];
    [_thirdStarLabel release];
    [_thirdBtn release];
    [_thirdTitleLabel release];
    [_thirdInputLabel release];
    [_rightImageView release];
    [super dealloc];
}


- (IBAction)tapAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender ;
    [self.delegate tapInputLabel:self.index labelType:(int)btn.tag];
}


@end
