//
//  AlertedViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/27.
//
//

#import "AlertedViewController.h"
#import "CommonUtil.h"

@interface AlertedViewController ()

@end

@implementation AlertedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] ;
    self.titleLabel.textColor = [CommonUtil colorWithHexString:@"#ad894a"] ;
    
    self.infoView.layer.cornerRadius = 4 ;
    self.infoView.layer.masksToBounds = YES ;
    self.infoView.alpha = 0 ;
    
    [self.contentWebView loadHTMLString:self.loadString baseURL:nil] ;
}

- (void)viewDidAppear:(BOOL)animated {

    [UIView animateWithDuration:0.3 animations:^{
        
        self.infoView.alpha = 1 ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)closeAction:(id)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect iFrame = self.infoView.frame ;
        iFrame.origin.y = PHONE_HEIGHT ;
        self.infoView.frame = iFrame ;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
    }];
}


@end
