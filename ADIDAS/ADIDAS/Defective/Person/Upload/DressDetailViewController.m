//
//  NewAddProductViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import "DressDetailViewController.h"
#import "CreatTableModel.h"
#import "ImageDetailViewController.h"
#import "TextFieldTableViewCell.h"
#import "CreateDownTableViewCell.h"
#import "NewUploadPicCustomCell.h"
#import "CustomSheetAlerView.h"
#import "AlerShoeView.h"
#import "CommonUtil.h"
#import "DetailTitleTableViewCell.h"
#import "ApplyPicTableViewCell.h"
#import "ArticleNoTableViewCell.h"
#import "DetailAnswerTableViewCell.h"
@interface DressDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *picArray;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)CreatTableModel *templeModel;
@property (nonatomic,strong)UIButton *nextVideoButton;
@property (nonatomic,strong)NSString *folderName;;

@end

@implementation DressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.navigationItem.title = @"申请单详情" ;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_cn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self creatNormalNoStickerShoesSZData];
    [self.listTableView registerNib:[UINib nibWithNibName:@"DetailTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTitleTableViewCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"ApplyPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyPicTableViewCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"DetailAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailAnswerTableViewCell"];
    
        [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
}

- (void)creatNormalNoStickerShoesSZData{
    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTableTitleShowCell;
    model1.title = @"工厂代码：";
    model1.placeholder = @"请选择";
    model1.pointTitle = @"鞋舌唛上的工厂代号示意图";
    model1.pointDesTitle = @"请参照吊牌信息填写";
    model1.key = @"FactoryId";
    [self.dataArray addObject:model1];
    
    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableTitleShowCell;
    model2.title = @"货号：";
    model2.placeholder = @"请输入货号";
    model2.key = @"ArticleNo";
    [self.dataArray addObject:model2];
    
    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTableTitleShowCell;
    model3.title = @"产品名称：";
    model3.placeholder = @"请选择";
    model3.pointTitle = @"产品名称示意图";
    model3.pointDesTitle = @"请参照吊牌信息填写";
    model3.key = @"ModelName";
    [self.dataArray addObject:model3];
    
    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTableTitleShowCell;
    model4.title = @"渠道：";
    model4.placeholder = @"请选择";
    model4.key = @"ArticleChannel";
    [self.dataArray addObject:model4];
    
    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTableTitleShowCell;
    model5.title = @"尺码：";
    model5.placeholder = @"请输入尺码";
    model5.key = @"ArticleSize";
    [self.dataArray addObject:model5];
    
    CreatTableModel *model6 = [CreatTableModel new];
    model6.cellType = CreateTableTitleShowCell;
    model6.title = @"安全类型：";
    model6.placeholder = @"请选择";
    model6.pointTitle = @"安全类型示意图";
    model6.pointDesTitle = @"请参照吊牌信息填写";
    model6.key = @"SecurityCategory";
    [self.dataArray addObject:model6];
    
    CreatTableModel *model7 = [CreatTableModel new];
    model7.cellType = CreateTableTitleShowCell;
    model7.title = @"执行标准：";
    model7.placeholder = @"请选择";
    model7.pointTitle = @"执行标准示意图";
    model7.pointDesTitle = @"请参照吊牌信息填写";
    model7.key = @"ExecutiveStandards";
    [self.dataArray addObject:model7];
    
    CreatTableModel *model8 = [CreatTableModel new];
    model8.cellType = CreateTableTitleShowCell;
    model8.title = @"产品等级：";
    model8.placeholder = @"请选择";
    model8.pointTitle = @"产品等级示意图";
    model8.pointDesTitle = @"请参照吊牌信息填写";
    model8.key = @"ArticleGrade";
    [self.dataArray addObject:model8];
    
    CreatTableModel *model9 = [CreatTableModel new];
    model9.cellType = CreateTableTitleShowCell;
    model9.title = @"数量：";
    model9.placeholder = @"请输入数量";
    model9.key = @"Number";
    [self.dataArray addObject:model8];
    
    CreatTableModel *model10 = [CreatTableModel new];
    model10.cellType = CreateTableTitleShowCell;
    model10.title = @"条形码编号：";
    model10.placeholder = @"请输入编号";
    model10.pointTitle = @"条形码示意图";
    model10.pointDesTitle = @"请参照吊牌信息填写";
    model10.key = @"PasterEancode";
    [self.dataArray addObject:model10];
    
    CreatTableModel *model11 = [CreatTableModel new];
    model11.cellType = CreateTablePicCell;
    model11.title = @"";
    model11.key = @"";
    [self.dataArray addObject:model11];
    
    CreatTableModel *model12 = [CreatTableModel new];
    model12.cellType = CreateTableReMarkCell;
    model12.title = @"";
    model12.key = @"CaseReason";
    [self.dataArray addObject:model12];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark---------tableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatTableModel *model = self.dataArray[indexPath.row];

    switch (model.cellType) {
        case CreateTableTitleShowCell:
            return 50;
            break;
        case CreateTableReMarkCell:
            return 125;
            break;
        case CreateTablePicCell:
            return (PHONE_WIDTH-60)/4+87;
        default:
            break;
    }
    return 49;
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
            cell.dict = self.saveDic;
            return cell;
        }else if (model.cellType == CreateTableReMarkCell){
            DetailAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailAnswerTableViewCell" forIndexPath:indexPath];
            cell.textView.text = self.saveDic[@"CaseReason"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            return cell;
        }else if (model.cellType == CreateTablePicCell){
            ApplyPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyPicTableViewCell"forIndexPath:indexPath];
        
               cell.webUrlArray = self.saveDic[@"listEhCaseArticlePicture"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            return cell;
        }
        
        return [UITableViewCell new];
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_listTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFieldTableViewCell"];
        [_listTableView registerNib:[UINib nibWithNibName:@"CreateDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreateDownTableViewCell"];
        [_listTableView registerNib:[UINib nibWithNibName:@"NewUploadPicCustomCell" bundle:nil] forCellReuseIdentifier:@"NewUploadPicCustomCell"];

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
- (NSMutableDictionary *)saveDic{
    if (!_saveDic) {
        _saveDic = [NSMutableDictionary dictionary];
    }
    return _saveDic;
}
@end
