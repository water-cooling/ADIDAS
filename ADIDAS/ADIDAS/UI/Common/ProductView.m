//
//  DropDownView.m
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ProductView.h"
#import "ListItemEntity.h"
#import "Utilities.h"
#import "CommonUtil.h"

@implementation ProductView


-(ProductView *)initProductView:(id)delegate 
                          title:(NSString*)title 
                   currSelValue:(IssueProductEntity*)currSelValue
{
    self = [super init];
    if(self)
    {
        m_delegate = delegate;
        _currProduct = currSelValue;
        
        // Initialization code
        self.frame = CGRectMake(0, 0, 320, 480);
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
//        bgView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg.png"]];
        bgView.alpha =0.7;
        [self addSubview:bgView];
        [bgView release];

        UIView *showView = [[UIView alloc] initWithFrame: CGRectMake(20, 20, PHONE_WIDTH-40, 280)];
        showView.center = self.center;

        //图片信息
        UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 34)];
        titleImageView.contentMode =UIViewContentModeScaleToFill;
        titleImageView.image =[UIImage imageNamed:@"alert_bg3.png"];
        titleImageView.alpha=0.8;
        [showView addSubview:titleImageView];
        [titleImageView release];
        
        //图片信息
        UIImageView *alertbgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 34, 280, 246)];
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
        [labTitle release];
        
        UIView *inputView = [[UIView alloc] initWithFrame: CGRectMake(10, 45, 260, 160)];
        inputView.backgroundColor =[UIColor whiteColor];
        //产品型号
        UILabel * lblProdCode =[[UILabel alloc] initWithFrame:CGRectMake(10,10, 70, 30)];
        lblProdCode.textAlignment = UITextAlignmentLeft;
        lblProdCode.font = [UIFont boldSystemFontOfSize:15];
        lblProdCode.textColor = [Utilities GetCommomLableColor];    
        lblProdCode.backgroundColor = [UIColor clearColor];
        lblProdCode.text=NSLocalizedString(@"lblProdCodeText", nil);
        [inputView addSubview:lblProdCode];
        [lblProdCode release];
        
        txtProdCode = [[UITextField alloc] initWithFrame:CGRectMake(80,10, 160, 30)];
        txtProdCode.font = [UIFont systemFontOfSize:15];
        txtProdCode.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        txtProdCode.returnKeyType = UIReturnKeyDone;
        txtProdCode.delegate=self;
        txtProdCode.borderStyle= UITextBorderStyleRoundedRect;
        [inputView addSubview:txtProdCode];
        [txtProdCode release];
        
        //产品尺码
        UILabel * lblProdSize =[[UILabel alloc] initWithFrame:CGRectMake(10,50, 70, 30)];
        lblProdSize.textAlignment = UITextAlignmentLeft;
        lblProdSize.font = [UIFont boldSystemFontOfSize:15];
        lblProdSize.textColor = [Utilities GetCommomLableColor];    
        lblProdSize.backgroundColor = [UIColor clearColor];
        lblProdSize.text=NSLocalizedString(@"lblProdSizeText", nil);
        
        [inputView addSubview:lblProdSize];
        [lblProdSize release];
        
        txtProdSize = [[UITextField alloc] initWithFrame:CGRectMake(80,50, 160, 30)];
        txtProdSize.font = [UIFont systemFontOfSize:15];
        txtProdSize.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        txtProdSize.returnKeyType = UIReturnKeyDone;
        txtProdSize.delegate=self;
        txtProdSize.borderStyle= UITextBorderStyleRoundedRect;
        [inputView addSubview:txtProdSize];
        [txtProdSize release];
        
        //产品型号
        UILabel * lblProdName =[[UILabel alloc] initWithFrame:CGRectMake(10,90, 70, 30)];
        lblProdName.textAlignment = UITextAlignmentLeft;
        lblProdName.font = [UIFont boldSystemFontOfSize:15];
        lblProdName.textColor = [Utilities GetCommomLableColor];    
        lblProdName.backgroundColor = [UIColor clearColor];
        lblProdName.text=NSLocalizedString(@"lblProdNameText", nil);
        
        [inputView addSubview:lblProdName];
        [lblProdName release];
        
        txtProdName = [[UITextField alloc] initWithFrame:CGRectMake(80,90, 160, 30)];
        txtProdName.font = [UIFont systemFontOfSize:15];
        txtProdName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        txtProdName.returnKeyType = UIReturnKeyDone;
        txtProdName.delegate=self;
        txtProdName.borderStyle= UITextBorderStyleRoundedRect;
        [inputView addSubview:txtProdName];
        [txtProdName release];
        
        [showView addSubview:inputView];    
        [inputView release];
        
        //btn OK
        UIButton *btnOK =[[UIButton alloc] initWithFrame:CGRectMake(5, 230, 86, 40)];
        btnOK.alpha=0.8;
        [btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnOK setBackgroundImage:[UIImage imageNamed:@"alert_btn.png"] forState:UIControlStateNormal];        
        [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:btnOK];
        [btnOK release];
        
        UILabel *labbtnOK = [[UILabel alloc] initWithFrame:CGRectMake(5, 230, 86, 40)];
        labbtnOK.textAlignment = UITextAlignmentCenter;
        labbtnOK.backgroundColor = [UIColor clearColor];
        labbtnOK.font = [UIFont boldSystemFontOfSize:18.0];
        labbtnOK.textColor=[Utilities GetWhiteLableColor];
        labbtnOK.text =NSLocalizedString(@"btnOKText", nil);
        
        //添加阴影
        labbtnOK.shadowColor = [UIColor blackColor];
        labbtnOK.shadowOffset = CGSizeMake(0, -1.0);
        
        [showView addSubview:labbtnOK];
        [labbtnOK release];

        //btn Cancel
        UIButton *btnCancel =[[UIButton alloc] initWithFrame:CGRectMake(97, 230, 86, 40)];
        btnCancel.alpha=0.8;
        [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"alert_btn.png"] forState:UIControlStateNormal];        
        [btnCancel addTarget:self action:@selector(btnCancerClidk:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:btnCancel];
        [btnCancel release];
        
        UILabel *labbtnCancel = [[UILabel alloc] initWithFrame:CGRectMake(97, 230, 86, 40)];
        labbtnCancel.textAlignment = UITextAlignmentCenter;
        labbtnCancel.backgroundColor = [UIColor clearColor];
        labbtnCancel.font = [UIFont boldSystemFontOfSize:18.0];
        //添加阴影
        labbtnCancel.shadowColor = [UIColor blackColor];
        labbtnCancel.shadowOffset = CGSizeMake(0, -1.0);
        labbtnCancel.textColor=[Utilities GetWhiteLableColor];
        labbtnCancel.text =NSLocalizedString(@"btnCancelText", nil);
        
        [showView addSubview:labbtnCancel];
        [labbtnCancel release];
        
        //btn Del
        UIButton *btnDel =[[UIButton alloc] initWithFrame:CGRectMake(189, 230, 86, 40)];
        btnDel.alpha=0.8;
        [btnDel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnDel setBackgroundImage:[UIImage imageNamed:@"alert_btn.png"] forState:UIControlStateNormal];        
        [btnDel addTarget:self action:@selector(btnDeleteClidk:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:btnDel];
        [btnDel release];
        
        UILabel *labbtnDel = [[UILabel alloc] initWithFrame:CGRectMake(189, 230, 86, 40)];
        labbtnDel.textAlignment = UITextAlignmentCenter;
        labbtnDel.backgroundColor = [UIColor clearColor];
        labbtnDel.font = [UIFont boldSystemFontOfSize:18.0];
        labbtnDel.textColor=[Utilities GetWhiteLableColor];
        labbtnDel.text =NSLocalizedString(@"btnDeleteText", nil);
        //添加阴影
        labbtnDel.shadowColor = [UIColor blackColor];
        labbtnDel.shadowOffset = CGSizeMake(0, -1.0);
        [showView addSubview:labbtnDel];
        [labbtnDel release];

        if(currSelValue !=nil)
        {
            txtProdCode.text = currSelValue.prodCode;
            txtProdSize.text = currSelValue.prodSize;
            txtProdName.text = currSelValue.prodName;
        }
        else
        {
            btnDel.enabled=FALSE;
            labbtnDel.alpha=0.5;
        }

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
        

        [showView release];
    }
    return self;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //    CGRect Frame = CGRectMake (0, 0, 320, 416);
    //    [self.view setFrame: Frame];
    
    [textField resignFirstResponder];
    return TRUE;
}

-(IBAction)btnOKClick:(id)sender
{
    if(txtProdCode.text.length<=0 ||txtProdName.text.length<=0 || txtProdSize.text.length<=0)
    {
        [Utilities alertMessage:NSLocalizedString(@"msgPageEmptyError", nil)];
        return;
    }
    
    IssueProductEntity* addProd =[[[IssueProductEntity alloc]init] autorelease];
    addProd.prodCode =txtProdCode.text;
    addProd.prodName =txtProdName.text;
    addProd.prodSize =txtProdSize.text;
    
   [m_delegate myProductViewSubmit:self selectEntity:addProd deleEntity:_currProduct isDelected:NO];
}

-(IBAction)btnCancerClidk:(id)sender
{
    [m_delegate myProductViewSubmit:self selectEntity:nil deleEntity:nil isDelected:NO];
}

-(IBAction)btnDeleteClidk:(id)sender
{
    [m_delegate myProductViewSubmit:self selectEntity:nil deleEntity:_currProduct isDelected:YES];
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

-(void)dealloc
{
     m_delegate=nil;
    [super dealloc];
}




@end
