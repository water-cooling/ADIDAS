//
//  NewApplyViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import "NewApplyViewController.h"
#import "CreatTableModel.h"
#import "TextFieldTableViewCell.h"
#import "CreatTFPointDownTableViewCell.h"
#import "CreatTFDownTableViewCell.h"
#import "CreateTablePointTFCell.h"
#import "ApplyPicTableViewCell.h"
#import "RemarkTableViewCell.h"
#import "AlerPointPickView.h"
#import "ImageDetailViewController.h"
#import "CommonUtil.h"
#import "CustomSheetAlerView.h"
#import "HeadImageManager.h"
#import "CreateDownTableViewCell.h"
@interface NewApplyViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,DeleteSelectImageDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableDictionary *saveDic;
@property (nonatomic,strong)NSMutableArray *picArray;
@property (nonatomic,strong)AlerPointPickView *pointView;
@property (nonatomic,strong)NSArray *channelArr;
@property (nonatomic,strong)NSArray *sizeArray;
@property (nonatomic,strong)NSArray *factoryArray;
@property (nonatomic,strong)NSArray *genderArray;
@property (nonatomic,strong)NSArray *categoryArray;
@property (nonatomic,strong)NSArray *shoeWidthArray;
@property (nonatomic,strong)NSArray *articleNameArray;
@property (nonatomic,strong)NSArray *outSoleArray;
@property (nonatomic,strong)NSArray *ExecutiveArr;
@property (nonatomic,strong)NSArray *sampleArr;

@end

@implementation NewApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pointView = [[AlerPointPickView alloc]initAlerPointPickView];
    [self setIOS:self.tableView];
    self.sureBtn.layer.cornerRadius = 15;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreatTFDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreatTFDownTableViewCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"CreatTFPointDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreatTFPointDownTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreateDownTableViewCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"CreateTablePointTFCell" bundle:nil] forCellReuseIdentifier:@"CreateTablePointTFCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyPicTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemarkTableViewCell"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_cn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];

    tableViewGesture.numberOfTapsRequired = 1;

    tableViewGesture.cancelsTouchesInView = NO;

    [self.tableView addGestureRecognizer:tableViewGesture];



    switch (self.type) {
        case normalNoStickerShoesSZ:
            [self creatNormalNoStickerShoesSZData];
            break;
        case normalNoStickerShoesTJ:
            [self creatNormalNoStickerShoesSZData];
            break;
        case specialNoStickerShoes:
            [self creatSpecialNoStickerShoesData];
            break;
        case normalStickerShoesSZ:
            [self creatNormalStickerShoesData:NO];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];


    // Do any additional setup after loading the view from its nib.
}

