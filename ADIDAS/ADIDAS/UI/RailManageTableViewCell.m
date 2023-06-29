//
//  RailManageTableViewCell.m
//  ADIDAS
//
//  Created by wendy on 14-4-23.
//
//

#import "RailManageTableViewCell.h"
#define PHONEWIDTH  [UIScreen mainScreen].bounds.size.width

@implementation RailManageTableViewCell
@synthesize remark;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.issueLabel.frame = CGRectMake(40, 0, PHONEWIDTH-78, self.frame.size.height);
    self.scoreLabel.center = CGPointMake(PHONEWIDTH-35, self.frame.size.height/2);
    self.numLabel.center = CGPointMake(23, self.frame.size.height/2);
    self.lineimageview.frame = CGRectMake(12, self.frame.size.height-1, PHONEWIDTH-24, 1);
    self.arrowimageview.center = CGPointMake(PHONEWIDTH-20, self.frame.size.height/2);
    
//    NSLog(@"%@",self);
}


-(void)configCellHeight:(NSString*) str
{
    self.issueLabel.frame = CGRectMake(40, 0, PHONEWIDTH-78, 10000);
    self.issueLabel.numberOfLines = 0;
    self.issueLabel.text = str;
    [self.issueLabel sizeToFit];
}


@end
