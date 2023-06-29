//
//  ChangePassWordViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/22.
//
//

#import "BaseViewController.h"

@protocol ChangePassDelegate <NSObject>

- (void)changedSuccess ;

@end

@interface ChangePassWordViewController : BaseViewController<UITextFieldDelegate>


@property (assign, nonatomic) id<ChangePassDelegate> delegate ;
@property (assign, nonatomic) BOOL fromLogin ;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIScrollView *BGScroll;
@property (retain, nonatomic) IBOutlet UIView *firstBGView;
@property (retain, nonatomic) IBOutlet UITextField *firstTextField;
@property (retain, nonatomic) IBOutlet UIView *secondBGView;
@property (retain, nonatomic) IBOutlet UITextField *secondTextField;
@property (retain, nonatomic) IBOutlet UIView *thirdBGView;
@property (retain, nonatomic) IBOutlet UITextField *thirdTextField;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitAction:(id)sender;

@end