-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note{
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];

}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)creatNormalNoStickerShoesSZData{
    
    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTableTFCell;
    model1.title = @"货号:";
    model1.placeholder = @"请输入货号";
    model1.key = @"ArticleNo";
    [self.dataArray addObject:model1];
    
  
    
    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableDownCell;
    model2.title = @"UK尺码：";
    model2.placeholder = @"请输入UK尺码";
    model2.key = @"ArticleSize";
    [self.dataArray addObject:model2];
    
    
    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTablePointDownCell;
    model3.title = @"鞋舌唛上的工厂代号";
    model3.placeholder = @"请输入工厂代号";
    model3.pointTitle = @"鞋舌唛上的工厂代号示意图";
    model3.pointDesTitle = @"请参照吊牌信息填写";
    model3.key = @"FactoryCode";
    [self.dataArray addObject:model3];
    
    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTableTFCell;
    model4.title = @"鞋盒数量：";
    model4.placeholder = @"请输入数量";
    model4.key = @"Number";
    [self.dataArray addObject:model4];
    
    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTablePoinTFCell;
    model5.title = @"贴纸上的PO号：";
    model5.placeholder = @"请输入PO号";
    model5.pointTitle = @"贴纸上的PO号示意图";
    model5.pointDesTitle = @"请参照吊牌信息填写";
    model5.key = @"PoNumber";
    [self.dataArray addObject:model5];
    
    CreatTableModel *model6 = [CreatTableModel new];
    model6.cellType = CreateTablePoinTFCell;
    model6.title = @"鞋盒规格：";
    model6.placeholder = @"请输入规格";
    model6.pointTitle = @"鞋盒规格示意图";
    model6.pointDesTitle = @"请参照吊牌信息填写";
    model6.key = @"CartonSize";
    [self.dataArray addObject:model6];
    
    CreatTableModel *model7 = [CreatTableModel new];
    model7.cellType = CreateTableDownCell;
    model7.title = @"渠道：";
    model7.placeholder = @"请选择渠道";
    model7.key = @"ArticleChannel";
    [self.dataArray addObject:model7];
    
    CreatTableModel *model8 = [CreatTableModel new];
    model8.cellType = CreateTablePoinTFCell;
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
    model10.placeholder = @"请输入申请原因";

    model10.key = @"CaseReason";
    [self.dataArray addObject:model10];
    [self creatNormalStickerShoesData:YES];

    [self.tableView reloadData];
}
- (void)creatNormalNoStickerShoesTJData{

    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTableTFCell;
    model1.title = @"货号:";
    model1.placeholder = @"请输入货号";
    model1.key = @"ArticleNo";
    [self.dataArray addObject:model1];

    
    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableDownCell;
    model2.title = @"UK尺码：";
    model2.placeholder = @"请输入UK尺码";
    model2.key = @"ArticleSize";
    [self.dataArray addObject:model2];
    
    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTableTFCell;
    model3.title = @"鞋盒数量：";
    model3.placeholder = @"请输入数量";
    model3.key = @"Number";
    [self.dataArray addObject:model3];
    
    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTablePoinTFCell;
    model4.title = @"鞋盒规格：";
    model4.placeholder = @"请输入规格";
    model4.pointTitle = @"鞋盒规格示意图";
    model4.pointDesTitle = @"请参照吊牌信息填写";
    model4.key = @"CartonSize";
    [self.dataArray addObject:model4];
 
    
    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTableDownCell;
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
    model7.placeholder = @"请输入申请原因";
    model7.key = @"CaseReason";
    [self.dataArray addObject:model7];
    [self creatNormalStickerShoesData:YES];

    [self.tableView reloadData];


}
- (void)creatSpecialNoStickerShoesData{
    
    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTableDownCell;
    model1.title = @"UK尺码：";
    model1.placeholder = @"请输入UK尺码";
    model1.key = @"ArticleSize";
    [self.dataArray addObject:model1];
    
    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableTFCell;
    model2.title = @"货号:";
    model2.placeholder = @"请输入货号";
    model2.key = @"ArticleNo";
    [self.dataArray addObject:model2];
    
 
    
    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTablePointDownCell;
    model3.title = @"鞋舌唛上的工厂代号:";
    model3.pointTitle = @"鞋舌唛上的工厂代号示意图";
    model3.pointDesTitle = @"请参照吊牌信息填写";
    model3.placeholder = @"请输入工厂代号";
    model3.key = @"FactoryCode";
    [self.dataArray addObject:model3];
    
    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTableTFCell;
    model4.title = @"鞋盒数量：";
    model4.placeholder = @"请输入数量";
    model4.key = @"Number";
    [self.dataArray addObject:model4];
    
    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTablePoinTFCell;
    model5.title = @"贴纸上的PO号：";
    model5.placeholder = @"请输入PO号";
    model5.pointTitle = @"贴纸上的PO号示意图";
    model5.pointDesTitle = @"请参照吊牌信息填写";
    model5.key = @"PoNumber";
    [self.dataArray addObject:model5];
    
    CreatTableModel *model6 = [CreatTableModel new];
    model6.cellType = CreateTablePoinTFCell;
    model6.title = @"鞋盒规格：";
    model6.placeholder = @"请输入规格";
    model6.pointTitle = @"鞋盒规格示意图";
    model6.pointDesTitle = @"请参照吊牌信息填写";
    model6.key = @"CartonSize";
    [self.dataArray addObject:model6];
    
    CreatTableModel *model7 = [CreatTableModel new];
    model7.cellType = CreateTableDownCell;
    model7.title = @"渠道：";
    model7.placeholder = @"请选择渠道";
    model7.key = @"ArticleChannel";
    [self.dataArray addObject:model7];
    
    CreatTableModel *model8 = [CreatTableModel new];
    model8.cellType = CreateTablePoinTFCell;
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
    model10.placeholder = @"请输入申请原因";

    model10.key = @"CaseReason";
    [self.dataArray addObject:model10];
    [self.tableView reloadData];
    [self creatNormalStickerShoesData:YES];

}

