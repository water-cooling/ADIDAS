//
//  CommonTestController.m
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonTestController.h"
#import "DropDownView.h"
#import "StoreManagement.h"
#import "Utilities.h"

@implementation CommonTestController
@synthesize cityList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)createNavigationbar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationItem.title=@"User Controller Test";
    //--Back Button	
    UIButton *back =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[back addTarget:self action:@selector(backItemPressed:) forControlEvents:UIControlEventTouchUpInside];	
	[back setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
	[back setTitle:@"返回" forState:UIControlStateNormal];
	back.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
	back.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.leftBarButtonItem = backButtonItem;
	[back release];
	[backButtonItem release]; 
}

- (void)backItemPressed:(id)sender {	
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化
- (void)viewDidLoad
{
    [self createNavigationbar];
    [super viewDidLoad];
    _management = [[StoreManagement alloc] init]; 
//    self.cityList = [_management GetCityList];
    
    
    //初始化滑动条
    if (!checkBox) {
		// Create the slider
		checkBox = [[CheckboxView alloc ] initCheckboxView:self frame:CGRectMake(100, 200, 60, 60) currSelValue: currCheckValue];
		// Position the slider off the bottom of the view, so we can slide it up
		// Add slider to the view
		[self.view addSubview:checkBox];
	}
}

- (IBAction)selectEvent:(id)sender {
    DropDownView *alert =[[DropDownView alloc] 
                          initDropView:self              
                          title:@"请选择Item" 
                          listArray:cityList  
                          currSelValue:currCity 
                          deleIndex:0];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert release];
    [Utilities showWaiting];  
//    NSLog([NSString stringWithFormat:@"%d", currCheckValue]);

}

-(void) myDropDownSelectIndex:(DropDownView *)alertView selectEntity:(ListItemEntity *)selValue
{
    if(selValue !=nil)
    {
        currCity = selValue;
    }
    [alertView dismissMyAlertView];
//    NSLog(selValue);
}

-(void) myCheckboxSelectIndex:(CheckboxView *)alertView selectValue:(NSInteger)selValue
{
       currCheckValue = selValue;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCityList:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    [super dealloc];
    if(_management){
        [_management release];
        _management = nil;
    }
    if(currCity){
        [currCity release];
        currCity = nil;
    }
    if(checkBox){
        [checkBox release];
        checkBox = nil;
    }
    
    
    [cityList release];
}


@end
