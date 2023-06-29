//
//  UIUnderlinedButton.m
//  ADIDAS
//
//  Created by jerry lu on 8/20/12.
//  Copyright (c) 2012 joinonesoft. All rights reserved.
//

#import "UIUnderlinedButton.h"

@implementation UIUnderlinedButton

+ (UIUnderlinedButton*) underlinedButton {
    UIUnderlinedButton* button = [[UIUnderlinedButton alloc] init];
    return [button autorelease];
}

- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height+3 + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height+3 + descender);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