- (void)creatNormalStickerShoesData:(BOOL)creatDic{
    NSMutableArray * temArr ;
    
    if (creatDic) {
        temArr = [NSMutableArray array];
    }

    
    
    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTableDownCell;
    model1.title = @"UK尺码：";
    model1.placeholder = @"请输入UK尺码";
    model1.key = @"ArticleSize";
    [self.dataArray addObject:model1];
    
    if (!creatDic) {
        [self.dataArray addObject:model1];
        
    }else{
        [temArr addObject:model1];
    }
    
    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableTFCell;
    model2.title = @"货号:";
    model2.placeholder = @"请输入货号";
    model2.key = @"ArticleNo";
    if (!creatDic) {
        [self.dataArray addObject:model2];
        
    }else{
        [temArr addObject:model2];
    }
   
    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTablePointDownCell;
    model3.title = @"鞋舌唛上的工厂代号:";
    model3.pointTitle = @"鞋舌唛上的工厂代号示意图";
    model3.pointDesTitle = @"请参照吊牌信息填写";
    model3.placeholder = @"请输入工厂代号";
    model3.key = @"FactoryCode";
    [self.dataArray addObject:model3];
   
    if (!creatDic) {
        [self.dataArray addObject:model3];
        
    }else{
        [temArr addObject:model3];
    }
    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTableTFCell;
    model4.title = @"鞋盒数量：";
    model4.placeholder = @"请输入数量";
    model4.key = @"Number";
    if (!creatDic) {
        [self.dataArray addObject:model4];
        
    }else{
        [temArr addObject:model4];
    }
    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTablePoinTFCell;
    model5.title = @"贴纸上的PO号：";
    model5.placeholder = @"请输入PO号";
    model5.pointTitle = @"贴纸上的PO号示意图";
    model5.pointDesTitle = @"请参照吊牌信息填写";
    model5.key = @"PoNumber";
    if (!creatDic) {
        [self.dataArray addObject:model5];
        
    }else{
        [temArr addObject:model5];
    }
    CreatTableModel *model6 = [CreatTableModel new];
    model6.cellType = CreateTablePoinTFCell;
    model6.title = @"鞋盒规格：";
    model6.placeholder = @"请输入规格";
    model6.pointTitle = @"鞋盒规格示意图";
    model6.pointDesTitle = @"请参照吊牌信息填写";
    model6.key = @"CartonSize";
    if (!creatDic) {
        [self.dataArray addObject:model6];
        
    }else{
        [temArr addObject:model6];
    }
    CreatTableModel *model7 = [CreatTableModel new];
    model7.cellType = CreateTableDownCell;
    model7.title = @"渠道：";
    model7.placeholder = @"请选择渠道";
    model7.key = @"ArticleChannel";
    if (!creatDic) {
        [self.dataArray addObject:model7];
        
    }else{
        [temArr addObject:model7];
    }
    CreatTableModel *model8 = [CreatTableModel new];
    model8.cellType = CreateTablePoinTFCell;
    model8.title = @"鞋舌唛上的IBPO号";
    model8.placeholder = @"请输入IBPO号";
    model8.pointTitle = @"鞋舌唛上的IBPO号示意图";
    model8.pointDesTitle = @"请参照吊牌信息填写";
    model8.key = @"IbpoNumber";
    if (!creatDic) {
        [self.dataArray addObject:model8];
        
    }else{
        [temArr addObject:model8];
    }
    CreatTableModel *model9 = [CreatTableModel new];
    model9.cellType = CreateTableTFCell;
    model9.title = @"贴纸数量";
    model9.placeholder = @"请输入贴纸数量";
    model9.key = @"PasterNumber";
    if (!creatDic) {
        [self.dataArray addObject:model9];
        
    }else{
        [temArr addObject:model9];
    }
    CreatTableModel *model10 = [CreatTableModel new];
    model10.cellType = CreateTablePoinTFCell;
    model10.title = @"鞋舌唛上的生产日期";
    model10.placeholder = @"请输入生产日期";
    model10.pointTitle = @"鞋舌唛上的生产日期示意图";
    model10.pointDesTitle = @"请参照吊牌信息填写";
    model10.key = @"ProductionDate";
    if (!creatDic) {
        [self.dataArray addObject:model10];
        
    }else{
        [temArr addObject:model10];
    }
    CreatTableModel *model11 = [CreatTableModel new];
    model11.cellType = CreateTablePoinTFCell;
    model11.title = @"贴纸上的条形码";
    model11.placeholder = @"请输入条形码";
    model11.pointTitle = @"贴纸上的条形码示意图";
    model11.pointDesTitle = @"请参照吊牌信息填写";
    model11.key = @"PasterEancode";
    if (!creatDic) {
        [self.dataArray addObject:model11];
        
    }else{
        [temArr addObject:model11];
    }
    CreatTableModel *model12 = [CreatTableModel new];
    model12.cellType = CreateTablePoinTFCell;
    model12.title = @"Model Name";
    model12.placeholder = @"请输入Model Name";
    model12.pointTitle = @"Model Name示意图";
    model12.pointDesTitle = @"请参照吊牌信息填写";
    model12.key = @"ModelName";
    if (!creatDic) {
        [self.dataArray addObject:model12];
        
    }else{
        [temArr addObject:model12];
    }
    CreatTableModel *model13 = [CreatTableModel new];
    model13.cellType = CreateTablePointDownCell;
    model13.title = @"性别（请按照贴纸上的描述）";
    model13.placeholder = @"请输入性别";
    model13.pointTitle = @"性别示意图";
    model13.pointDesTitle = @"请按照贴纸上的描述";
    model13.key = @"Gender";
    if (!creatDic) {
        [self.dataArray addObject:model13];
        
    }else{
        [temArr addObject:model13];
    }
    CreatTableModel *model14 = [CreatTableModel new];
    model14.cellType = CreateTablePointDownCell;
    model14.title = @"Category";
    model14.placeholder = @"请选择";
    model14.pointTitle = @"Category示意图";
    model14.pointDesTitle = @"请参照吊牌信息填写";
    model14.key = @"Category";
    if (!creatDic) {
        [self.dataArray addObject:model14];
        
    }else{
        [temArr addObject:model14];
    }
    CreatTableModel *model15 = [CreatTableModel new];
    model15.cellType = CreateTablePoinTFCell;
    model15.title = @"颜色（请按照贴纸上的描述）";
    model15.placeholder = @"请输入颜色";
    model15.pointTitle = @"颜色示意图";
    model15.pointDesTitle = @"请按照贴纸上的描述";
    model15.key = @"Color";
    if (!creatDic) {
        [self.dataArray addObject:model15];
        
    }else{
        [temArr addObject:model15];
    }
    CreatTableModel *model16 = [CreatTableModel new];
    model16.cellType = CreateTablePoinTFCell;
    model16.title = @"帮面材料（请按照贴纸上的描述）";
    model16.placeholder = @"请输入颜色";
    model16.pointTitle = @"帮面材料示意图";
    model16.pointDesTitle = @"请按照贴纸上的描述";
    model16.key = @"UpperMaterial";
    if (!creatDic) {
        [self.dataArray addObject:model16];
        
    }else{
        [temArr addObject:model16];
    }
    CreatTableModel *model17 = [CreatTableModel new];
    model17.cellType = CreateTablePointDownCell;
    model17.title = @"Shoe Width";
    model17.placeholder = @"请选择";
    model17.pointTitle = @"SHoe Width示意图";
    model17.pointDesTitle = @"请按照贴纸上的描述";
    model17.key = @"ShowWidth";
    if (!creatDic) {
        [self.dataArray addObject:model17];
        
    }else{
        [temArr addObject:model17];
    }
    CreatTableModel *model18 = [CreatTableModel new];
    model18.cellType = CreateTablePointDownCell;
    model18.title = @"执行标准";
    model18.placeholder = @"请选择";
    model18.pointTitle = @"执行标准示意图";
    model18.pointDesTitle = @"请按照贴纸上的描述";
    model18.key = @"ExecutiveStandards";
    if (!creatDic) {
        [self.dataArray addObject:model18];
        
    }else{
        [temArr addObject:model18];
    }
    CreatTableModel *model19 = [CreatTableModel new];
    model19.cellType = CreateTablePointDownCell;
    model19.title = @"品名（参看合格证上的描述）";
    model19.pointTitle = @"品名示意图";
    model19.pointDesTitle = @"参看合格证上的描述";
    model19.placeholder = @"请选择";
    model19.key = @"ArticleName";
    if (!creatDic) {
        [self.dataArray addObject:model19];
        
    }else{
        [temArr addObject:model19];
    }
    CreatTableModel *model20 = [CreatTableModel new];
    model20.cellType = CreateTablePointDownCell;
    model20.title = @"大底类型";
    model20.pointTitle = @"大底类型示意图";
    model20.pointDesTitle = @"参看合格证上的描述";
    model20.placeholder = @"请选择";
    model20.key = @"OutsoleType";
    if (!creatDic) {
        [self.dataArray addObject:model20];
        
    }else{
        [temArr addObject:model20];
    }
    CreatTableModel *model21 = [CreatTableModel new];
    model21.cellType = CreateTablePicCell;
    model21.title = @"";
    model21.key = @" PasterEancode";
    if (!creatDic) {
        [self.dataArray addObject:model21];
        
    }else{
        [temArr addObject:model21];
    }
    CreatTableModel *model22 = [CreatTableModel new];
    model22.cellType = CreateTableReMarkCell;
    model22.title = @"";
    model22.placeholder = @"请输入申请原因";
    model22.key = @"CaseReason";
    if (!creatDic) {
        [self.dataArray addObject:model22];
        
    }else{
        [temArr addObject:model22];
    }
    
    if (!creatDic) {
        for (CreatTableModel * model in self.dataArray) {
                if (!IsStrEmpty(model.key)) {
                    [self.saveDic setValue:@"" forKey:model.key];
            }
        }
        [self.tableView reloadData];

    }else{
        for (CreatTableModel * model in temArr) {
            
            if (!IsStrEmpty(model.key)) {
                [self.saveDic setValue:@"" forKey:model.key];
            }
            
        }
        
    }
}




