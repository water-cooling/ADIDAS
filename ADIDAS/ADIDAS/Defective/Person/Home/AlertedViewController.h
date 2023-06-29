//
//  AlertedViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/27.
//
//

#import "BaseViewController.h"

@interface AlertedViewController : BaseViewController

@property (strong, nonatomic) NSString *loadString ;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIView *infoView;

- (IBAction)closeAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIWebView *contentWebView;

@end
