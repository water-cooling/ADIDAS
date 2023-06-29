//
//  CaseTitleViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2017/2/6.
//
//

#import "CaseTitleViewController.h"
#import "CaseSecondTitleViewController.h"

@interface CaseTitleViewController ()<CaseSecondDelegate>

@end

@implementation CaseTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.listTableView.dataSource = self ;
    self.listTableView.delegate = self ;
    self.listTableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.title = @"品类和残次类型" ;
    NSDictionary *loginDic = [NSDictionary dictionaryWithContentsOfFile:[CommonUtil getPlistPath:LOGINDATA]] ;
    self.dataDic = [loginDic valueForKey:@"DicCaseTitle"] ;
    self.caseTypeArray = [loginDic valueForKey:@"listCaseTitle"] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.caseTypeArray count] ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSString *castString = [self.caseTypeArray objectAtIndex:indexPath.row] ;
    cell.textLabel.text = castString ;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CaseSecondTitleViewController *second = [[CaseSecondTitleViewController alloc] initWithNibName:@"CaseSecondTitleViewController" bundle:nil];
    second.firstTitleString = [self.caseTypeArray objectAtIndex:indexPath.row] ;
    second.delegate = self ;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item ;
    [self.navigationController pushViewController:second animated:YES];
}

- (void)finishSecondWith:(NSString *)result {
    
    [self.delegate finishWith:result];
    [self performSelector:@selector(backPage) withObject:nil afterDelay:0.1];
}

- (void) backPage {
    [self.navigationController popViewControllerAnimated:NO];
}

@end


















