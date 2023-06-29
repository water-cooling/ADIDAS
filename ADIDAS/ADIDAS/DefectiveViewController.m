//
//  DefectiveViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "DefectiveViewController.h"
#import "AddProductViewController.h"
#import "CommonUtil.h"


@interface DefectiveViewController ()

@end

@implementation DefectiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                        dictionaryWithObjectsAndKeys: [CommonUtil colorWithHexString:@"#474747"],
                                        UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                                       dictionaryWithObjectsAndKeys: [CommonUtil colorWithHexString:@"#1a72b4"],
                                                       UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.delegate = self ;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any re sources that can be recreated.
}



- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)vc {
    
    UIViewController *selectTab = tabBarController.selectedViewController;
   
    if ([selectTab isEqual:vc]) return NO ;
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *nc = (UINavigationController *)vc ;
        
        NSArray *vcs = nc.viewControllers;
        
        for (UIViewController *view in vcs) {
            
            if ([view isKindOfClass:[AddProductViewController class]]) {
                
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[CommonUtil getPlistPath:LOGINDATA]];
                
                NSString *useraccount = @"" ;
                    
                if ([dic valueForKey:@"UserAccount"] && ![[dic valueForKey:@"UserAccount"] isEqual:[NSNull null]]) {
                    
                    useraccount = [dic valueForKey:@"UserAccount"] ;
                }
                
                
                NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[useraccount uppercaseString],HISTORYDATA]]];
                
                if (historyArray && [historyArray count] > 0) {
                    
                    AddProductViewController *cont = (AddProductViewController *)view ;
                    
                    [cont.navigationController popViewControllerAnimated:NO] ;
                }
            }
        }
    }
    
    return YES ;
}


@end









