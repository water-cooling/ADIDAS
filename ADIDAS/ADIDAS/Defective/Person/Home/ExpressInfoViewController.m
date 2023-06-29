//
//  ExpressInfoViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/10/31.
//

#import "ExpressInfoViewController.h"

@interface ExpressInfoViewController ()<UITextFieldDelegate>

@end

@implementation ExpressInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.expressView.layer.cornerRadius = 6 ;
    self.expressView.layer.masksToBounds = YES ;


    [self.cancelBtn setBackgroundColor:[CommonUtil colorWithHexString:@"#eeeeee"]];
    [self.cancelBtn setTitleColor:[CommonUtil colorWithHexString:@"#ababab"] forState:UIControlStateNormal];
    self.cancelBtn.layer.cornerRadius = 5 ;
    self.confirmBtn.layer.cornerRadius = 5 ;
    [self.confirmBtn setTitleColor:[CommonUtil colorWithHexString:@"#1973ba"] forState:UIControlStateNormal];
    self.confirmBtn.layer.borderWidth = 1 ;
    self.confirmBtn.layer.borderColor = [CommonUtil colorWithHexString:@"#1973ba"].CGColor;
    self.confirmBtn.layer.masksToBounds = YES ;
    self.cancelBtn.layer.masksToBounds = YES ;
    
    self.numberTextField.backgroundColor = [CommonUtil colorWithHexString:@"#eeeeee"];
    self.numberTextField.layer.cornerRadius = 2 ;
    self.numberTextField.layer.masksToBounds = YES ;
    self.numberTextField.delegate = self ;
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    self.numberTextField.leftView = leftView1 ;
    self.numberTextField.leftViewMode = UITextFieldViewModeAlways;
    self.companyTextField.backgroundColor = [CommonUtil colorWithHexString:@"#eeeeee"];
    self.companyTextField.layer.cornerRadius = 2 ;
    self.companyTextField.layer.masksToBounds = YES ;
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    self.companyTextField.leftView = leftView2 ;
    self.companyTextField.leftViewMode = UITextFieldViewModeAlways;
    self.companyTextField.delegate = self ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.expressView.alpha = 1 ;
    } completion:^(BOOL finished) {
        [self.companyTextField becomeFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notif {
    
    NSNumber *duration =
    [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve =
    [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         
                         CGRect frame = self.expressView.frame ;
                         frame.origin.y = (DEHEIGHT- 219)/4.0;
                         self.expressView.frame = frame ;
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    NSNumber *duration =
    [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve =
    [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         self.expressView.center = self.view.center ;
                     }
                     completion:nil];
}

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)dismissAction:(id)sender {
    
    [self.companyTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.expressView.alpha = 0 ;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


- (IBAction)closePageAction:(id)sender {
    [self dismissAction:nil];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissAction:nil];
}

- (IBAction)confirmAction:(id)sender {
    [self.companyTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    
    if ([self.companyTextField.text isEqualToString:@""]||
        [[self.companyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self showAlertWithDispear:@"请输入物流公司名称"];
        return;
    }
    
    if ([self.numberTextField.text isEqualToString:@""]||
        [[self.numberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self showAlertWithDispear:@"请输入物流单号"];
        return;
    }
    
    if ([[self.companyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>4) {
        [self showAlertWithDispear:@"物流公司名称最多输入四个字"];
        return;
    }
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.expressView.alpha = 0 ;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.delegate submitExpress:@{@"ExpressName":[self.companyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],@"ExpressNumber":[self.numberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]} caseDic:self.caseDic];
    }];
}


@end
