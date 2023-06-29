//
//  ExpressInfoViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/10/31.
//

#import "BaseViewController.h"

@protocol SubmitExpressDelegate <NSObject>

@optional
- (void) submitExpress:(NSDictionary *)express caseDic:(NSDictionary *)caseDic ;

@end

@interface ExpressInfoViewController : BaseViewController

@property (retain, nonatomic) IBOutlet UIView *expressView;
- (IBAction)dismissAction:(id)sender;
@property (assign, nonatomic) id<SubmitExpressDelegate> delegate ;
@property (strong, nonatomic) NSDictionary *express ;
@property (strong, nonatomic) NSDictionary *caseDic ;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;
@property (retain, nonatomic) IBOutlet UITextField *companyTextField;
@property (retain, nonatomic) IBOutlet UITextField *numberTextField;

- (IBAction)closePageAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)confirmAction:(id)sender;

@end
