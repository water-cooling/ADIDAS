//
//  CommonTestController.h
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import "StoreManagement.h"
#import "ListItemEntity.h"
#import "CheckboxView.h"

@interface CommonTestController : UIViewController<DropDownViewDelegate,CheckboxViewDelegate>
{
    NSMutableArray * cityList;
    StoreManagement *_management;
    ListItemEntity * currCity;
    
    CheckboxView *checkBox;
    NSInteger currCheckValue;
}
@property (nonatomic, retain) NSMutableArray * cityList;


- (IBAction)selectEvent:(id)sender;

@end
