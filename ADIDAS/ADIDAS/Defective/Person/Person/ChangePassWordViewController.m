//
//  ChangePassWordViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/22.
//
//

#import "ChangePassWordViewController.h"

@interface ChangePassWordViewController ()

@end

@implementation ChangePassWordViewController

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
    
    self.navigationItem.title = @"修改密码" ;
    
    self.firstTextField.delegate = self ;
    self.secondTextField.delegate = self ;
    self.thirdTextField.delegate = self ;
    
    self.firstBGView.layer.cornerRadius = 4 ;
    self.firstBGView.layer.masksToBounds = YES ;
    
    self.secondBGView.layer.cornerRadius = 4 ;
    self.secondBGView.layer.masksToBounds = YES ;
    
    self.thirdBGView.layer.cornerRadius = 4 ;
    self.thirdBGView.layer.masksToBounds = YES ;
    
    [self.submitButton setTitleColor:[CommonUtil colorWithHexString:@"#1973ba"] forState:UIControlStateNormal] ;
    self.submitButton.layer.borderColor = [[CommonUtil colorWithHexString:@"#1973ba"] CGColor];
    self.submitButton.layer.borderWidth = 1 ;
    self.submitButton.layer.cornerRadius = 3 ;
    self.submitButton.layer.masksToBounds = YES ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
     [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return NO ;
}

- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect keyboardBounds =
    [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     CGRectValue];
    NSNumber *duration =
    [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve =
    [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGSize contentSize = self.BGScroll.contentSize;
    contentSize.height =
    self.contentView.frame.origin.y + self.contentView.frame.size.height + 10.0 +
    keyboardBounds.size.height;
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         self.BGScroll.contentSize = contentSize;
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    NSNumber *duration =
    [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve =
    [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGSize contentSize = self.BGScroll.contentSize;
    contentSize.height =
    self.contentView.frame.origin.y + self.contentView.frame.size.height + 10.0;
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         self.BGScroll.contentSize = contentSize;
                     }
                     completion:nil];
}

- (void)dealloc {
    
    [_submitButton release];
    [super dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)submitAction:(id)sender {
    
    if ([self.secondTextField.text isEqualToString:@""]||
        [self.firstTextField.text isEqualToString:@""]||
        [self.thirdTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入完全!"] ;
        
        return ;
    }
    
    if (![self.secondTextField.text isEqualToString:self.thirdTextField.text]) {
        
        [self showAlertWithDispear:@"新密码输入不一致!"] ;
        
        return ;
    }
    
    [self.firstTextField resignFirstResponder];
    [self.secondTextField resignFirstResponder];
    [self.thirdTextField resignFirstResponder];
    
    [self ShowSVProgressHUD];
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token,@"Password":self.secondTextField.text,@"HistoryPassword":self.firstTextField.text};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@ChangePwd",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        
        [self DismissSVProgressHUD];
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            [self showAlertWithDispear:@"操作成功!"];
            if (self.fromLogin&&self.delegate) [self.delegate changedSuccess] ;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
            
            if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                [ud synchronize];
                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
}


@end




