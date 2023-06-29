//
//  ScoreCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2021/4/14.
//

#import "ScoreCustomCell.h"

@implementation ScoreCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)naAction:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectTableWith:withResult:)]) {
        [self.delegate selectTableWith:self.idx withResult:@"NA"];
    }
}

- (IBAction)yesAction:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectTableWith:withResult:)]) {
        [self.delegate selectTableWith:self.idx withResult:@"Y"];
    }
}

- (IBAction)noAction:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectTableWith:withResult:)]) {
        [self.delegate selectTableWith:self.idx withResult:@"N"];
    }
}


@end
