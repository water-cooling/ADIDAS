//
//  CampaignListCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2018/6/13.
//

#import "CampaignListCustomCell.h"

@implementation CampaignListCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_leftImageView release];
    [_detailLabel release];
    [_codeLabel release];
    [_statusImageView release];
    [_commentLabel release];
    [_photoLabel release];
    [_leftButton release];
    [super dealloc];
}


- (IBAction)detailImageView:(id)sender {
    
    UIButton *btn = (UIButton *)sender ;
    
    if (btn.tag == 10) [self.delegate openDetailImage:self.leftImageUrl];
}


@end
