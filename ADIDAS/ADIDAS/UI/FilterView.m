//
//  FilterView.m
//  ADIDAS
//
//  Created by wendy on 14-5-28.
//
//

#import "FilterView.h"
#import "AppDelegate.h"
#define PWIDTH  [UIScreen mainScreen].bounds.size.width

@implementation FilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
 

            self.YButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.YButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        self.YButton.frame = CGRectMake(28.0/320*PWIDTH, 7, 40, 25);
        self.YButton.tag = 1;
        self.YButton.titleLabel.textColor = [UIColor blackColor];
        self.YButton.tintColor = [UIColor blackColor];
        self.YButton.titleLabel.font = [UIFont systemFontOfSize:10];
        self.YButton.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
        
        [self addSubview:self.YButton];
        
 
        
            self.NButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.NButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.NButton.frame = CGRectMake(107.0/320*PWIDTH, 7, 40, 25);
        self.NButton.tag = 0;
        self.NButton.titleLabel.textColor = [UIColor blackColor];
        self.NButton.tintColor = [UIColor blackColor];
        self.NButton.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
        self.NButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.NButton];
        
  
     
            self.NAButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.NAButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.NAButton.frame = CGRectMake(193.0/320*PWIDTH, 7, 40, 25);
        self.NAButton.tag = 2;
        self.NAButton.titleLabel.textColor = [UIColor blackColor];
        self.NAButton.tintColor = [UIColor blackColor];
        self.NAButton.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
        self.NAButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.NAButton];
        
  
  
        self.totalScoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.totalScoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.totalScoreButton.frame = CGRectMake(280.0/320*PWIDTH, 7, 40, 25);
        self.totalScoreButton.tag = 3;
        self.totalScoreButton.titleLabel.textColor = [UIColor redColor];
        self.totalScoreButton.tintColor = [UIColor redColor];
        self.totalScoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
        self.totalScoreButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.totalScoreButton];
        
        UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WID, 40)];
        imageview.image = [UIImage imageNamed:@"filter.png"];
        if (SYSLanguage == EN) {
            imageview.image = [UIImage imageNamed:@"filter_en.png"];
        }
        [self addSubview:imageview];
        [self sendSubviewToBack:imageview];
        

    }
    return self;
}

-(void)AddActionToButtonWithView:(UIViewController *)view and:(SEL)action1 and:(SEL)action2 and:(SEL)action3 and:(SEL)action4
{
    [self.YButton addTarget:view action:action1 forControlEvents:UIControlEventTouchUpInside];
    [self.NButton addTarget:view action:action2 forControlEvents:UIControlEventTouchUpInside];
    [self.NAButton addTarget:view action:action3 forControlEvents:UIControlEventTouchUpInside];
    [self.totalScoreButton addTarget:view action:action4 forControlEvents:UIControlEventTouchUpInside];
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
