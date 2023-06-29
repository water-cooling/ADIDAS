//
//  StoreListCell.m
//  ADIDAS
//
//  Created by wendy on 14-5-6.
//
//

#import "StoreListCell.h"

@implementation StoreListCell
@synthesize currentstore;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.remindRedPotLabel.layer.cornerRadius = 5 ;
    self.remindRedPotLabel.layer.masksToBounds = YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
