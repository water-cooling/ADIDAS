//
//  SlideView.h
//  ADIDAS
//
//  Created by testing on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideToCancelDelegate;

@interface SlideView : UIViewController {
	UIImageView *sliderBackground;
	UISlider *slider;
	UILabel *label;
	NSTimer *animationTimer;
	id <SlideToCancelDelegate> delegate;
	BOOL touchIsDown;
	CGFloat gradientLocations[3];
	int animationTimerCount;
}

@property (nonatomic, assign) id <SlideToCancelDelegate> delegate;

// Access the UILabel, e.g. to change text or color
@property (nonatomic, readonly) UILabel *label;

- (void) setSlideRestart;
@end

@protocol SlideToCancelDelegate

@required
- (void) cancelledAction;

@end
