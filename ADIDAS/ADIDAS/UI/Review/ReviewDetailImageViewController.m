//
//  ReviewDetailImageViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/6/13.
//

#import "ReviewDetailImageViewController.h"
#import "UIImageView+YYWebImage.h"
#import "CommonDefine.h"


@interface ReviewDetailImageViewController ()

@end

@implementation ReviewDetailImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.imageUrl]) {
        self.bgImageView.image = [UIImage imageWithContentsOfFile:self.imageUrl];
    } else {
        [self.bgImageView yy_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,self.imageUrl] stringByReplacingOccurrencesOfString:@"~" withString:@""]] placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [_bgImageView release];
    [super dealloc];
}

- (IBAction)disapearAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        self.bgImageView.image = nil ;
    }];
}


@end
