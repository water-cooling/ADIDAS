//
//  NewsDetailViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/16.
//
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = [self.dataDic valueForKey:@"NoticleHeader"] ;

    [self ShowSVProgressHUD];
    
    NSString *noticeID = [self.dataDic valueForKey:@"NoticleId"] ;
    
    if ([noticeID isEqual:[NSNull null]]) noticeID = @"" ;
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token,@"NoticleId":noticeID};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetNoticeDetail",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        
        [self DismissSVProgressHUD];
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString *contentStr = [[[responseObject valueForKey:@"Msg"] JSONValue] valueForKey:@"NoticleDetail"];
            
            [self.newsDetailWebView loadHTMLString:contentStr baseURL:nil] ;
        }
        else {
            
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
            
            if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                [ud synchronize];
                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
