//
//  NewAddProductViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import "ApplyDetailViewController.h"
#import "CreatTableModel.h"
#import "CommonUtil.h"
#import "ImageDetailViewController.h"
#import "TextFieldTableViewCell.h"
#import "CreateDownTableViewCell.h"
#import "CustomSheetAlerView.h"
#import "CreatTFPointDownTableViewCell.h"
#import "CreatTFDownTableViewCell.h"
#import "CreateTablePointTFCell.h"
#import "NewUploadPicCustomCell.h"
#import "RemarkTableViewCell.h"
#import "ArticleNoTableViewCell.h"
#import "AlerShoeView.h"
#import "DetailTitleTableViewCell.h"
#import "DetailAnswerTableViewCell.h"
#import "ArticleNoDetailViewController.h"
@interface ApplyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSDictionary *saveDic;
@property (nonatomic,strong)NSMutableArray *picArray;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *nextVideoButton;
@property (nonatomic,strong)CreatTableModel *templeModel;
@end

@implementation ApplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.navigationItem.title = @"申请单详情" ;
    [self creatData];
    [self.listTableView registerNib:[UINib nibWithNibName:@"DetailTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTitleTableViewCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"NewUploadPicCustomCell" bundle:nil] forCellReuseIdentifier:@"NewUploadPicCustomCell"];

    [self.listTableView registerNib:[UINib nibWithNibName:@"ArticleNoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleNoTableViewCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"DetailAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailAnswerTableViewCell"];

    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_cn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
    [self getData];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getData {
    [self ShowSVProgressHUD];
    NSDictionary *dic = @{@"CaseNumber":self.CaseNumber,@"Token":[self GetLoginUser].Token};

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetCaseDetail",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        
        [self DismissSVProgressHUD];
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            self.saveDic = [[responseObject valueForKey:@"Msg"]JSONValue];
            NSLog(@"saveDic%@",self.saveDic);
            if (self.saveDic[@"IsRemark"]) {
                [self.dataArray insertObject:self.templeModel atIndex:5];
            }
            [self.listTableView reloadData];
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



- (void)creatData{
    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTableTitleShowCell;
    model1.title = @"补寄地址：";
    model1.placeholder = @"请输入补寄地址";
    model1.key = @"AddressCn";
    [self.dataArray addObject:model1];
    
    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableTitleShowCell;
    model2.title = @"联系人姓名：";
    model2.placeholder = @"请输入联系人姓名";
    model2.key = @"ContactPerson";
    [self.dataArray addObject:model2];
    
    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTableTitleShowCell;
    model3.title = @"电话：";
    model3.placeholder = @"请输入电话";
    model3.key = @"ContactNumber";
    [self.dataArray addObject:model3];
    
    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTableTitleShowCell;
    model4.title = @"箱号：";
    model4.placeholder = @"请输入箱号";
    model4.key = @"CartonNumber";
    [self.dataArray addObject:model4];
    
    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTableTitleShowCell;
    model5.title = @"外箱是否完好：";
    model5.placeholder = @"请选择外箱是否完好";
    model5.key = @"CartonStatus";
    [self.dataArray addObject:model5];
    
    self.templeModel = [CreatTableModel new];
    self.templeModel.cellType = CreateTableTitleShowCell;
    self.templeModel.title = @"运单是否已备注破损：";
    self.templeModel.placeholder = @"请选择备注类别";
    self.templeModel.key = @"IsRemark";
    
    CreatTableModel *model6 = [CreatTableModel new];
    model6.cellType = CreateTableTitleShowCell;
    model6.title = @"运单号：";
    model6.placeholder = @"请输入运单号";
    model6.key = @"ShippingNumber";
    [self.dataArray addObject:model6];
    
    CreatTableModel *model7 = [CreatTableModel new];
    model7.cellType = CreateTableTitleShowCell;
    model7.title = @"品类：";
    model7.placeholder = @"请选择品类";
    model7.key = @"Division";
    [self.dataArray addObject:model7];
    
    CreatTableModel *model8 = [CreatTableModel new];
    model8.cellType = CreateTableTitleShowCell;
    model8.title = @"补发类别：";
    model8.placeholder = @"请选择补发类别";
    model8.key = @"CaseCategory";
    [self.dataArray addObject:model8];
    
    CreatTableModel *model9 = [CreatTableModel new];
    model9.cellType = CreateTablePicCell;
    model9.title = @"";
    model9.placeholder = @"";
    model9.key = @"";
    [self.dataArray addObject:model9];
    
    CreatTableModel *model10 = [CreatTableModel new];
    model10.cellType = CreateTableReMarkArticleNoCell;
    model10.title = @"货号：";
    model10.placeholder = @"";
    model10.key = @"";
    [self.dataArray addObject:model10];
    
    CreatTableModel *model11 = [CreatTableModel new];
    model11.cellType = CreateTableTitleShowCell;
    model11.title = @"快递单号：";
    model11.placeholder = @"";
    model11.key = @"ShippingNo";
    [self.dataArray addObject:model11];
    
    CreatTableModel *model12 = [CreatTableModel new];
    model12.cellType = CreateTableReMarkCell;
    model12.title = @"";
    model12.key = @"CaseReason";
    [self.dataArray addObject:model12];
    
    
}

#pragma mark---------tableView delegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatTableModel *model = self.dataArray[indexPath.row];

    switch (model.cellType) {
        case CreateTableTitleShowCell:
            return UITableViewAutomaticDimension;
            break;
        case CreateTableReMarkCell:
            return 125;
            break;
        case CreateTableReMarkArticleNoCell:
            return 80;
            break;
        case CreateTablePicCell:
            return (PHONE_WIDTH-60)/2+87;
        default:
            break;
    }
    return 50;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatTableModel *model = self.dataArray[indexPath.row];
    MJWeakSelf;
        if (model.cellType == CreateTableTitleShowCell) {
            DetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTitleTableViewCell"forIndexPath:indexPath];
            cell.creatTableModel = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dict = self.saveDic;
            return cell;
        }else if (model.cellType == CreateTableReMarkCell){
            DetailAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailAnswerTableViewCell" forIndexPath:indexPath];
            cell.textView.text = self.saveDic[@"DealWith"] ?:@"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            return cell;
        }else if (model.cellType == CreateTableReMarkArticleNoCell){
            ArticleNoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleNoTableViewCell"];
                cell.creatTableModel = model;
            cell.block = ^{
                ArticleNoDetailViewController * detail = [ArticleNoDetailViewController new];
                detail.title = weakSelf.saveDic[@"CartonNumber"];
                detail.time = weakSelf.saveDic[@"CaseDate"];
                if ([weakSelf.saveDic[@"Division"] isEqualToString:@"APP"]) {
                    detail.detailType = NewDetailDress;
                }else if ([weakSelf.saveDic[@"Division"] isEqualToString:@"FTW"]) {
                    detail.detailType = NewDetailShoe;
                }else if ([weakSelf.saveDic[@"Division"] isEqualToString:@"ACC"]) {
                    detail.detailType = NewDetailComponent;

                }
                detail.dataArray = self.saveDic[@"listEhCaseArticle"];
                [weakSelf.navigationController pushViewController:detail animated:YES];
            };
                cell.rightLab.text = self.saveDic[@"ArticleList"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if (model.cellType == CreateTablePicCell){
            NewUploadPicCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewUploadPicCustomCell"forIndexPath:indexPath];
        
                cell.webUrlArray = self.saveDic[@"listEhCasePicture"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            return cell;
        }
        
        return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MJWeakSelf;
}




-(void)nextVideoButtonAction{
    
   
}


- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.backgroundColor = [UIColor whiteColor];
    }
    return _listTableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)picArray{
    if (!_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}
- (NSDictionary *)saveDic{
    if (!_saveDic) {
        _saveDic = [NSDictionary dictionary];
    }
    return _saveDic;
}
@end
