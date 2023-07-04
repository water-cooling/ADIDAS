//
//  NewApplyViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import "ApplyDressViewController.h"
#import "CreatTableModel.h"
#import "TextFieldTableViewCell.h"
#import "CreatTFPointDownTableViewCell.h"
#import "CreatTFDownTableViewCell.h"
#import "CreateTablePointTFCell.h"
#import "DressPicTableViewCell.h"
#import "RemarkTableViewCell.h"
#import "AlerPointPickView.h"
#import "ImageDetailViewController.h"
#import "CommonUtil.h"
#import "CustomSheetAlerView.h"
#import "HeadImageManager.h"
#import "CreateDownTableViewCell.h"
@interface ApplyDressViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,DeleteSelectImageDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableDictionary *saveDic;
@property (nonatomic,strong)NSMutableArray *picArray;
@property (nonatomic,strong)AlerPointPickView *pointView;
@property (nonatomic,strong)NSArray *ExecutiveArr;
@property (nonatomic,strong)NSArray *channelArr;
@property (nonatomic,strong)NSArray *factoryArray;
@property (nonatomic,strong)NSArray *modelNameArray;
@property (nonatomic,strong)NSArray *securityCategoryArray;
@property (nonatomic,strong)NSArray *articleGradeeArr;
@property (nonatomic,strong)NSArray *sampleArr;
@end

@implementation ApplyDressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sureBtn.layer.cornerRadius = 15;
    [self setIOS:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];

    tableViewGesture.numberOfTapsRequired = 1;

    tableViewGesture.cancelsTouchesInView = NO;

    [self.tableView addGestureRecognizer:tableViewGesture];
    
    self.pointView = [[AlerPointPickView alloc]initAlerPointPickView];
    [self creatNormalNoStickerShoesSZData];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreatTFDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreatTFDownTableViewCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"CreatTFPointDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreatTFPointDownTableViewCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"CreateTablePointTFCell" bundle:nil] forCellReuseIdentifier:@"CreateTablePointTFCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DressPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"DressPicTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreateDownTableViewCell"];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"RemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemarkTableViewCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_cn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
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
    self.tableView.contentInset = UIEdgeInsetsMake(-keyBoardRect.size.height-StatusBarAndNavigationBarHeight, 0, 0, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];

}

- (void)creatNormalNoStickerShoesSZData{
    
    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTablePointDownCell;
    model1.title = @"工厂代码:";
    model1.placeholder = @"请选择";
    model1.pointTitle = @"鞋舌唛上的工厂代号示意图";
    model1.pointDesTitle = @"请参照吊牌信息填写";
    model1.key = @"FactoryCode";
    [self.dataArray addObject:model1];
    
    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableTFCell;
    model2.title = @"货号";
    model2.placeholder = @"请输入货号";
    model2.key = @"ArticleNo";
    [self.dataArray addObject:model2];
    
    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTablePointDownCell;
    model3.title = @"产品名称：";
    model3.placeholder = @"请选择";
    model3.pointTitle = @"产品名称示意图";
    model3.pointDesTitle = @"请参照吊牌信息填写";
    model3.key = @"ModelName";
    [self.dataArray addObject:model3];
    
    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTableDownCell;
    model4.title = @"渠道：";
    model4.placeholder = @"请选择";
    model4.key = @"ArticleChannel";
    [self.dataArray addObject:model4];
    
    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTableTFCell;
    model5.title = @"尺码";
    model5.placeholder = @"请输入尺码";
    model5.key = @"ArticleSize";
    [self.dataArray addObject:model5];
    
    CreatTableModel *model6 = [CreatTableModel new];
    model6.cellType = CreateTablePointDownCell;
    model6.title = @"安全类型：";
    model6.placeholder = @"请选择";
    model6.pointTitle = @"安全类型示意图";
    model6.pointDesTitle = @"请参照吊牌信息填写";
    model6.key = @"SecurityCategory";
    [self.dataArray addObject:model6];
    
    CreatTableModel *model7 = [CreatTableModel new];
    model7.cellType = CreateTablePointDownCell;
    model7.title = @"执行标准：";
    model7.placeholder = @"请选择";
    model7.pointTitle = @"执行标准示意图";
    model7.pointDesTitle = @"请参照吊牌信息填写";
    model7.key = @"ExecutiveStandards";
    [self.dataArray addObject:model7];
    
    CreatTableModel *model8 = [CreatTableModel new];
    model8.cellType = CreateTablePointDownCell;
    model8.title = @"产品等级：";
    model8.placeholder = @"请选择";
    model8.pointTitle = @"产品等级示意图";
    model8.pointDesTitle = @"请参照吊牌信息填写";
    model8.key = @"ArticleGrade";
    [self.dataArray addObject:model8];
    
    CreatTableModel *model9 = [CreatTableModel new];
    model9.cellType = CreateTableTFCell;
    model9.title = @"数量：";
    model9.placeholder = @"请输入数量";
    model9.key = @"Number";
    [self.dataArray addObject:model8];
    
    CreatTableModel *model10 = [CreatTableModel new];
    model10.cellType = CreateTablePoinTFCell;
    model10.title = @"条形码编号";
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
    model12.placeholder = @"请输入申请原因";
    model12.key = @"CaseReason";
    [self.dataArray addObject:model12];
    for (CreatTableModel * model in self.dataArray) {
        
        if (!IsStrEmpty(model.key)) {
            [self.saveDic setValue:@"" forKey:model.key];
        }
        
    }
    [self.tableView reloadData];

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
    CreatTableModel *model = self.dataArray[indexPath.row];

    switch (model.cellType) {
        case CreateTablePicCell:
            return (PHONE_WIDTH-60)/4+105;
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.creatTableModel = model;
            cell.dict = self.saveDic;
            cell.textBlock = ^(NSString * _Nullable text) {
                [weakSelf.saveDic setValue:text forKey:model.key];
            };
            
            return cell;
        }else if (model.cellType == CreateTableTFDownCell){
            CreatTFDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatTFDownTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

                cell.creatTableModel = model;
            cell.dict = self.saveDic;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textBlock = ^(NSString * _Nullable text) {
                    [weakSelf.saveDic setValue:text forKey:model.key];
                };
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
        }else if (model.cellType == CreateTablePoinTFCell){
            CreateTablePointTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateTablePointTFCell" forIndexPath:indexPath];
          
            cell.creatTableModel = model;
            cell.dict = self.saveDic;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textBlock = ^(NSString * _Nullable text) {
                [weakSelf.saveDic setValue:text forKey:model.key];
            };
          
            cell.pointBlock = ^{
                [weakSelf.pointView configTitle:model.title destitlte:model.placeholder pic:@""];
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

        }else if (model.cellType == CreateTablePicCell){
            DressPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DressPicTableViewCell" forIndexPath:indexPath];
           
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
                    controller.imageData = [weakSelf.picArray objectAtIndex:index] ;
                   
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
        
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil SysDocumentPath],[[[self.picArray objectAtIndex:index] componentsSeparatedByString:@"_"] firstObject]]]) {
            
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil SysDocumentPath],[[[self.picArray objectAtIndex:index] componentsSeparatedByString:@"_"] firstObject]] error:nil];
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
        }else if ([title isEqualToString:@"ArticleChannel"]){
            [self getChannel:indexPath];
    
        }else if ([title isEqualToString:@"ExecutiveStandards"]){
            [self getExecutiveStandards:indexPath];
        }else if ([title isEqualToString:@"ModelName"]){
            [self getModelName:indexPath];
        }
    
}