- (IBAction)sureAction:(id)sender {
        for (CreatTableModel * model in self.dataArray) {
            if (model.cellType != CreateTablePicCell) {
                if (!self.saveDic[model.key] || IsStrEmpty(self.saveDic[model.key])) {
                    [self showAlertWithDispear:model.placeholder];
                    return;
                }
            }
          
        }
    if ([[self GetLoginUser].MustPicture isEqualToString:@"Y"]) {
        if (self.picArray.count < 2) {
            [self showAlertWithDispear:@"请上传2张图片"];
            return;
        }
    }
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyy/MM/dd HH:mm";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    [self.saveDic setValue:str forKey:@"NowDate"];
    [self.saveDic setValue:self.picArray.copy forKey:@"ShoeArr"];

    if (self.resultBlock) {
        self.resultBlock(self.saveDic.copy);
        [self backAction];

    }
}



-(CGFloat)tableView:(UITableView *)tableView HeightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatTableModel *model = self.dataArray[indexPath.row];
    switch (model.cellType) {
        case CreateTablePicCell:
            return (PHONE_WIDTH-60)/4+87;
        case CreateTableReMarkCell:
            return 125;
        default:
            return 50;
            break;
    }
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
        if (model.cellType == CreateTableTFCell) {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
            cell.creatTableModel = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textBlock = ^(NSString * _Nullable text) {
                [weakSelf.saveDic setValue:text forKey:model.key];
            };
            
            return cell;
        }else if (model.cellType == CreateTableTFDownCell){
            CreatTFDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatTFDownTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

                cell.creatTableModel = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textBlock = ^(NSString * _Nullable text) {
                    [weakSelf.saveDic setValue:text forKey:model.key];
                };
            cell.dict = self.saveDic;
                cell.block = ^{
                    [weakSelf sheetAler:model.key indexPath:indexPath];
                };
                
            return cell;
        }else if (model.cellType == CreateTablePointDownCell){
            CreatTFPointDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatTFPointDownTableViewCell" forIndexPath:indexPath];
            cell.creatTableModel = model;
            cell.dict = self.saveDic;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textBlock = ^(NSString * _Nullable text) {
                [weakSelf.saveDic setValue:text forKey:model.key];
            };
            cell.block = ^{
                [weakSelf sheetAler:model.key indexPath:indexPath];

            };
            cell.pointBlock = ^{
                [weakSelf getSamplePicture:model];
            };
            
            return cell;
        }else if (model.cellType == CreateTableDownCell){
            CreateDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateDownTableViewCell"forIndexPath:indexPath];
                cell.creatTableModel = model;
                cell.dict = self.saveDic;
                cell.block = ^{
                    [weakSelf sheetAler:model.key indexPath:indexPath];

                };

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else if (model.cellType == CreateTablePoinTFCell){
            CreateTablePointTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateTablePointTFCell"forIndexPath:indexPath];
            cell.creatTableModel = model;
            cell.dict = self.saveDic;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textBlock = ^(NSString * _Nullable text) {
                [weakSelf.saveDic setValue:text forKey:model.key];
            };
          
            cell.pointBlock = ^{
                [weakSelf getSamplePicture:model];

            };
            
            return cell;
        }else if (model.cellType == CreateTablePicCell){
            ApplyPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyPicTableViewCell" forIndexPath:indexPath];
                cell.imageArray = self.picArray;
                cell.pickBlock = ^{
                    [HeadImageManager alertUploadHeaderImageActionSheet:weakSelf imageSuccess:^(UIImage *image) {
                        [weakSelf imagePickerController:image];
                    }];
                };
                cell.deleteBlock = ^(NSInteger index) {
                    [weakSelf DeleteSelectImageWith:index];
                };
                
                cell.bigBlock = ^(NSInteger index) {
                    ImageDetailViewController *controller = [[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:nil];
                    controller.DeleteDelegate = weakSelf ;
                    controller.index = index ;
                    controller.imageData = [weakSelf.picArray objectAtIndex:indexPath.row] ;
                   
                    controller.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:controller animated:NO completion:nil];
                };
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (model.cellType == CreateTableReMarkCell){
            
            RemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkTableViewCell" forIndexPath:indexPath];
            if (self.saveDic[@"CaseReason"]) {
                cell.textView.text = self.saveDic[@"CaseReason"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.textBlock = ^(NSString * _Nullable text) {
                [weakSelf.saveDic setValue:text forKey:model.key];

            };
            return cell;
        }
        
        return [UITableViewCell new];
}


- (void)imagePickerController:(UIImage *)image {
    
    [self ShowSVProgressHUD];
    UIImageOrientation imageOrientation = image.imageOrientation;
    
    if(imageOrientation != UIImageOrientationUp) {
       
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    NSString *imageName = [NSUUID UUID].UUIDString ;
    
    NSString *picPath = [NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName] ;
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    
    if(![fileMannager fileExistsAtPath:picPath]){
        [fileMannager createDirectoryAtPath:picPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
        BOOL res = [UIImageJPEGRepresentation(image, 0.4) writeToFile:[NSString stringWithFormat:@"%@/%@.jpg",picPath,imageName] atomically:YES];
            [self DismissSVProgressHUD];
            if (res) {
                [self.picArray addObject:[NSString stringWithFormat:@"%@/%@.jpg",self.folderName,imageName]];
                
                [self.tableView reloadData];
            }
            else {
                
                [self showAlertWithDispear:@"图片保存失败!"];
                
                if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName]]) {
                    
                    [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName] error:nil];
                }
            }
}
    

- (void)DeleteSelectImageWith:(NSInteger)index {
    
    if ([[self.picArray objectAtIndex:index] isKindOfClass:[NSString class]]) {
        
        NSFileManager* fileMannager = [NSFileManager defaultManager];
        
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.picArray objectAtIndex:index]]]) {
            
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.picArray objectAtIndex:index]] error:nil];
        }
        
       
    }

    [self.picArray removeObjectAtIndex:index] ;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    
}


