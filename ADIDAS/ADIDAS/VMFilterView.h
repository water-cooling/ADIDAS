//
//  FilterView.h
//  ADIDAS
//
//  Created by wendy on 14-5-28.
//
//

#import <UIKit/UIKit.h>

@interface VMFilterView : UIView

@property (strong,nonatomic)  UIButton* totalScoreButton;
@property (strong,nonatomic)  UIButton* YButton;
@property (strong,nonatomic)  UIButton* NButton;
@property (strong,nonatomic)  UIButton* NAButton;

@property (strong,nonatomic) UILabel* countLabel;


-(void)AddActionToButtonWithView:(UIViewController*)view
                     and:(SEL)action1
                     and:(SEL)action2
                     and:(SEL)action3
                     and:(SEL)action4;





@end
