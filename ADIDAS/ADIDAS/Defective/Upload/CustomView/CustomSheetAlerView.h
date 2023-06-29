//
//  CustomSheetAlerView.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/2.
//

#import <UIKit/UIKit.h>

typedef void(^chooseBlock) (NSInteger index);

@interface CustomSheetAlerView : UIView
 
-(id)initWithList:(NSArray *)list title:(NSString *) title;
-(void)showInView:(UIViewController *)controller;
@property (nonatomic,copy)chooseBlock block;
- (void)showInView:(UIViewController *)controller;

@end
