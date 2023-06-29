//
//  LargeImageView.m
//  ADIDAS
//
//  Created by wendy on 14-5-21.
//
//

#import "LargeImageView.h"

@implementation LargeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddeSelf)];
    [self.imageview addGestureRecognizer:tap];
    self.progressview = [[DACircularProgressView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.progressview.center = CGPointMake(160, [UIScreen mainScreen].bounds.size.height/2);
    [self addSubview:self.progressview];
    [self updateProgress:0.1];
}

-(void)hiddeSelf
{
    [self.delegate Hidden];
}

-(void)updateProgress:(CGFloat)progress
{
    self.progressview.progress = progress;
    self.progressview.hidden = NO;
    if (progress >= 1.0f)
    {
        self.progressview.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
