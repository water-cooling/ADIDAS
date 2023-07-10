//
//  NewAddProductViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import "NewAddProductViewController.h"
#import "CreatTableModel.h"
#import "ImageDetailViewController.h"
#import "TextFieldTableViewCell.h"
#import "CreateDownTableViewCell.h"
#import "NewUploadPicCustomCell.h"
#import "CustomSheetAlerView.h"
#import "AlerShoeView.h"
#import "CommonUtil.h"
#import "ApplyShoesViewController.h"
#import "ApplyDressViewController.h"
#import "ComponentViewController.h"
#import "HeadImageManager.h"
@interface NewAddProductViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableDictionary *saveDic;
@property (nonatomic,strong)NSMutableArray *picArray;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)CreatTableModel *templeModel;
@property (nonatomic,strong)UIButton *nextVideoButton;
@property (nonatomic,strong)NSString *folderName;;

@end

@implementation NewAddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.folderName = [NSUUID UUID].UUIDString ;

    self.listTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    self.navigationItem.title = @"申请单" ;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_cn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

       
    [self.view addSubview:self.bottomView];
    [self creatData];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view).offset(-TabbarSafeBottomMargin);
    }];

    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];

    tableViewGesture.numberOfTapsRequired = 1;

    tableViewGesture.cancelsTouchesInView = NO;

    [self.listTableView addGestureRecognizer:tableViewGesture];
}

-(void)keyboardWillShow:(NSNotification *)note{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.listTableView.contentInset = UIEdgeInsetsMake(0,0,keyBoardRect.size.height,0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.listTableView.contentInset = UIEdgeInsetsZero;
}

-(void)backAction{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否退出编辑" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSFileManager *fileManager = [NSFileManager defaultManager] ;

        if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName]]) {
            
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName] error:nil];
        }
        self.tabBarController.selectedIndex = 0 ;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirmAction];
    [alertVC addAction:cancelAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];

}




- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];

}

- (void)creatData{
    CreatTableModel *model1 = [CreatTableModel new];
    model1.cellType = CreateTableTFCell;
    model1.title = @"补寄地址:";
    model1.placeholder = @"请输入补寄地址";
    [self.saveDic setValue:[self GetLoginUser].Address forKey:@"Address"];
    model1.value = [self GetLoginUser].Address;
    model1.key = @"Address";
    [self.dataArr addObject:model1];
    
    CreatTableModel *model2 = [CreatTableModel new];
    model2.cellType = CreateTableTFCell;
    model2.title = @"联系人姓名：";
    model2.placeholder = @"请输入联系人姓名";
    model2.value = [self GetLoginUser].LinkMan;
    [self.saveDic setValue:[self GetLoginUser].Address forKey:@"ContacePerson"];
    model2.key = @"ContacePerson";
    [self.dataArr addObject:model2];
    
    CreatTableModel *model3 = [CreatTableModel new];
    model3.cellType = CreateTableTFCell;
    model3.title = @"电话：";
    model3.placeholder = @"请输入电话";
    model3.value = [self GetLoginUser].LinkTel;
    [self.saveDic setValue:[self GetLoginUser].Address forKey:@"ContaceNumber"];
    model3.key = @"ContaceNumber";
    [self.dataArr addObject:model3];
    
    CreatTableModel *model4 = [CreatTableModel new];
    model4.cellType = CreateTableTFCell;
    model4.title = @"箱号：";
    model4.isNumerKeyBoard = YES;
    model4.placeholder = @"请输入箱号";
    model4.key = @"CartonNumber";
    [self.dataArr addObject:model4];
  
    
    CreatTableModel *model5 = [CreatTableModel new];
    model5.cellType = CreateTableDownCell;
    model5.title = @"外箱是否完好：";
    model5.placeholder = @"请选择外箱是否完好";
    model5.key = @"CartonStatus";
    [self.dataArr addObject:model5];
    
    self.templeModel = [CreatTableModel new];
    self.templeModel.cellType = CreateTableDownCell;
    self.templeModel.title = @"运单是否已备注破损";
    self.templeModel.placeholder = @"请选择备注类别";
    self.templeModel.key = @"IsRemark";
    
    CreatTableModel *model6 = [CreatTableModel new];
    model6.cellType = CreateTableTFCell;
    model6.title = @"运单号：";
    model6.placeholder = @"请输入运单号";
    model6.key = @"ShippingNumber";
    [self.dataArr addObject:model6];

    
    CreatTableModel *model7 = [CreatTableModel new];
    model7.cellType = CreateTableDownCell;
    model7.title = @"品种";
    model7.placeholder = @"请选择品种";
    model7.key = @"Division";
    [self.dataArr addObject:model7];

    
    CreatTableModel *model8 = [CreatTableModel new];
    model8.cellType = CreateTableDownCell;
    model8.title = @"补发类别";
    model8.placeholder = @"请选择补发类别";
    model8.key = @"CaseCategory";
    [self.dataArr addObject:model8];
    
    
    CreatTableModel *model9 = [CreatTableModel new];
    model9.cellType = CreateTablePicCell;
    model9.title = @"";
    model9.placeholder = @"";
    model9.key = @"";
    [self.dataArr addObject:model9];
    
    for (CreatTableModel * model in self.dataArr) {
        if (!IsStrEmpty(model.key)) {
            [self.saveDic setValue:@"" forKey:model.key];

        }
        
    }
    [self.saveDic setValue:@"" forKey:@"IsRemark"];
    [self.saveDic setValue:@"" forKey:@"ShowCartonType"];

}