-(void)sheetAler:(NSString *)title indexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
        if ([title isEqualToString:@"FactoryCode"]) {
            [self getFactory:indexPath];
        }else if ([title isEqualToString:@"ArticleSize"]){
            [self getSize:indexPath];
            
        }else if ([title isEqualToString:@"ArticleChannel"]){
            [self getChannel:indexPath];
            
        }else if ([title isEqualToString:@"Gender"]){
            [self getGender:indexPath];
            
        }else if ([title isEqualToString:@"Category"]){
            [self getCateGory:indexPath];

        }else if ([title isEqualToString:@"ShowWidth"]){
            [self getShoeWidth:indexPath];

        }else if ([title isEqualToString:@"ExecutiveStandards"]){
            [self getExecutiveStandards:indexPath];
        }else if ([title isEqualToString:@"ArticleName"]){
            [self getModelName:indexPath];
        }else if ([title isEqualToString:@"OutsoleType"]){
            [self getOutSole:indexPath];
        }
    
}


#pragma mark ----NetWorking

//渠道
-(void)getChannel:(NSIndexPath *)indexPath{
    MJWeakSelf;

    if (self.channelArr) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.channelArr title:@"请选择渠道"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.channelArr[index] forKey:@"ArticleChannel"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetChannel",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        
        [self DismissSVProgressHUD];
     
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.channelArr = [dict JSONValue][@"FTW"];
                if (self.channelArr) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.channelArr title:@"请选择渠道"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.channelArr[index] forKey:@"ArticleChannel"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
    
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
        
    }];
    
    
}

