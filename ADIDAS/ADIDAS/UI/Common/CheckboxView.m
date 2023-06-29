//
//  CheckboxView.m
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckboxView.h"


@implementation CheckboxView
//@synthesize m_delegate;
@synthesize btnChecked;

-(CheckboxView *)initCheckboxView:(id)delegate frame:(CGRect)frame currSelValue:(NSInteger)currSelValue{
    self = [super init];
    if(self)
    {
        [self setFrame:frame];
        m_delegate = delegate;
        currSelectValue = currSelValue;
        btnChecked =[[UIButton alloc] init];
        
        UIImage *btnImg;
        if(currSelectValue ==0)
        {
            btnImg = [UIImage imageNamed:@"r_off.png"];
            [btnChecked setFrame:CGRectMake(0, 0, 35, 35)];
        }
        else
        {
            btnImg = [UIImage imageNamed:@"r_on.png"];
            [btnChecked setFrame:CGRectMake(0, 0, 35, 35)];
        }
        [btnChecked setBackgroundImage:btnImg forState:UIControlStateNormal]; 
        [btnChecked addTarget:self action:@selector(btnClidk:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnChecked];
    }
    return self;
}

-(IBAction)btnClidk:(id)sender
{
    if(currSelectValue ==0)
    {
        currSelectValue=1;
        [btnChecked setFrame:CGRectMake(0, 0, 35, 35)];
        [btnChecked setBackgroundImage:[UIImage imageNamed:@"r_on.png"] forState:UIControlStateNormal]; 
    }
    else
    {
        currSelectValue=0;
       [btnChecked setFrame:CGRectMake(0, 0, 35, 35)];
        [btnChecked setBackgroundImage:[UIImage imageNamed:@"r_off.png"] forState:UIControlStateNormal]; 
    }
    [m_delegate myCheckboxSelectIndex:self selectValue:currSelectValue];
}

-(void)dealloc
{    
    m_delegate=nil;
    [btnChecked release];
//    [m_delegate release];
    [super dealloc];
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