#pragma mark---------tableView delegate


-(CGFloat)tableView:(UITableView *)tableView HeightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatTableModel *model = self.dataArr[indexPath.row];

    switch (model.cellType) {
        case CreateTableTFCell:
            return 50;
            break;
        case CreateTableDownCell:
            return 50;
            break;
        case CreateTablePicCell:
            return (PHONE_WIDTH-40)/3*2+90;
        default:
            break;
    }
    return 49;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatTableModel *model = self.dataArr[indexPath.row];
    MJWeakSelf;
        if (model.cellType == CreateTableTFCell) {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
            cell.creatTableModel = model;
            cell.dict = self.saveDic;
            cell.textBlock = ^(NSString * _Nullable text) {
                [weakSelf.saveDic setValue:text forKey:model.key];
            };
            
            return cell;
        }else if (model.cellType == CreateTableDownCell){
            CreateDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateDownTableViewCell"forIndexPath:indexPath];
                cell.creatTableModel = model;
                cell.dict = self.saveDic;
                cell.block = ^{
                    [weakSelf sheetAler:indexPath];
                  
                };

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else if (model.cellType == CreateTablePicCell){
            
            NewUploadPicCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewUploadPicCustomCell" forIndexPath:indexPath];
         
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
                    controller.imageData = [weakSelf.picArray objectAtIndex:index];
                   
                    controller.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:controller animated:NO completion:nil];
                };
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            return cell;
        }
        
        return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)sheetAler:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    MJWeakSelf;
    CreatTableModel *model = self.dataArr[indexPath.row];
    NSString *title;
    NSArray * titleArr;
    if (model.cellType == CreateTableDownCell) {
        if ([model.key isEqualToString:@"CartonStatus"]) {
            title = @"请选择外箱";
            titleArr = @[@"完好",@"破损"];
        }else if ([model.key isEqualToString:@"Division"]){
            title = @"请选择品种";
            titleArr = @[@"鞋类",@"服装",@"配件"];
            
        }else if ([model.key isEqualToString:@"CaseCategory"]){
            title = @"请选择补发类型";
            if ([self.saveDic[@"Division"] isEqualToString:@"鞋类"]) {
                titleArr = @[@"鞋盒(不含鞋盒上的贴纸)",@"鞋盒(含条形码贴纸和合格证贴纸)"];
            }else if ([self.saveDic[@"Division"] isEqualToString:@"服装"]) {
                titleArr = @[@"吊牌封皮和合格证吊牌(含条形码)"];
            }else if ([self.saveDic[@"Division"] isEqualToString:@"配件"]){
                titleArr = @[@"合格证贴纸(含条形码)"];
            }
            
        }else if ([model.key isEqualToString:@"IsRemark"]){
            title = @"请选择备注类型";
            titleArr = @[@"已备注",@"未备注"];
            
        }else{
            
        }
        CustomSheetAlerView * sheetView = [[CustomSheetAlerView alloc]initWithList:titleArr title:model.title];
        sheetView.block = ^(NSInteger index) {
            if ([titleArr[index] isEqualToString:@"破损"]) {
                if ([weakSelf.saveDic[model.key] isEqualToString:@"破损"]) {
                }else{
                    [weakSelf.dataArr insertObject:self.templeModel atIndex:5];
                }
            }else if ([titleArr[index] isEqualToString:@"完好"]){
                [weakSelf.dataArr removeObject:self.templeModel];
            }else if ([titleArr[index] isEqualToString:@"鞋盒(不含鞋盒上的贴纸)"]){
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请将原鞋盒上的贴纸撕下，贴至补发的新鞋盒上使用" message:@"" preferredStyle:UIAlertControllerStyleAlert];
               
                    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [ac addAction:ac1];
                
                UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [ac addAction:ac2];
                [weakSelf presentViewController:ac animated:YES completion:nil];
                
            }
            [weakSelf.listTableView reloadData];

            [weakSelf.saveDic setValue:titleArr[index] forKey:model.key];

        };
        [sheetView showInView:self];
    }
}


