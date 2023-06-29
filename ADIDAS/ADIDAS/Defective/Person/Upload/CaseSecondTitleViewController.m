//
//  CaseSecondTitleViewController.m
//  MobileApp
//
//  Created by 桂康 on 2019/5/29.
//

#import "CaseSecondTitleViewController.h"

@interface CaseSecondTitleViewController ()

@end

@implementation CaseSecondTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.listTableView.dataSource = self ;
    self.listTableView.delegate = self ;
    self.listTableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.title = self.firstTitleString ;
    NSDictionary *loginDic = [NSDictionary dictionaryWithContentsOfFile:[CommonUtil getPlistPath:LOGINDATA]] ;
    self.dataAry = [[loginDic valueForKey:@"DicCaseTitle"] valueForKey:self.firstTitleString] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataAry count] ;
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
    
    NSString *castString = [self.dataAry objectAtIndex:indexPath.row] ;
    cell.textLabel.text = castString ;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate finishSecondWith:[NSString stringWithFormat:@"%@ - %@",self.firstTitleString,[self.dataAry objectAtIndex:indexPath.row]]];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
