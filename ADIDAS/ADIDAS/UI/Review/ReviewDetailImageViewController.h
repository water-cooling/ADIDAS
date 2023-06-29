//
//  ReviewDetailImageViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/6/13.
//

#import <UIKit/UIKit.h>

@interface ReviewDetailImageViewController : UIViewController

@property (strong, nonatomic) NSString *imageUrl ;
@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
- (IBAction)disapearAction:(id)sender;

@end
