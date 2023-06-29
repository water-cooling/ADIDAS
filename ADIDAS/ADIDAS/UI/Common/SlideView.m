//
//  FirstViewController.m
//  SlideTest
//
//  Created by testing on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SlideView.h"
#import "CommonUtil.h"

@interface SlideView()

- (void) setGradientLocations:(CGFloat)leftEdge;
- (void) startTimer;
- (void) stopTimer;

@end

static const CGFloat gradientWidth = 0.2;
static const CGFloat gradientDimAlpha = 0.5;
static const int animationFramesPerSec = 8;


@implementation SlideView
@synthesize delegate;
@synthesize label;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Load the track background
	UIImage *trackImage = [UIImage imageNamed:@"sliderTrack.png"];
	sliderBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, PHONE_WIDTH, 95)];
    sliderBackground.image = trackImage;
    
    [sliderBackground setAlpha:0.9];

    UIView *slideView = [[UIView alloc] initWithFrame:sliderBackground.frame];
	[slideView addSubview:sliderBackground];
    //    [sliderBackground release];
    
    // Add the slider with correct geometry centered over the track
	slider = [[UISlider alloc] initWithFrame:sliderBackground.frame];
	CGRect sliderFrame = slider.frame;
	sliderFrame.size.width -= 46; //each "edge" of the track is 23 pixels wide
	slider.frame = sliderFrame;
	slider.center = sliderBackground.center;
	slider.backgroundColor = [UIColor clearColor];
	[slider setMinimumTrackImage:[UIImage imageNamed:@"sliderMaxMin-02.png"] forState:UIControlStateNormal];
	[slider setMaximumTrackImage:[UIImage imageNamed:@"sliderMaxMin-02.png"] forState:UIControlStateNormal];
	UIImage *thumbImage = [UIImage imageNamed:@"sliderThumb.png"];
	[slider setThumbImage:thumbImage forState:UIControlStateNormal];
	slider.minimumValue = 0.0;
	slider.maximumValue = 1.0;
	slider.continuous = YES;
	slider.value = 0.0;
    
	// Set the slider action methods
	[slider addTarget:self 
			   action:@selector(sliderUp:) 
	 forControlEvents:UIControlEventTouchUpInside];
	[slider addTarget:self 
			   action:@selector(sliderDown:) 
	 forControlEvents:UIControlEventTouchDown];
	[slider addTarget:self 
			   action:@selector(sliderChanged:) 
	 forControlEvents:UIControlEventValueChanged];
    
	// Create the label with the actual size required by the text
	// If you change the text, font, or font size by using the "label" property,
	// you may need to recalculate the label's frame.
	NSString *labelText =  NSLocalizedString(@"lblCheckInText", @"slide to cancel");
	UIFont *labelFont = [UIFont systemFontOfSize:24];
	CGSize labelSize = [labelText sizeWithFont:labelFont];
	label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, labelSize.width, labelSize.height)];
	
	// Center the label over the slidable portion of the track
	CGFloat labelHorizontalCenter = slider.center.x + (thumbImage.size.width / 2);
	label.center = CGPointMake(labelHorizontalCenter, slider.center.y);
	
	// Set other label attributes and add it to the view
	label.textColor = [UIColor whiteColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.font = labelFont;
	label.text = labelText;
    label.layer.delegate=self;
	[slideView addSubview:label];
	[slideView addSubview:slider];
    //    [slider release];
    //    [label release];
    
	[self.view addSubview:slideView];
	
    [slideView release];
    self.view.frame =sliderBackground.frame;
    
    //开启动画
    [self setSlideRestart];
}

- (void) setSlideRestart
{
    slider.value = 0.0;
    label.alpha = 1.0;
    touchIsDown = NO;
    [self startTimer];
}


// UISlider actions
- (void) sliderUp: (UISlider *) sender
{
	//filter out duplicate sliderUp events
	if (touchIsDown) {
		touchIsDown = NO;
		
		if (slider.value != 1.0)  //if the value is not the max, slide this bad boy back to zero
		{
			[slider setValue: 0 animated: YES];
			label.alpha = 1.0;
			[self startTimer];
		}
		else {
			//tell the delagate we are slid all the way to the right
			[delegate cancelledAction];
		}
	}
}

- (void) sliderDown: (UISlider *) sender
{
	touchIsDown = YES;
}

- (void) sliderChanged: (UISlider *) sender
{
	// Fade the text as the slider moves to the right. This code makes the
	// text totally dissapear when the slider is 35% of the way to the right.
	label.alpha = MAX(0.0, 1.0 - (slider.value * 3.5));
	
	// Stop the animation if the slider moved off the zero point
	if (slider.value != 0) {
		[self stopTimer];
		[label.layer setNeedsDisplay];
	}
}

// animationTimer methods
- (void)animationTimerFired:(NSTimer*)theTimer {
	// Let the timer run for 2 * FPS rate before resetting.
	// This gives one second of sliding the highlight off to the right, plus one
	// additional second of uniform dimness
	if (++animationTimerCount == (2 * animationFramesPerSec)) {
		animationTimerCount = 0;
	}
	
	// Update the gradient for the next frame
	[self setGradientLocations:((CGFloat)animationTimerCount/(CGFloat)animationFramesPerSec)];
}

