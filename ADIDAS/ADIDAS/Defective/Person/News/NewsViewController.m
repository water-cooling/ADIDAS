//
//  NewsViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "NewsViewController.h"
#import "newsCustomCell.h"
#import "NewsDetailViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"公告" ;
    
    self.newsTableView.dataSource = self ;
    self.newsTableView.delegate = self ;
    self.newsTableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0) ;
    

    [self ShowSVProgressHUD];
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetNoticeHeader",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        
        [self DismissSVProgressHUD];
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            self.dataArray = [[responseObject valueForKey:@"Msg"] JSONValue];
            
            [self.newsTableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 46 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell" ;
    
    newsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"newsCustomCell" owner:self options:nil];
        
        for (UIView *view in nibAry) {
            
            if ([view isKindOfClass:[newsCustomCell class]]) {
                
                cell = (newsCustomCell *)view ;
                break ;
            }
        }
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.newsLabel.text = [[dic valueForKey:@"NoticleHeader"] isEqual:[NSNull null]] ? @"":[dic valueForKey:@"NoticleHeader"] ;
    cell.dateLabel.text = [[dic valueForKey:@"NoticleDate"] isEqual:[NSNull null]] ? @"":[dic valueForKey:@"NoticleDate"] ;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsDetailViewController *vc = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    
    vc.dataDic =[self.dataArray objectAtIndex:indexPath.row];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = item ;
    vc.hidesBottomBarWhenPushed = YES ;
    [self.navigationController pushViewController:vc animated:YES] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
