//
//  UseGuideViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/9.
//

#import "UseGuideViewController.h"
#import "AregmentView.h"
@interface UseGuideViewController ()
@property (nonatomic,strong)AregmentView * alerView;

@end

@implementation UseGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MJWeakSelf;
    self.alerView = [[AregmentView alloc]initAlerShoeView];
    [self.alerView show];
    self.alerView.sureBlock = ^{
        weakSelf.sureBlock();
    };
    self.alerView.cancelBlock = ^{
        weakSelf.cancelBlock();
    };
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
