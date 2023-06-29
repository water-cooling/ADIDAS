//
//  ImageDetailViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "ImageDetailViewController.h"
#import "UIImageView+YYWebImage.h"
#import "Utilities.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.DeleteButton.layer.cornerRadius = 5 ;
    
    self.DetailImage.contentMode = UIViewContentModeScaleAspectFit ;
    
    if (self.infoDic) {
        
        self.DeleteButton.hidden = YES ;
        
        if (![[self.infoDic valueForKey:@"PictureUrl"] isEqualToString:@""]) {
            
            [self ShowWhiteSVProgressHUD];
            
            [self.DetailImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[self.infoDic valueForKey:@"PictureUrl"] substringFromIndex:1]]] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                [self ShowProgressSVProgressHUDProgress:receivedSize*1.0/expectedSize] ;
                
            } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                [self DismissSVProgressHUD];
            }];
        }
        else if (![[self.infoDic valueForKey:@"SmallPictureUrl"] isEqualToString:@""]) {
            
            [self.DetailImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[self.infoDic valueForKey:@"SmallPictureUrl"] substringFromIndex:1]]] placeholder:nil] ;
        }
    }
    
    if (self.imageData) {
        
        if ([[self.imageData componentsSeparatedByString:@"~"] count] == 2) {
            
            [self ShowWhiteSVProgressHUD];
            
            [self.DetailImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[self.imageData substringFromIndex:1]]] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                [self ShowProgressSVProgressHUDProgress:receivedSize*1.0/expectedSize] ;
                
            } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                [self DismissSVProgressHUD];
            }];
        }
        else self.DetailImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil SysDocumentPath],[[self.imageData componentsSeparatedByString:@"_"] firstObject]]] ;
        
        self.DeleteButton.layer.borderColor = [[CommonUtil colorWithHexString:@"#35bfbd"] CGColor];
        [self.DeleteButton setTitleColor:[CommonUtil colorWithHexString:@"#35bfbd"] forState:UIControlStateNormal] ;
        self.DeleteButton.layer.borderWidth = 0.5 ;
    }
    
    if (self.trainingPath) {
        self.DetailImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],self.trainingPath]];
        self.DeleteButton.layer.borderColor = [[CommonUtil colorWithHexString:@"#35bfbd"] CGColor];
        [self.DeleteButton setTitleColor:[CommonUtil colorWithHexString:@"#35bfbd"] forState:UIControlStateNormal] ;
        self.DeleteButton.layer.borderWidth = 0.5 ;
    }
    
    [self.DetailImage setMultipleTouchEnabled:YES];
    [self.DetailImage setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {

    [self.DetailImage removeFromSuperview] ;
    self.DetailImage = nil ;
}

- (IBAction)TapCloseView:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil] ;
}

- (IBAction)DeleteAction:(id)sender {
    
    [self.DeleteDelegate DeleteSelectImageWith:self.index];
    [self TapCloseView:nil];
}



@end