//工厂
-(void)getFactory:(NSIndexPath *)indexPath{
    MJWeakSelf;
    if (self.factoryArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.factoryArray title:@"请选择工厂"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.factoryArray[index] forKey:@"FactoryCode"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetFactory",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.factoryArray = [dict JSONValue][@"FTW"];
                if (self.factoryArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.factoryArray title:@"请选择工厂"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.factoryArray[index] forKey:@"FactoryCode"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
        
    }];
}

//示例图片
-(void)getSamplePicture:(CreatTableModel *)model{
    MJWeakSelf;
   
    if (self.sampleArr && self.sampleArr.count) {
        [self showPoint:model];
    }
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetSamplePicture",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.sampleArr = [dict JSONValue][@"FTW"];
                if (self.sampleArr) {
                    [self showPoint:model];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
        
    }];
}




-(void)showPoint:(CreatTableModel *)model{
    
    if ([model.key isEqualToString:@"FactoryCode"]) {
        for (NSDictionary * dic in self.sampleArr) {
            if ([dic[@"SampleType"] isEqualToString:@"Factory"]) {
                [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                return;
            }
        }
    }
    if ([model.key isEqualToString:@"PoNumber"]) {
        for (NSDictionary * dic in self.sampleArr) {
            if ([dic[@"SampleType"] isEqualToString:@"PoNumber"]) {
                [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                return;
            }
        }
    }
    if ([model.key isEqualToString:@"IbpoNumber"]) {
        for (NSDictionary * dic in self.sampleArr) {
            if ([dic[@"SampleType"] isEqualToString:@"IbpoNumber"]) {
                [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                return;
            }
        }
    }
    if ([model.key isEqualToString:@"CartonSize"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"CartonSize"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    
    if ([model.key isEqualToString:@"ProductionDate"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"ProductionDate"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    if ([model.key isEqualToString:@"PasterEancode"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"PasterEancode"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    if ([model.key isEqualToString:@"ModelName"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"ModelName"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    if ([model.key isEqualToString:@"Gender"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"Gender"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    
    if ([model.key isEqualToString:@"Category"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"Category"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    if ([model.key isEqualToString:@"Color"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"Color"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    if ([model.key isEqualToString:@"UpperMaterial"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"UpperMaterial"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    
    if ([model.key isEqualToString:@"ShowWidth"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"ShoeWidth"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    if ([model.key isEqualToString:@"ExecutiveStandards"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"ExecutiveStandards"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    if ([model.key isEqualToString:@"ArticleName"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"ArticleName"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
    if ([model.key isEqualToString:@"OutSoleType"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"OutSoleType"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
                }
            }
        }
}
    

//尺码
-(void)getSize:(NSIndexPath *)indexPath{
    MJWeakSelf;
    if (self.sizeArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.sizeArray title:@"请选择尺码"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.sizeArray[index] forKey:@"ArticleSize"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetSize",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.sizeArray = [dict JSONValue][@"FTW"];
                if (self.sizeArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.sizeArray title:@"请选择尺码"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.sizeArray[index] forKey:@"ArticleSize"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
        
    }];
    
   
}

//性别
-(void)getGender:(NSIndexPath *)indexPath{
    MJWeakSelf;
    if (self.genderArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.genderArray title:@"请选择性别"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.genderArray[index] forKey:@"Gender"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetGender",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.genderArray = [dict JSONValue][@"FTW"];
                if (self.genderArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.genderArray title:@"请选择性别"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.genderArray[index] forKey:@"Gender"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
    
}

//cateGory
-(void)getCateGory:(NSIndexPath *)indexPath{
    MJWeakSelf;
    if (self.categoryArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.categoryArray title:@"请选择分类"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.categoryArray[index] forKey:@"CateGory"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetCategory",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.categoryArray = [dict JSONValue][@"FTW"];
                if (self.categoryArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.categoryArray title:@"请选择性别"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.categoryArray[index] forKey:@"CateGory"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
}

//GetShoeWidth

-(void)getShoeWidth:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    if (self.shoeWidthArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.shoeWidthArray title:@"请选择分类"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.shoeWidthArray[index] forKey:@"ShowWidth"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetShoeWidth",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.shoeWidthArray = [dict JSONValue][@"FTW"];
                if (self.shoeWidthArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.shoeWidthArray title:@"请选择shoeWidth"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.shoeWidthArray[index] forKey:@"ShowWidth"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
    
 
}

//GetModelName（品名）
-(void)getModelName:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    if (self.articleNameArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.articleNameArray title:@"请选择品名"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.articleNameArray[index] forKey:@"ArticleName"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetModelName",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.articleNameArray = [dict JSONValue][@"FTW"];
                if (self.articleNameArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.articleNameArray title:@"请选择品名"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.articleNameArray[index] forKey:@"ArticleName"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
    
 
}

//OutSole（大底类型）
-(void)getOutSole:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    if (self.outSoleArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.outSoleArray title:@"请选择大底类型"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.outSoleArray[index] forKey:@"OutSoleType"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetOutsoleType",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.outSoleArray = [dict JSONValue][@"FTW"];
                if (self.outSoleArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.outSoleArray title:@"请选择大底类型"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.outSoleArray[index] forKey:@"outSoleArray"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
    
 
}

//GetExecutiveStandards（执行标准）
-(void)getExecutiveStandards:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    if (self.ExecutiveArr) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.ExecutiveArr title:@"请选择执行标准"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.ExecutiveArr[index] forKey:@"ExecutiveStandards"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetExecutiveStandards",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
            
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSString * dict = responseObject[@"Msg"];
            if (dict) {
                self.ExecutiveArr = [dict JSONValue][@"FTW"];
                if (self.ExecutiveArr) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.ExecutiveArr title:@"请选择标准"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.ExecutiveArr[index] forKey:@"ExecutiveStandards"];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                        
                    };
                    [sheetView showInView:self];
                }
            }
               
        }else {
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
    
  
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
        if (self.dict) {
            _saveDic = [[NSMutableDictionary alloc]initWithDictionary:self.dict];
        }else{
            _saveDic = [NSMutableDictionary dictionary];
        }
    }
    return _saveDic;
}
@end
