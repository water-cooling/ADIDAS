//
//  SendEmailViewController.m
//  StoreVisitPack
//
//  Created by 桂康 on 2020/3/23.
//  Copyright © 2020 joinone. All rights reserved.
//

#import "SendEmailViewController.h"
#import "CommonUtil.h"
#import "Utilities.h"

@interface SendEmailViewController ()<UITextViewDelegate>

@end

@implementation SendEmailViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.targetView.layer.cornerRadius = 12 ;
    self.targetView.layer.masksToBounds = YES ;
    self.commentTextView.delegate = self ;
    self.commentTextView.text = self.commentInfo;
    self.targetView.alpha = 1 ;
    
    self.titleLabel.text = SYSLanguage?@"Add Comment":@"添加描述";
    [self.cancelButton setTitle:SYSLanguage?@"Cancel":@"取消" forState:UIControlStateNormal];
    [self.confirmButton setTitle:SYSLanguage?@"Confirm":@"确认" forState:UIControlStateNormal];
    self.holderLabel.text = SYSLanguage?@"Please input comment":@"请添加描述";
    self.holderLabel.textColor = [Utilities colorWithHexString:@"#c4c4c6"];
    self.commentTextView.layer.borderWidth = 1 ;
    self.commentTextView.layer.borderColor = [[Utilities colorWithHexString:@"#cccccc"] CGColor];
    self.commentTextView.layer.cornerRadius = 5 ;
    self.commentTextView.layer.masksToBounds = YES ;
    self.holderLabel.hidden = ![self.commentTextView.text isEqualToString:@""];
    self.confirmButton.enabled = ![self.commentTextView.text isEqualToString:@""];
    CGRect frame = self.confirmButton.frame;
    frame.size.width = (DEWIDTH - 58 - 58);
    self.cancelButton.hidden = YES ;
    self.midLine.hidden = YES ;
    if ([@"N" isEqualToString:self.mustType]) {
        frame.size.width = (DEWIDTH - 58 - 58)/2.0-1;
        self.cancelButton.hidden = NO ;
        self.midLine.hidden = NO ;
    }
    self.confirmButton.frame = frame ;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.commentTextView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.holderLabel.hidden = NO;
        self.confirmButton.enabled = NO ;
    }else{
        self.holderLabel.hidden = YES;
        self.confirmButton.enabled = YES ;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder] ;
        return NO ;
    }
    
    NSString *str = @"&<'>\"" ;
    
    return ![str containsString:text] ;
}

- (IBAction)dismissAction:(id)sender {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.targetView.alpha = 0 ;
    } completion:^(BOOL finished) {
        [self.commentTextView resignFirstResponder];
        [self dismissViewControllerAnimated:NO completion:^{}];
    }];
}

- (IBAction)sendAction:(id)sender {
    
    if (![self.commentTextView.text isEqualToString:@""]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(updateComment:withIndex:)]) {
            [self.delegate updateComment:self.commentTextView.text withIndex:self.index];
        }
        [self dismissViewControllerAnimated:NO completion:^{}];
    } else {
        [self.commentTextView resignFirstResponder];
        [self showAlertWithDispear:SYSLanguage?@"Please add a picture comment":@"请添加照片描述"];
    }
}



- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect keyboardBounds = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:[duration doubleValue] delay:0.0 options:[curve intValue] animations:^{
        CGRect f = self.targetView.frame ;
        f.origin.y = (PHONE_HEIGHT - keyboardBounds.size.height - f.size.height)/2.0 ;
        self.targetView.frame = f ;
    } completion:^(BOOL finished) {}];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] delay:0.0 options:[curve intValue] animations:^{
        CGRect f = self.targetView.frame ;
        f.origin.y = (PHONE_HEIGHT - f.size.height)/2.0 ;
        self.targetView.frame = f ;
    } completion:^(BOOL finished) {}];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
