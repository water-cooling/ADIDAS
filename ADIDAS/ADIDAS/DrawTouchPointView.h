//
//  DrawTouchPointView.h
//  DrawTouchPointTest
//
//  Created by ethan on 11-10-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DrawTouchPointView : UIView {
	NSMutableArray *stroks;
	//weak
	CGMutablePathRef currentPath;
	BOOL isEarse;
    BOOL isInputView ;
}

@property (assign, nonatomic) BOOL isInputView ;
@property(nonatomic, assign) BOOL isEarse;
@property (assign,nonatomic) UIColor* PenColor;
@property (assign,nonatomic) int LineWidth;

- (void)clearStroks;

@end
