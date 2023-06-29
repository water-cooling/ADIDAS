//
//  ReviewSyssettingViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/6/11.
//

#import <UIKit/UIKit.h>

@interface ReviewSyssettingViewController : UIViewController

@property (strong,nonatomic) UIView* waitView;
@property (retain, nonatomic) IBOutlet UIButton *btn3;
@property (weak,nonatomic) IBOutlet UILabel* accountLabel;

- (IBAction)logout:(id)sender;
- (IBAction)userAccount:(id)sender;


@end