- (void)imagePickerController:(UIImage *)image{
    
    [self ShowSVProgressHUD];
    
    
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
                
                [self.listTableView reloadData];
            }
            else {
                
                [self showAlertWithDispear:@"图片保存失败!"];
                
                if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName]]) {
                    
                    [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName] error:nil];
                }
            }
}

-(void)nextVideoButtonAction{
    
    if (!self.saveDic[@"Address"] || IsStrEmpty(self.saveDic[@"Address"])) {
        [self showAlertWithDispear:@"请填入地址"];
        return;
    }
    if (!self.saveDic[@"ContacePerson"]|| IsStrEmpty(self.saveDic[@"ContacePerson"])) {
        [self showAlertWithDispear:@"请填入姓名"];
        return;
    }
    if (!self.saveDic[@"ContaceNumber"]|| IsStrEmpty(self.saveDic[@"ContaceNumber"])) {
        [self showAlertWithDispear:@"请填入电话"];
        return;
    }
    if (!self.saveDic[@"CartonNumber"]|| IsStrEmpty(self.saveDic[@"CartonNumber"])) {
        [self showAlertWithDispear:@"请填入箱号"];
        return;
    }
    if (!self.saveDic[@"CartonStatus"]|| IsStrEmpty(self.saveDic[@"CartonStatus"])) {
        [self showAlertWithDispear:@"选择外箱"];
        return;
    }
    if ( [self.saveDic[@"CartonStatus"] isEqualToString:@"破损"]){
        if (!self.saveDic[@"IsRemark"]|| IsStrEmpty(self.saveDic[@"IsRemark"])) {
            [self showAlertWithDispear:@"请选择备注破损"];
            return;
        }
    }
    if (!self.saveDic[@"ShippingNumber"]|| IsStrEmpty(self.saveDic[@"ShippingNumber"])) {
        [self showAlertWithDispear:@"请填入运单号"];
        return;
    }
    if (!self.saveDic[@"Division"]||IsStrEmpty(self.saveDic[@"Division"])) {
        [self showAlertWithDispear:@"请选择品种"];
        return;
    }
    if (!self.saveDic[@"CaseCategory"]|| IsStrEmpty(self.saveDic[@"CaseCategory"])) {
        [self showAlertWithDispear:@"选择补发类别"];
        return;
    }
    if ([[self GetLoginUser].MustPicture isEqualToString:@"Y"]) {
        if (self.picArray.count < 6) {
            [self showAlertWithDispear:@"请上传外箱6个面的照片"];
            return;
        }
    }
    
    MJWeakSelf;
    if ([self.saveDic[@"Division"] isEqualToString:@"鞋类"]) {
        AlerShoeView * aler = [[AlerShoeView alloc]initAlerShoeView];
        aler.sureBlock = ^{
            ApplyShoesViewController * shoeDetailVc = [ApplyShoesViewController new];
            shoeDetailVc.folderName = weakSelf.folderName;
            shoeDetailVc.isNormalShoe = YES;
            [weakSelf.saveDic setValue:@"普通鞋盒" forKey:@"ShowCartonType"];
            shoeDetailVc.title = weakSelf.saveDic[@"CartonNumber"];
            
            shoeDetailVc.dict = weakSelf.saveDic.copy;
            shoeDetailVc.picArr = weakSelf.picArray.copy;
            shoeDetailVc.detailType = NewDetailShoe;
            [weakSelf.navigationController pushViewController:shoeDetailVc animated:YES];
        };
        aler.cancelBlock = ^{
            ApplyShoesViewController * shoeDetailVc = [[ApplyShoesViewController alloc]initWithNibName:@"ApplyShoesViewController" bundle:nil];
            [weakSelf.saveDic setValue:@"特殊鞋盒" forKey:@"ShowCartonType"];
            shoeDetailVc.title = weakSelf.saveDic[@"CartonNumber"];
            
            shoeDetailVc.dict = weakSelf.saveDic.copy;
            shoeDetailVc.picArr = weakSelf.picArray.copy;

            shoeDetailVc.folderName = weakSelf.folderName;
            shoeDetailVc.isNormalShoe = NO;
            shoeDetailVc.detailType = NewDetailShoe;
            [weakSelf.navigationController pushViewController:shoeDetailVc animated:YES];
        };
        [aler show];

    }else if ([self.saveDic[@"Division"] isEqualToString:@"服装"]){
        ApplyShoesViewController * shoeDetailVc = [ApplyShoesViewController new];
        shoeDetailVc.isNormalShoe = YES;
        shoeDetailVc.folderName = self.folderName;
        shoeDetailVc.title = weakSelf.saveDic[@"CartonNumber"];
        shoeDetailVc.dict = weakSelf.saveDic.copy;
        shoeDetailVc.picArr = weakSelf.picArray.copy;

        shoeDetailVc.detailType = NewDetailDress;
        [weakSelf.navigationController pushViewController:shoeDetailVc animated:YES];
            
    }else{
        ApplyShoesViewController * shoeDetailVc = [ApplyShoesViewController new];
        shoeDetailVc.title = weakSelf.saveDic[@"CartonNumber"];
        shoeDetailVc.folderName = self.folderName;
        shoeDetailVc.detailType = NewDetailComponent;
        shoeDetailVc.dict = weakSelf.saveDic.copy;
        shoeDetailVc.picArr = weakSelf.picArray.copy;

        [weakSelf.navigationController pushViewController:shoeDetailVc animated:YES];
        
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
    NSInteger rowIndex = [self.listTableView numberOfRowsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex-1 inSection:0];
    [self.listTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        self.nextVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView addSubview:self.nextVideoButton];
        [self.nextVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextVideoButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.nextVideoButton.backgroundColor = [CommonUtil colorWithHexString:@"#2355E6"];
        [self.nextVideoButton setTitle:@"下一步" forState:UIControlStateNormal];
        self.nextVideoButton.layer.cornerRadius = 15;
        self.nextVideoButton.layer.masksToBounds = YES;
        [self.nextVideoButton addTarget:self action:@selector(nextVideoButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.nextVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(_bottomView.mas_right).offset(-14);
                    make.centerY.equalTo(self.bottomView);
                    make.size.mas_equalTo(CGSizeMake(90, 35));
        }];
    }
    return _bottomView;
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

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
