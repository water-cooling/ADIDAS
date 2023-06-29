//
//  CheckboxView.h
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckboxView;

@protocol CheckboxViewDelegate <NSObject>
@optional

-(void)myCheckboxSelectIndex:(CheckboxView*)alertView selectValue:(NSInteger)selValuet;

@end


@interface CheckboxView : UIView
{
    id<CheckboxViewDelegate>m_delegate;
    NSInteger currSelectValue;
    UIButton *btnChecked;
}
@property(nonatomic,retain) UIButton *btnChecked;

-(CheckboxView *)initCheckboxView:(id)delegate  frame:(CGRect)frame  currSelValue:(NSInteger)currSelValue;

//@property (nonatomic, assign) id<CheckboxViewDelegate>m_delegate;

@end
