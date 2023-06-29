//
//  DropDownView.m
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DropDownView.h"
#import "ListItemEntity.h"
#import "Utilities.h"
#import "CommonUtil.h"

@implementation DropDownView
@synthesize popDatasource;
@synthesize popTableView;
@synthesize m_delegate;


-(DropDownView *)initDropView:(id)delegate 
                        title:(NSString*)title 
                    listArray:(NSMutableArray*)listArray 
                 currSelValue:(ListItemEntity *)currSelValue
                    deleIndex:(NSInteger)deleIndex
{
    self = [super init];
    if(self)
    {
        self.m_delegate = delegate;
        self.popDatasource =listArray;
        _deleIndex=deleIndex;
        _currSelValue=currSelValue;
        
        // Initialization code
        self.frame = CGRectMake(0, 0, PHONE_WIDTH, 480);
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
//        bgView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg.png"]];
        bgView.alpha =0.7;
        [self addSubview:bgView];
        [bgView release];
        
        UIView *showView = [[UIView alloc] initWithFrame: CGRectMake(20, 80, 280, 340)];
        showView.center = self.center;
        
        //图片信息
        UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 34)];
        titleImageView.contentMode =UIViewContentModeScaleToFill;
        titleImageView.image =[UIImage imageNamed:@"alert_bg3.png"];
        titleImageView.alpha=0.8;
        [showView addSubview:titleImageView];
        [titleImageView release];
        
        //图片信息
        UIImageView *alertbgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 34, 280, 306)];
        alertbgImageView.contentMode =UIViewContentModeScaleToFill;
        alertbgImageView.image =[UIImage imageNamed:@"alert_bg4.jpg"];
        alertbgImageView.alpha=0.8;
        [showView addSubview:alertbgImageView];
        [alertbgImageView release];

        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 280, 25)];
        labTitle.textAlignment = UITextAlignmentCenter;
        labTitle.backgroundColor = [UIColor clearColor];
        labTitle.font = [UIFont boldSystemFontOfSize:20];
        labTitle.textColor=[Utilities GetWhiteLableColor];
        labTitle.text = title;
        //添加阴影
        labTitle.shadowColor = [UIColor blackColor];
        labTitle.shadowOffset = CGSizeMake(0, -1.0);
        [showView addSubview:labTitle];
        
        // 添加一个tableView
		popTableView = [[UITableView alloc] initWithFrame: CGRectMake(10, 45, 260, 235)];
		popTableView.delegate = self;
		popTableView.dataSource = self;
        
        if(currSelValue !=nil)
        {
            NSInteger selectedIndex = [popDatasource indexOfObject:currSelValue];
            //自动翻滚到某一行
            [popTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] 
                                      animated:NO scrollPosition:UITableViewScrollPositionMiddle];  
        }
        
        [showView addSubview:popTableView];
        [popTableView release];

        
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(10, 295, 260, 40)];
        btn.alpha=0.8;
        [btn setBackgroundImage:[UIImage imageNamed:@"alert_btn.png"] forState:UIControlStateNormal];        
        [btn addTarget:self action:@selector(btnClidk:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:btn];
        [btn release];
        
        UILabel *labbtn = [[UILabel alloc] initWithFrame:CGRectMake(10, 295, 260, 40)];
        labbtn.textAlignment = UITextAlignmentCenter;
        labbtn.backgroundColor = [UIColor clearColor];
        labbtn.font = [UIFont boldSystemFontOfSize:18.0];
        labbtn.textColor=[Utilities GetWhiteLableColor];
        labbtn.text =NSLocalizedString(@"btnCancelText", nil);
        //添加阴影
        labbtn.shadowColor = [UIColor blackColor];
        labbtn.shadowOffset = CGSizeMake(0, -1.0);
        
        [showView addSubview:labbtn];
        [labbtn release];


        showView.layer.cornerRadius = 8;
        showView.layer.borderWidth = 2;
        showView.layer.borderColor = [UIColor whiteColor].CGColor;
        showView.layer.masksToBounds = YES;
        
        CAKeyframeAnimation * animation; 
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"]; 
        animation.duration = 0.3; 
        animation.delegate = self;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
  
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]]; 
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]]; 
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]]; 
        
        animation.values = values;
        [showView.layer addAnimation:animation forKey:nil];
        


        [self addSubview:showView];
        
        [labTitle release];
        [showView release];
    }
    return self;
}

-(IBAction)btnClidk:(id)sender
{
    [m_delegate myDropDownSelectIndex:self selectEntity:_currSelValue deleIndex:_deleIndex];
}

-(void)dismissMyAlertView
{
    [UIView beginAnimations:@"hidden" context:nil];
    self.alpha = 0;
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self removeFromSuperview];
}


#pragma mark table data source delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	int n = [popDatasource count];
	return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ListCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    ListItemEntity *ent =[popDatasource objectAtIndex:indexPath.row];
	cell.textLabel.text = ent.itemName;
    
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.textLabel.textColor = [Utilities GetGridTitleColor];
    
	return cell;
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 35.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 点击使alertView消失
	ListItemEntity *ent = [popDatasource objectAtIndex:indexPath.row];
    [m_delegate myDropDownSelectIndex:self selectEntity:ent deleIndex:_deleIndex];
}

-(void)dealloc
{
    [popDatasource release];
    m_delegate=nil;
    [popTableView release];
    [super dealloc];
}




@end
