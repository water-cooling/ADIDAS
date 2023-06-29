//
//  TapLongPressImageView.m
//  ADIDAS
//
//  Created by wendy on 14-5-21.
//
//

#import "TapLongPressImageView.h"

@implementation TapLongPressImageView

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
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePic)];
    tap.cancelsTouchesInView = YES;
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deletePic)];
    [longPress setMinimumPressDuration:0.5];
    [self addGestureRecognizer:longPress];
//
}

-(void)takePic
{
    [self.delegate takePic:self];
}

-(void)deletePic
{
    [self.delegate deletePic:[self.gestureRecognizers objectAtIndex:1]];
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
