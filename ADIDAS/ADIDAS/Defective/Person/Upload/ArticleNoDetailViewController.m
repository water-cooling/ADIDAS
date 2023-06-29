//
//  ArticleNoDetailViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/4.
//

#import "ArticleNoDetailViewController.h"
#import "ApplyListTableViewCell.h"
#import "CommonUtil.h"
#import "DressDetailViewController.h"
#import "ShoeOrderDetailViewController.h"
#import "ReplacementViewController.h"
@interface ArticleNoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ArticleNoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setIOS:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = self.title ;
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyListTableViewCell"];

    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_cn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView HeightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray?self.dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApplyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyListTableViewCell"forIndexPath:indexPath];

    NSDictionary * dict = self.dataArray[indexPath.row];
    cell.orderNumerLab.text = dict[@"ArticleNo"];
    cell.orderTimeLab.text = self.time;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = self.dataArray[indexPath.row];
    
    switch (self.detailType) {
        case NewDetailShoe:{
            ShoeOrderDetailViewController * orderDetail = [ShoeOrderDetailViewController new];
            orderDetail.saveDic = dict;
            [self.navigationController pushViewController:orderDetail animated:YES];
        }
            break;
        case NewDetailDress:{
            DressDetailViewController * orderDetail = [DressDetailViewController new];
            orderDetail.saveDic = dict;

            [self.navigationController pushViewController:orderDetail animated:YES];
        }
            break;
        case NewDetailComponent:{
            ReplacementViewController * orderDetail = [ReplacementViewController new];
            orderDetail.saveDic = dict;
            [self.navigationController pushViewController:orderDetail animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
