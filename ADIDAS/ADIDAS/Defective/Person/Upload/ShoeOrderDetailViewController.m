//
//  NewAddProductViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import "ShoeOrderDetailViewController.h"
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
@interface ShoeOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *picArray;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)CreatTableModel *templeModel;
@property (nonatomic,strong)UIButton *nextVideoButton;
@property (nonatomic,strong)NSString *folderName;;

@end

@implementation ShoeOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.navigationItem.title = @"申请单详情" ;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_cn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"DetailTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTitleTableViewCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"ApplyPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyPicTableViewCell"];

    [self.listTableView registerNib:[UINib nibWithNibName:@"ArticleNoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleNoTableViewCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"DetailAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailAnswerTableViewCell"];
    
        [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
    
    switch (self.detailType) {
        case normalNoStickerShoesSZ:
            [self creatNormalNoStickerShoesSZData];
            break;
        case normalNoStickerShoesTJ:
            [self creatNormalNoStickerShoesTJData];
            break;
        case specialNoStickerShoes:
            [self creatSpecialNoStickerShoesData];
            break;
        case normalStickerShoesSZ:
            [self creatNormalStickerShoesData];
            break;
        default:
            break;
    }
    
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)creatNormalNoStickerShoesSZData{

    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTableTitleShowCell;
    model1.title = @"货号:";
    model1.placeholder = @"请输入货号";
    model1.key = @"ArticleNo";
    [self.dataArray addObject:model1];

    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableTitleShowCell;
    model2.title = @"鞋舌唛上的工厂代号";
    model2.placeholder = @"请输入工厂代号";

    model2.key = @"FactoryId";
    [self.dataArray addObject:model2];

    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTableTitleShowCell;
    model3.title = @"UK尺码：";
    model3.placeholder = @"请输入UK尺码";
    model3.key = @"ArticleSize";
    [self.dataArray addObject:model3];

    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTableTitleShowCell;
    model4.title = @"鞋盒数量：";
    model4.placeholder = @"请输入数量";
    model4.key = @"Number";
    [self.dataArray addObject:model4];

    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTableTitleShowCell;
    model5.title = @"贴纸上的PO号：";
    model5.placeholder = @"请输入PO号";
    model5.pointTitle = @"贴纸上的PO号示意图";
    model5.pointDesTitle = @"请参照吊牌信息填写";
    model5.key = @"PoNumber";
    [self.dataArray addObject:model5];

    CreatTableModel *model6 = [CreatTableModel new];
    model6.cellType = CreateTableTitleShowCell;
    model6.title = @"鞋盒规格：";
    model6.placeholder = @"请输入规格";
    model6.pointTitle = @"鞋盒规格示意图";
    model6.pointDesTitle = @"请参照吊牌信息填写";
    model6.key = @"CartonSize";
    [self.dataArray addObject:model6];

    CreatTableModel *model7 = [CreatTableModel new];
    model7.cellType = CreateTableTitleShowCell;
    model7.title = @"渠道：";
    model7.placeholder = @"请选择渠道";
    model7.key = @"ArticleChannel";
    [self.dataArray addObject:model7];

    CreatTableModel *model8 = [CreatTableModel new];
    model8.cellType = CreateTableTitleShowCell;
    model8.title = @"鞋舌唛上的IBPO号";
    model8.placeholder = @"请输入IBPO号";
    model8.pointTitle = @"鞋舌唛上的IBPO号示意图";
    model8.pointDesTitle = @"请参照吊牌信息填写";
    model8.key = @"IbpoNumber";
    [self.dataArray addObject:model8];

    CreatTableModel *model9 = [CreatTableModel new];
    model9.cellType = CreateTablePicCell;
    model9.title = @"";
    model9.key = @"IbpoNumber";
    [self.dataArray addObject:model9];

    CreatTableModel *model10 = [CreatTableModel new];
    model10.cellType = CreateTableReMarkCell;
    model10.title = @"";
    model10.key = @"CaseReason";
    [self.dataArray addObject:model10];
    [self.listTableView reloadData];
}
- (void)creatNormalNoStickerShoesTJData{

CreatTableModel *model1 = [CreatTableModel new];
model1.cellType = CreateTableTitleShowCell;
model1.title = @"货号:";
model1.placeholder = @"请输入货号";
model1.key = @"ArticleNo";
[self.dataArray addObject:model1];


CreatTableModel *model2 = [CreatTableModel new];
model2.cellType = CreateTableTitleShowCell;
model2.title = @"UK尺码：";
model2.placeholder = @"请输入UK尺码";
model2.key = @"ArticleSize";
[self.dataArray addObject:model2];

CreatTableModel *model3 = [CreatTableModel new];
model3.cellType = CreateTableTitleShowCell;
model3.title = @"鞋盒数量：";
model3.placeholder = @"请输入数量";
model3.key = @"Number";
[self.dataArray addObject:model3];

CreatTableModel *model4 = [CreatTableModel new];
model4.cellType = CreateTableTitleShowCell;
model4.title = @"鞋盒规格：";
model4.placeholder = @"请输入规格";
model4.pointTitle = @"鞋盒规格示意图";
model4.pointDesTitle = @"请参照吊牌信息填写";
model4.key = @"CartonSize";
[self.dataArray addObject:model4];


CreatTableModel *model5 = [CreatTableModel new];
model5.cellType = CreateTableTitleShowCell;
model5.title = @"渠道：";
model5.placeholder = @"请选择渠道";
model5.key = @"ArticleChannel";
[self.dataArray addObject:model5];

CreatTableModel *model6 = [CreatTableModel new];
model6.cellType = CreateTablePicCell;
model6.title = @"";
model6.key = @"";
[self.dataArray addObject:model6];

CreatTableModel *model7 = [CreatTableModel new];
model7.cellType = CreateTableReMarkCell;
model7.title = @"";
model7.key = @"CaseReason";
[self.dataArray addObject:model7];
[self.listTableView reloadData];


}
- (void)creatSpecialNoStickerShoesData{

CreatTableModel *model1 = [CreatTableModel new];
model1.cellType = CreateTableTitleShowCell;
model1.title = @"鞋舌唛上的工厂代号:";
model1.pointTitle = @"鞋舌唛上的工厂代号示意图";
model1.pointDesTitle = @"请参照吊牌信息填写";
model1.placeholder = @"请输入工厂代号";
model1.key = @"FactoryId";
[self.dataArray addObject:model1];

CreatTableModel *model2 = [CreatTableModel new];
model2.cellType = CreateTableTitleShowCell;
model2.title = @"货号:";
model2.placeholder = @"请输入货号";
model2.key = @"ArticleNo";
[self.dataArray addObject:model2];

CreatTableModel *model3 = [CreatTableModel new];
model3.cellType = CreateTableTitleShowCell;
model3.title = @"UK尺码：";
model3.placeholder = @"请输入UK尺码";
model3.key = @"ArticleSize";
[self.dataArray addObject:model3];

CreatTableModel *model4 = [CreatTableModel new];
model4.cellType = CreateTableTitleShowCell;
model4.title = @"鞋盒数量：";
model4.placeholder = @"请输入数量";
model4.key = @"Number";
[self.dataArray addObject:model4];

CreatTableModel *model5 = [CreatTableModel new];
model5.cellType = CreateTableTitleShowCell;
model5.title = @"贴纸上的PO号：";
model5.placeholder = @"请输入PO号";
model5.pointTitle = @"贴纸上的PO号示意图";
model5.pointDesTitle = @"请参照吊牌信息填写";
model5.key = @"PoNumber";
[self.dataArray addObject:model5];

CreatTableModel *model6 = [CreatTableModel new];
model6.cellType = CreateTableTitleShowCell;
model6.title = @"鞋盒规格：";
model6.placeholder = @"请输入规格";
model6.pointTitle = @"鞋盒规格示意图";
model6.pointDesTitle = @"请参照吊牌信息填写";
model6.key = @"CartonSize";
[self.dataArray addObject:model6];

CreatTableModel *model7 = [CreatTableModel new];
model7.cellType = CreateTableTitleShowCell;
model7.title = @"渠道：";
model7.placeholder = @"请选择渠道";
model7.key = @"ArticleChannel";
[self.dataArray addObject:model7];

CreatTableModel *model8 = [CreatTableModel new];
model8.cellType = CreateTableTitleShowCell;
model8.title = @"鞋舌唛上的IBPO号";
model8.placeholder = @"请输入IBPO号";
model8.pointTitle = @"鞋舌唛上的IBPO号示意图";
model8.pointDesTitle = @"请参照吊牌信息填写";
model8.key = @"IbpoNumber";
[self.dataArray addObject:model8];

CreatTableModel *model9 = [CreatTableModel new];
model9.cellType = CreateTablePicCell;
model9.title = @"";
model9.key = @"";
[self.dataArray addObject:model9];

CreatTableModel *model10 = [CreatTableModel new];
model10.cellType = CreateTableReMarkCell;
model10.title = @"";
model10.key = @"CaseReason";
[self.dataArray addObject:model10];
[self.listTableView reloadData];

}

- (void)creatNormalStickerShoesData{

CreatTableModel *model1 = [CreatTableModel new];
model1.cellType = CreateTableTitleShowCell;
model1.title = @"鞋舌唛上的工厂代号";
model1.placeholder = @"请输入工厂代号";
model1.pointTitle = @"鞋舌唛上的工厂代号示意图";
model1.pointDesTitle = @"请参照吊牌信息填写";
model1.key = @"FactoryId";
[self.dataArray addObject:model1];

CreatTableModel *model2 = [CreatTableModel new];
model2.cellType = CreateTableTitleShowCell;
model2.title = @"货号:";
model2.placeholder = @"请输入货号";
model2.key = @"ArticleNo";
[self.dataArray addObject:model2];

CreatTableModel *model3 = [CreatTableModel new];
model3.cellType = CreateTableTitleShowCell;
model3.title = @"UK尺码：";
model3.placeholder = @"请输入UK尺码";
model3.key = @"ArticleSize";
[self.dataArray addObject:model3];

CreatTableModel *model4 = [CreatTableModel new];
model4.cellType = CreateTableTitleShowCell;
model4.title = @"鞋盒数量：";
model4.placeholder = @"请输入数量";
model4.key = @"Number";
[self.dataArray addObject:model4];

CreatTableModel *model5 = [CreatTableModel new];
model5.cellType = CreateTableTitleShowCell;
model5.title = @"贴纸上的PO号：";
model5.placeholder = @"请输入PO号";
model5.pointTitle = @"贴纸上的PO号示意图";
model5.pointDesTitle = @"请参照吊牌信息填写";
model5.key = @"PoNumber";
[self.dataArray addObject:model5];

CreatTableModel *model6 = [CreatTableModel new];
model6.cellType = CreateTableTitleShowCell;
model6.title = @"鞋盒规格：";
model6.placeholder = @"请输入规格";
model6.pointTitle = @"鞋盒规格示意图";
model6.pointDesTitle = @"请参照吊牌信息填写";
model6.key = @"CartonSize";
[self.dataArray addObject:model6];

CreatTableModel *model7 = [CreatTableModel new];
model7.cellType = CreateTableTitleShowCell;
model7.title = @"渠道：";
model7.placeholder = @"请选择渠道";
model7.key = @"ArticleChannel";
[self.dataArray addObject:model7];

CreatTableModel *model8 = [CreatTableModel new];
model8.cellType = CreateTableTitleShowCell;
model8.title = @"鞋舌唛上的IBPO号";
model8.placeholder = @"请输入IBPO号";
model8.pointTitle = @"鞋舌唛上的IBPO号示意图";
model8.pointDesTitle = @"请参照吊牌信息填写";
model8.key = @"IbpoNumber";
[self.dataArray addObject:model8];

CreatTableModel *model9 = [CreatTableModel new];
model9.cellType = CreateTableTitleShowCell;
model9.title = @"贴纸数量";
model9.placeholder = @"请输入贴纸数量";
model9.key = @"PasterNumber";
[self.dataArray addObject:model9];

CreatTableModel *model10 = [CreatTableModel new];
model10.cellType = CreateTableTitleShowCell;
model10.title = @"鞋舌唛上的生产日期";
model10.placeholder = @"请输入生产日期";
model10.pointTitle = @"鞋舌唛上的生产日期示意图";
model10.pointDesTitle = @"请参照吊牌信息填写";
model10.key = @"ProductionDate";
[self.dataArray addObject:model10];

CreatTableModel *model11 = [CreatTableModel new];
model11.cellType = CreateTableTitleShowCell;
model11.title = @"贴纸上的条形码";
model11.placeholder = @"请输入条形码";
model11.pointTitle = @"贴纸上的条形码示意图";
model11.pointDesTitle = @"请参照吊牌信息填写";
model11.key = @"PasterEancode";
[self.dataArray addObject:model11];

CreatTableModel *model12 = [CreatTableModel new];
model12.cellType = CreateTableTitleShowCell;
model12.title = @"Model Name";
model12.placeholder = @"请输入Model Name";
model12.pointTitle = @"Model Name示意图";
model12.pointDesTitle = @"请参照吊牌信息填写";
model12.key = @"ModelName";
[self.dataArray addObject:model12];

CreatTableModel *model13 = [CreatTableModel new];
model13.cellType = CreateTableTitleShowCell;
model13.title = @"性别（请按照贴纸上的描述）";
model13.placeholder = @"请输入性别";
model13.pointTitle = @"性别示意图";
model13.pointDesTitle = @"请按照贴纸上的描述";
model13.key = @"Gender";
[self.dataArray addObject:model13];

CreatTableModel *model14 = [CreatTableModel new];
model14.cellType = CreateTableTitleShowCell;
model14.title = @"Category";
model14.placeholder = @"请选择";
model14.pointTitle = @"Category示意图";
model14.pointDesTitle = @"请参照吊牌信息填写";
model14.key = @"Category";
[self.dataArray addObject:model14];

CreatTableModel *model15 = [CreatTableModel new];
model15.cellType = CreateTableTitleShowCell;
model15.title = @"颜色（请按照贴纸上的描述）";
model15.placeholder = @"请输入颜色";
model15.pointTitle = @"颜色示意图";
model15.pointDesTitle = @"请按照贴纸上的描述";
model15.key = @"Color";
[self.dataArray addObject:model15];

CreatTableModel *model16 = [CreatTableModel new];
model16.cellType = CreateTableTitleShowCell;
model16.title = @"帮面材料（请按照贴纸上的描述）";
model16.placeholder = @"请输入颜色";
model16.pointTitle = @"帮面材料示意图";
model16.pointDesTitle = @"请按照贴纸上的描述";
model16.key = @"UpperMaterial";
[self.dataArray addObject:model16];

CreatTableModel *model17 = [CreatTableModel new];
model17.cellType = CreateTableTitleShowCell;
model17.title = @"SHoe Width";
model17.placeholder = @"请选择";
model17.pointTitle = @"SHoe Width示意图";
model17.pointDesTitle = @"请按照贴纸上的描述";
model17.key = @"ShoeWidth";
[self.dataArray addObject:model17];

CreatTableModel *model18 = [CreatTableModel new];
model18.cellType = CreateTableTitleShowCell;
model18.title = @"执行标准";
model18.placeholder = @"请选择";
model18.pointTitle = @"执行标准示意图";
model18.pointDesTitle = @"请按照贴纸上的描述";
model18.key = @"ExecutiveStandards";
[self.dataArray addObject:model18];

CreatTableModel *model19 = [CreatTableModel new];
model19.cellType = CreateTableTitleShowCell;
model19.title = @"品名（参看合格证上的描述）";
model19.pointTitle = @"品名示意图";
model19.pointDesTitle = @"参看合格证上的描述";
model19.placeholder = @"请选择";
model19.key = @"ArticleName";
[self.dataArray addObject:model19];

CreatTableModel *model20 = [CreatTableModel new];
model20.cellType = CreateTableTitleShowCell;
model20.title = @"大底类型";
model20.pointTitle = @"大底类型示意图";
model20.pointDesTitle = @"参看合格证上的描述";
model20.placeholder = @"请选择";
model20.key = @"OutsoleType";
[self.dataArray addObject:model20];

CreatTableModel *model21 = [CreatTableModel new];
model21.cellType = CreateTablePicCell;
model21.title = @"";
model21.key = @" PasterEancode";
[self.dataArray addObject:model21];

CreatTableModel *model22 = [CreatTableModel new];
model22.cellType = CreateTableReMarkCell;
model22.title = @"";
model22.key = @"CaseReason";
[self.dataArray addObject:model22];
[self.listTableView reloadData];
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
            NewUploadPicCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewUploadPicCustomCell"forIndexPath:indexPath];
        
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

@end
