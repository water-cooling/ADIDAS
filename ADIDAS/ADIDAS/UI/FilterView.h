//
//  FilterView.h
//  ADIDAS
//
//  Created by wendy on 14-5-28.
//
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView

@property (strong,nonatomic)  UIButton* totalScoreButton;
@property (strong,nonatomic)  UIButton* YButton;
@property (strong,nonatomic)  UIButton* NButton;
@property (strong,nonatomic)  UIButton* NAButton;

@property (strong,nonatomic) UILabel* label1;
@property (strong,nonatomic) UILabel* label2;
@property (strong,nonatomic) UILabel* label3;
@property (strong,nonatomic) UILabel* label4;

@property (strong,nonatomic) UIImageView* bgview1;
@property (strong,nonatomic) UIImageView* bgview2;
@property (strong,nonatomic) UIImageView* bgview3;
@property (strong,nonatomic) UIImageView* bgview4;

-(void)AddActionToButtonWithView:(UIViewController*)view
                     and:(SEL)action1
                     and:(SEL)action2
                     and:(SEL)action3
                     and:(SEL)action4;





@end
