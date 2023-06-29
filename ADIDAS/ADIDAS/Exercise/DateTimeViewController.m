//
//  DateTimeViewController.m
//  MobileApp
//
//  Created by 桂康 on 2019/10/30.
//

#import "DateTimeViewController.h"

@interface DateTimeViewController ()

@end

@implementation DateTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [NSString stringWithFormat:@"%@ 00:00:00",[formatter stringFromDate:[NSDate date]]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *min = [formatter dateFromString:dateStr];
    self.datePicker.minimumDate = min;
}

- (void)viewDidAppear:(BOOL)animated {

    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.datePickView.frame ;
        frame.origin.y = PHONE_HEIGHT - 208 ;
        self.datePickView.frame = frame ;
    }];
}

- (IBAction)operateAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender ;
    
    if (btn.tag == 20) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateStr = [formatter stringFromDate:self.datePicker.date];
        [self.delegate currentDate:dateStr withIndex:self.index] ;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.datePickView.frame ;
        frame.origin.y = PHONE_HEIGHT ;
        self.datePickView.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
    }];
}


- (IBAction)tabBGView:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.datePickView.frame ;
        frame.origin.y = PHONE_HEIGHT ;
        self.datePickView.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
    }];
}

@end
