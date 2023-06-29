//
//  QLPreviewController+Title.m
//  ADIDAS
//
//  Created by wendy on 14-9-5.
//
//

#import "QLPreviewController+Title.h"

@implementation QLPreviewController (Title)



-(void)viewDidLoad
{
    [super viewDidLoad];
    UILabel* label= [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 44)]autorelease];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = self.title;
    self.navigationItem.titleView = label;
}

@end