#pragma mark ---------------netWorking

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
                self.channelArr = [dict JSONValue][@"APP"];
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
                self.factoryArray = [dict JSONValue][@"APP"];
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

//GetModelName（品名）
-(void)getModelName:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    if (self.modelNameArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.modelNameArray title:@"请选择品名"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.modelNameArray[index] forKey:@"ModelName"];
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
                self.modelNameArray = [dict JSONValue][@"APP"];
                if (self.modelNameArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.modelNameArray title:@"请选择品名"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.modelNameArray[index] forKey:@"ModelName"];
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

//GetSecurityCategory（安全类型）
-(void)getSecurityCategory:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    if (self.securityCategoryArray) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.securityCategoryArray title:@"请选择安全类别"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.securityCategoryArray[index] forKey:@"SecurityCategory"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetSecurityCategory",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
                self.securityCategoryArray = [dict JSONValue][@"APP"];
                if (self.securityCategoryArray) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.securityCategoryArray title:@"请选择安全类别"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.securityCategoryArray[index] forKey:@"SecurityCategory"];
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
                self.ExecutiveArr = [dict JSONValue][@"APP"];
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

//GetArticleGrade(等级)

-(void)GetArticleGrade:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    if (self.articleGradeeArr) {
            CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.articleGradeeArr title:@"请选择等级"];
            sheetView.block = ^(NSInteger index) {
                [weakSelf.saveDic setValue:weakSelf.articleGradeeArr[index] forKey:@"ArticleGrade"];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [sheetView showInView:self];
            return;
        
    }
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [self ShowSVProgressHUD];

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetArticleGrade",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
                self.articleGradeeArr = [dict JSONValue][@"APP"];
                if (self.articleGradeeArr) {
                    CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:self.articleGradeeArr title:@"请选择标准"];
                    sheetView.block = ^(NSInteger index) {
                        [weakSelf.saveDic setValue:weakSelf.articleGradeeArr[index] forKey:@"ArticleGrade"];
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
   
    if (self.sampleArr) {
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
                self.sampleArr = [dict JSONValue][@"APP"];
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
    if ([model.key isEqualToString:@"SecurityCategory"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"SecurityCategory"]) {
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
    if ([model.key isEqualToString:@"ArticleGrade"]) {
                for (NSDictionary * dic in self.sampleArr) {
                    if ([dic[@"SampleType"] isEqualToString:@"ArticleGrade"]) {
                        [self.pointView configTitle:model.pointTitle destitlte:model.pointDesTitle pic:dic[@"PictureUrl"]];
                    return;
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
        if (self.picArray.count < 1) {
            [self showAlertWithDispear:@"请上传一张图片"];
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
