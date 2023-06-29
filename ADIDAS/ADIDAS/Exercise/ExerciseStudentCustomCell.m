//
//  ExerciseStudentCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2019/10/28.
//

#import "ExerciseStudentCustomCell.h"

@implementation ExerciseStudentCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteAction:(id)sender {
    UIButton *btn = (UIButton *)sender ;
    [self.delegate deleteStucent:btn.tag];
}

@end
