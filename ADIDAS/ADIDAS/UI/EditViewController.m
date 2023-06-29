//
//  EditViewController.m
//  SuperviseClient
//
//  Created by 桂康 on 2017/3/2.
//  Copyright © 2017年 JoinOnesoft. All rights reserved.
//

#import "EditViewController.h"

# define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface EditViewController ()

@end

@implementation EditViewController

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
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    if ([self.type isEqualToString:@"0"]) {
    
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 20)];
        paddingView.backgroundColor = [UIColor clearColor];
        self.numberTextField.leftView = paddingView;
        self.numberTextField.leftViewMode = UITextFieldViewModeAlways;
        
        self.numberTextField.delegate = self ;
        self.wordView.hidden = YES ;
        if (self.textVal) self.numberTextField.text = self.textVal ;
    }
    
    else {
    
        self.wordTextView.delegate = self ;
        self.numberView.hidden = YES ;
        if (self.textVal) self.wordTextView.text = self.textVal ;
    }
    
    self.wordTextView.backgroundColor = [CommonUtil colorWithHexString:@"#e9e9e9"];
    self.numberTextField.backgroundColor = [CommonUtil colorWithHexString:@"#e9e9e9"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder] ;
    [UIView animateWithDuration:0.0 animations:^{
        
        CGRect frame = self.numberView.frame ;
        frame.origin.y = DEVICE_HEIGHT ;
        self.numberView.frame = frame ;
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil] ;
        if (self.position == 10 || self.position == 20 || self.position == 30)
            [self.delegate FinishEditWith:self.numberTextField.text andIndex:self.index andPosition:self.position];
        else
            [self.delegate FinishEditWith:self.numberTextField.text andIndex:self.index];
    }];
    return NO ;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        [UIView animateWithDuration:0.0 animations:^{
            CGRect frame = self.wordView.frame ;
            frame.origin.y = DEVICE_HEIGHT ;
            self.wordView.frame = frame ;
            
        } completion:^(BOOL finished) {
            
            [self dismissViewControllerAnimated:NO completion:nil] ;
            if (self.position == 10 || self.position == 20 || self.position == 30)
                [self.delegate FinishEditWith:self.wordTextView.text andIndex:self.index andPosition:self.position];
            else
                [self.delegate FinishEditWith:self.wordTextView.text andIndex:self.index];
        }];
        return NO;
    }
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    if ([self.type isEqualToString:@"0"]) {
        
        CGRect frame = self.numberView.frame ;
        frame.origin.y = DEVICE_HEIGHT - 103 ;
        self.numberView.frame = frame ;
        [self.numberTextField becomeFirstResponder] ;
    }
    else {
        
        CGRect frame = self.wordView.frame ;
        frame.origin.y = DEVICE_HEIGHT - 208 ;
        self.wordView.frame = frame ;
        [self.wordTextView becomeFirstResponder];
    }
}


- (IBAction)tapBGAction:(id)sender {
    
    [self.wordTextView resignFirstResponder] ;
    [self.numberTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.0 animations:^{
        
        if ([self.type isEqualToString:@"0"]) {
            
            CGRect frame = self.numberView.frame ;
            frame.origin.y = DEVICE_HEIGHT ;
            self.numberView.frame = frame ;
        }
        else {
            
            CGRect frame = self.wordView.frame ;
            frame.origin.y = DEVICE_HEIGHT ;
            self.wordView.frame = frame ;
        }

    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
        
        if ([self.type isEqualToString:@"0"]) {
            
            if (self.position == 10 || self.position == 20 || self.position == 30)
                [self.delegate FinishEditWith:self.numberTextField.text andIndex:self.index andPosition:self.position];
            else
                [self.delegate FinishEditWith:self.numberTextField.text andIndex:self.index];
            
        }
        
        if ([self.type isEqualToString:@"1"]) { 
            
            if (self.position == 10 || self.position == 20 || self.position == 30)
                [self.delegate FinishEditWith:self.wordTextView.text andIndex:self.index andPosition:self.position];
            else
                [self.delegate FinishEditWith:self.wordTextView.text andIndex:self.index];
        }
    }];
}




- (IBAction)numberAction:(id)sender {
    
    [self.numberTextField resignFirstResponder] ;
    
    UIButton *btn = (UIButton *)sender ;

   [UIView animateWithDuration:0.0 animations:^{
        
        CGRect frame = self.numberView.frame ;
        frame.origin.y = DEVICE_HEIGHT ;
        self.numberView.frame = frame ;
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil] ;
        if (btn.tag == 20) { //确定
            if (self.position == 10 || self.position == 20 || self.position == 30)
                [self.delegate FinishEditWith:self.numberTextField.text andIndex:self.index andPosition:self.position];
            else
                [self.delegate FinishEditWith:self.numberTextField.text andIndex:self.index];
        }
    }];
}

- (IBAction)wordAction:(id)sender {
    
    [self.wordTextView resignFirstResponder];
    
    UIButton *btn = (UIButton *)sender ;
    
    [UIView animateWithDuration:0.0 animations:^{
        CGRect frame = self.wordView.frame ;
        frame.origin.y = DEVICE_HEIGHT ;
        self.wordView.frame = frame ;

    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
        if (btn.tag == 40) { //确定
            if (self.position == 10 || self.position == 20 || self.position == 30)
                [self.delegate FinishEditWith:self.wordTextView.text andIndex:self.index andPosition:self.position];
            else
                [self.delegate FinishEditWith:self.wordTextView.text andIndex:self.index];
        }
    }];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    
    self.isShowdKeyBoard = YES ;
    CGRect keyboardBounds =
    [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     CGRectValue];
    NSNumber *duration =
    [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve =
    [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGSize contentSize = self.BGScrollView.contentSize;
    contentSize.height =
    self.wordView.frame.origin.y + self.wordView.frame.size.height+
    keyboardBounds.size.height;
    
    if ([self.type isEqualToString:@"0"]) {
        
        contentSize.height = self.numberView.frame.origin.y + self.numberView.frame.size.height +
        keyboardBounds.size.height;
    }
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         self.BGScrollView.contentSize = contentSize;
                         [self.BGScrollView setContentOffset:CGPointMake(0, contentSize.height - self.BGScrollView.bounds.size.height)] ;
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    self.isShowdKeyBoard = NO ;
    NSNumber *duration =
    [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve =
    [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGSize contentSize = self.BGScrollView.contentSize;
    contentSize.height =
    self.wordView.frame.origin.y + self.wordView.frame.size.height;
    
    if ([self.type isEqualToString:@"0"]) {
        
        contentSize.height = self.numberView.frame.origin.y + self.numberView.frame.size.height;
    }
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         self.BGScrollView.contentSize = contentSize;
                     }
                     completion:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


@end





