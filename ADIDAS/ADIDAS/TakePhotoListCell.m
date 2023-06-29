//
//  TakePhotoListCell.m
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "TakePhotoListCell.h"

@implementation TakePhotoListCell


- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction) addNew:(id)sender
{
    [self.delegate addNew:self];
}


- (IBAction)leftAction:(id)sender {
    
    [self.delegate openCamera:self.indexType beforeafter:1];
}

- (IBAction)rightAction:(id)sender {
 
    [self.delegate openCamera:self.indexType beforeafter:2];
}

- (IBAction)leftDetailAction:(id)sender {
    
    [self.delegate showDetailImage:self.indexType beforeafter:1];
}

- (IBAction)rightDetailAction:(id)sender {
    
    [self.delegate showDetailImage:self.indexType beforeafter:2];
}


@end
