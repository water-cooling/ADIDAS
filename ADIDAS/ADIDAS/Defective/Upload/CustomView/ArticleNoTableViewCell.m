//
//  ArticleNoTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/4.
//

#import "ArticleNoTableViewCell.h"

@implementation ArticleNoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)moreAction:(id)sender {
    if (self.block) {
        self.block();
    }
}

-(void)setCreatTableModel:(CreatTableModel *)creatTableModel{
    _creatTableModel = creatTableModel;
    self.leftLab.text = _creatTableModel.title;
}

- (void)dealloc {
    [_rightLab release];
    [_leftLab release];
    [super dealloc];
}
@end
