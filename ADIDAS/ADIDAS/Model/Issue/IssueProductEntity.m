//
//  IssueProductEntity.m
//  ADIDAS
//
//  Created by testing on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IssueProductEntity.h"

@implementation IssueProductEntity

@synthesize prodCode, prodName,prodSize;


- (void)dealloc {
    [prodCode release];
    [prodName release];
    [prodSize release];
    [super dealloc];
}
@end
