//
//  DrawTouchPointView.m
//  DrawTouchPointTest
//
//  Created by ethan on 11-10-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawTouchPointView.h"
#import "DWStroke.h"

@implementation DrawTouchPointView

@synthesize isEarse;
@synthesize isInputView ;
@synthesize PenColor;
@synthesize LineWidth;

- (void)clearStroks {
    isInputView = NO ;
	[stroks release];
	stroks = [[NSMutableArray alloc] initWithCapacity:1];
	[self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	currentPath = CGPathCreateMutable();
	DWStroke *stroke = [[DWStroke alloc] init];
	stroke.path = currentPath;
	stroke.blendMode = isEarse ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
	stroke.strokeWidth = isEarse ? 20.0 : LineWidth;
	stroke.strokeColor = isEarse ? [[UIColor clearColor] CGColor] : PenColor.CGColor;
	[stroks addObject:stroke];
    [stroke release];
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGPathMoveToPoint(currentPath, NULL, point.x, point.y);
	
	CGPathRelease(currentPath);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isInputView = YES ;
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGPathAddLineToPoint(currentPath, NULL, point.x, point.y);
	[self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		stroks = [[NSMutableArray alloc] initWithCapacity:1];
        PenColor = [UIColor blackColor];
        LineWidth = 5;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();

	for (DWStroke *stroke in stroks) {
		[stroke strokeWithContext:context];
	}
}


- (void)dealloc {
	[stroks release];
    [super dealloc];
}


@end