- (void) startTimer {
	if (!animationTimer) {
		animationTimerCount = 0;
		[self setGradientLocations:0];
		animationTimer = [[NSTimer 
						   scheduledTimerWithTimeInterval:1.0/animationFramesPerSec 
						   target:self 
						   selector:@selector(animationTimerFired:) 
						   userInfo:nil 
						   repeats:YES] retain];
	}
}

- (void) stopTimer {
	if (animationTimer) {
		[animationTimer invalidate];
		[animationTimer release], animationTimer = nil;
	}
}

// label's layer delegate method


-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)theContext
{
    // Set the font
	const char *labelFontName = [label.font.fontName UTF8String];
	
	// Note: due to use of kCGEncodingMacRoman, this code only works with Roman alphabets! 
	// In order to support non-Roman alphabets, you need to add code generate glyphs,
	// and use CGContextShowGlyphsAtPoint
	CGContextSelectFont(theContext, labelFontName, label.font.pointSize, kCGEncodingMacRoman);
    
	// Set Text Matrix
	CGAffineTransform xform = CGAffineTransformMake(1.0,  0.0,
													0.0, -1.0,
													0.0,  0.0);
	CGContextSetTextMatrix(theContext, xform);
	
	// Set Drawing Mode to clipping path, to clip the gradient created below
	CGContextSetTextDrawingMode (theContext, kCGTextClip);
	
	// Draw the label's text
    
    
	const char *text = [label.text cStringUsingEncoding:NSMacOSRomanStringEncoding];
	CGContextShowTextAtPoint(
                             theContext, 
                             0, 
                             (size_t)label.font.ascender,
                             text, 
                             strlen(text));

	// Calculate text width
	CGPoint textEnd = CGContextGetTextPosition(theContext);

	// Get the foreground text color from the UILabel.
	// Note: UIColor color space may be either monochrome or RGB.
	// If monochrome, there are 2 components, including alpha.
	// If RGB, there are 4 components, including alpha.
	CGColorRef textColor = label.textColor.CGColor;
	const CGFloat *components = CGColorGetComponents(textColor);
	size_t numberOfComponents = CGColorGetNumberOfComponents(textColor);
	BOOL isRGB = (numberOfComponents == 4);
	CGFloat red = components[0];
	CGFloat green = isRGB ? components[1] : components[0];
	CGFloat blue = isRGB ? components[2] : components[0];
	CGFloat alpha = isRGB ? components[3] : components[1];
    
	// The gradient has 4 sections, whose relative positions are defined by
	// the "gradientLocations" array:
	// 1) from 0.0 to gradientLocations[0] (dim)
	// 2) from gradientLocations[0] to gradientLocations[1] (increasing brightness)
	// 3) from gradientLocations[1] to gradientLocations[2] (decreasing brightness)
	// 4) from gradientLocations[3] to 1.0 (dim)
	size_t num_locations = 3;
	
	// The gradientComponents array is a 4 x 3 matrix. Each row of the matrix
	// defines the R, G, B, and alpha values to be used by the corresponding
	// element of the gradientLocations array
	CGFloat gradientComponents[12];
	for (int row = 0; row < num_locations; row++) {
		int index = 4 * row;
		gradientComponents[index++] = red;
		gradientComponents[index++] = green;
		gradientComponents[index++] = blue;
		gradientComponents[index] = alpha * gradientDimAlpha;
	}
    
	// If animating, set the center of the gradient to be bright (maximum alpha)
	// Otherwise it stays dim (as set above) leaving the text at uniform
	// dim brightness
	if (animationTimer) {
		gradientComponents[7] = alpha;
	}
    
	// Load RGB Colorspace
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	
	// Create Gradient
	CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents,
																  gradientLocations, num_locations);
	// Draw the gradient (using label text as the clipping path)
	CGContextDrawLinearGradient (theContext, gradient, label.bounds.origin, textEnd, 0);
	
	// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorspace);
    
}


- (void) setGradientLocations:(CGFloat) leftEdge {
	// Subtract the gradient width to start the animation with the brightest 
	// part (center) of the gradient at left edge of the label text
	leftEdge -= gradientWidth;
	
	//position the bright segment of the gradient, keeping all segments within the range 0..1
	gradientLocations[0] = leftEdge < 0.0 ? 0.0 : (leftEdge > 1.0 ? 1.0 : leftEdge);
	gradientLocations[1] = MIN(leftEdge + gradientWidth, 1.0);
	gradientLocations[2] = MIN(gradientLocations[1] + gradientWidth, 1.0);
	
	// Re-render the label text
	[label.layer setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self stopTimer];
	[sliderBackground release], 
    sliderBackground = nil;
	[slider release];
    slider = nil;
	[label release];
    label = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[self stopTimer];
    delegate=nil;
//	[self viewDidUnload];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
