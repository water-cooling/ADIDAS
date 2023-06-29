//
//  PersonViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "PersonViewController.h"
#import "LoginViewController.h"
#import "ChangePassWordViewController.h"
#import "WaittingUploadViewController.h"
#import "CommonUtil.h"

@interface PersonViewController ()

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的" ;
    
    self.myTableView.dataSource = self ;
    self.myTableView.delegate = self ;
    self.myTableView.contentInset = UIEdgeInsetsMake(9, 0, 0, 0) ;
    
    self.accountLabel.textColor = [CommonUtil colorWithHexString:@"#1a1b1c"];
    self.storeLabel.textColor = [CommonUtil colorWithHexString:@"#1a1b1c"];
    
//    self.myTableView.tableFooterView = self.footerView ;
//    self.myTableView.tableHeaderView = self.headerView ;
    
    self.bgLabel.layer.cornerRadius = 33 ;
    self.bgLabel.layer.masksToBounds = YES ;
    self.bgLabel.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
    
    self.headImageView.layer.cornerRadius = 31 ;
    self.headImageView.layer.masksToBounds = YES ;
    self.headImageView.backgroundColor = [UIColor whiteColor];
    
    [self.logoutButton setTitleColor:[CommonUtil colorWithHexString:@"#1973ba"] forState:UIControlStateNormal] ;
    self.logoutButton.layer.borderColor = [[CommonUtil colorWithHexString:@"#1973ba"] CGColor];
    self.logoutButton.layer.borderWidth = 1 ;
    self.logoutButton.layer.cornerRadius = 2 ;
    self.logoutButton.layer.masksToBounds = YES ;
    
    uploadSW = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
    uploadSW.on = ISONTIME ;
    [uploadSW addTarget:self action:@selector(chagneSwitch) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountLabel.text = [NSString stringWithFormat:@"账号：%@",[self GetLoginUser].UserAccount];
    self.storeLabel.text = [NSString stringWithFormat:@"名称：%@",[self GetLoginUser].UserNameCN];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    if (section == 0) return 2 ;
    
    return 1 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textColor = [CommonUtil colorWithHexString:@"#1a1b1c"];
    
//    if (indexPath.section == 0) {
//        
//        if (indexPath.row == 0) {
//            
//            cell.textLabel.text = @"即时上传" ;
//            cell.accessoryView = uploadSW ;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
//            cell.imageView.image = [UIImage imageNamed:@"def_isupload.png"];
//        }
//        
//        if (indexPath.row == 1) {
//            
//            cell.textLabel.text = @"待上传列表" ;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
//            cell.selectionStyle = UITableViewCellSelectionStyleDefault ;
//            cell.imageView.image = [UIImage imageNamed:@"def_waitupload.png"];
//        }
//    }
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"修改密码" ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault ;
        cell.imageView.image = [UIImage imageNamed:@"def_changepwd.png"];
    }
    
    return cell ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        ChangePassWordViewController *vc = [[ChangePassWordViewController alloc] initWithNibName:@"ChangePassWordViewController" bundle:nil] ;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = item ;
        
        vc.hidesBottomBarWhenPushed = YES ;
        
        [self.navigationController pushViewController:vc animated:YES] ;
    }
    
//    if (indexPath.section == 0 && indexPath.row == 1) {
//        
//        WaittingUploadViewController *vc = [[WaittingUploadViewController alloc] initWithNibName:@"WaittingUploadViewController" bundle:nil] ;
//        
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
//        self.navigationItem.backBarButtonItem = item ;
//        
//        vc.hidesBottomBarWhenPushed = YES ;
//        
//        [self.navigationController pushViewController:vc animated:YES] ;
//    }
}

- (void)chagneSwitch {

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults] ;
    [ud setBool:uploadSW.on forKey:@"ISONTIMEUPLOAD"] ;
    [ud synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出登录?" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"确定", nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        [self ShowSVProgressHUD];
        
        NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};
        
        [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@UserLoinOut",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (![responseStr JSONValue]) {
                NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
                responseObject = [aesString JSONValue] ;
            }else {
                responseObject = [responseStr JSONValue] ;
            }
            
            [self DismissSVProgressHUD];
            
            if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                [ud synchronize];
                
                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
            }
            else {
                
                if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                    [ud synchronize];
                    [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
                }
                else [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self DismissSVProgressHUD];
            
            [self showAlertWithDispear:error.localizedDescription];
        }];
    }
}





@end












