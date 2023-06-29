//
//  ApplyShoesViewController.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import "ApplyShoesViewController.h"
#import "ApplyListTableViewCell.h"
#import "CommonUtil.h"
#import "NewApplyViewController.h"
#import "ApplyDressViewController.h"
#import "ComponentViewController.h"
#import "XMLFileManagement.h"
#import "SSZipArchive.h"
@interface ApplyShoesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ApplyShoesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请单" ;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_cn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.addBtn.layer.cornerRadius = 15;
    self.totalLab.text = [NSString stringWithFormat:@"本箱当前已保存货号%ld",self.dataArray.count];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, 24, 8)] ;
    [closeButton setTitle:@"上传" forState:0];
    [closeButton addTarget:self action:@selector(OpenPull) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyListTableViewCell"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view from its nib.
}

-(void)backAction{
  
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)OpenPull{
    
    if (self.dataArray.count == 0) {
        [self showAlertWithDispear:@"请完善信息"];
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    NSMutableArray *zipFileAry = [NSMutableArray array];

    if(![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName]]){
        [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString = [xmlcon applyMain:self.dict PicArr:self.picArr CustomerCode:[self GetLoginUser].UserAccount DesArr:self.dataArray];

    NSLog(@"xmlString%@",xmlString);
    NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *xmlPath = [NSString stringWithFormat:@"%@/%@/iosupload.xml",[CommonUtil SysDocumentPath],self.folderName] ;
    [xmlData writeToFile:xmlPath atomically:YES];
    [zipFileAry addObject:xmlPath];
    
    for (NSString *path in self.picArr) {
        [zipFileAry addObject:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],path]];
    }
    
    for(NSDictionary *desDict in self.dataArray){
       
        NSArray *desPicArr =  desDict[@"ShoeArr"];
        for (NSString *Despath in desPicArr) {
            [zipFileAry addObject:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],Despath]];
        }

    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result =
        [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/%@/iospacket.zip",[CommonUtil SysDocumentPath],self.folderName]
                         withFilesAtPaths:zipFileAry];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 500;
                
                [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@UploadCase&CaseNumber=%@&Token=%@",KWebEHDefectiveString,self.dict[@"CaseNumber"]?self.dict[@"CaseNumber"]:@"",[self GetLoginUser].Token] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    [formData appendPartWithFileData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/iospacket.zip",[CommonUtil SysDocumentPath],self.folderName]] name:@"zip" fileName:@"iospacket.zip" mimeType:@"application/zip"];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    [self ShowProgressSVProgressHUD:[NSString stringWithFormat:@"正在上传"] andProgress:uploadProgress.completedUnitCount*1.0/uploadProgress.totalUnitCount];
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"originalRequest%@",task.originalRequest);
                    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    if (![responseStr JSONValue]) {
                        NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
                        responseObject = [aesString JSONValue] ;
                    }else {
                        responseObject = [responseStr JSONValue] ;
                    }
                    
                    [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 20;
                    NSLog(@"responseObject%@",responseObject);
                    if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
                      
                        [self ShowSuccessSVProgressHUDForTen:@"上传成功！我们会在3个工作日内回复。"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.tabBarController.selectedIndex = 0;
                            [self.navigationController popToRootViewControllerAnimated:YES] ;
                            if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName]]) {
                                
                                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName] error:nil];
                            }
                        });
                        
                        
                        
                    }
                    else {
                        
                        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
                            
                            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                            [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                            [ud synchronize];
                            [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
                        }
                        
                        [self ShowErrorSVProgressHUD:[responseObject objectForKey:@"Msg"]];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName]]) {
                        
                        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderName] error:nil];
                    }
                    
                    [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 20;
                    
                    [self DismissSVProgressHUD];
                    
                    [self showAlertWithDispear:error.localizedDescription];
                }];
            }
            else [self ShowErrorSVProgressHUD:@"上传失败,未生成压缩包!"];
        });
    });
    
    
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApplyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyListTableViewCell"forIndexPath:indexPath];
    NSDictionary * dict = self.dataArray[indexPath.row];
  
    cell.orderTimeLab.text = dict[@"NowDate"];
    cell.orderNumerLab.text = dict[@"ArticleNo"];
           
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MJWeakSelf;
    switch (self.detailType) {
        case NewDetailShoe:{
            NewApplyViewController * shoeDetailVc = [[NewApplyViewController alloc]initWithNibName:@"NewApplyViewController" bundle:nil];
            shoeDetailVc.title = self.title;
            shoeDetailVc.resultBlock = ^(NSDictionary * _Nonnull dict) {
                weakSelf.dataArray[indexPath.row] = dict;
                weakSelf.totalLab.text = [NSString stringWithFormat:@"本箱当前已保存货号%ld",weakSelf.dataArray.count];

                [weakSelf.tableView reloadData];

            };
            if (self.isNormalShoe) {
                if ([self.dict[@"CaseCategory"] isEqualToString:@"鞋盒(不含鞋盒上的贴纸)"]){
                    shoeDetailVc.type = normalNoStickerShoesSZ;
                }else{
                    shoeDetailVc.type = normalStickerShoesSZ;
                }
            }else{
                if ([self.dict[@"CaseCategory"] isEqualToString:@"鞋盒(不含鞋盒上的贴纸)"]){
                    shoeDetailVc.type = specialNoStickerShoes;
                }
                
            }
            shoeDetailVc.dict = self.dataArray[indexPath.row];
            [self.navigationController pushViewController:shoeDetailVc animated:YES];
        }
            break;
        case NewDetailDress:{
            ApplyDressViewController * dressDetailVc = [[ApplyDressViewController alloc]initWithNibName:@"ApplyDressViewController" bundle:nil];
            dressDetailVc.title = self.title;

            dressDetailVc.resultBlock = ^(NSDictionary * _Nonnull dict) {
                weakSelf.dataArray[indexPath.row] = dict;
                weakSelf.totalLab.text = [NSString stringWithFormat:@"本箱当前已保存货号%ld",weakSelf.dataArray.count];

                [weakSelf.tableView reloadData];

            };
            dressDetailVc.dict = self.dataArray[indexPath.row];

            [self.navigationController pushViewController:dressDetailVc animated:YES];
        }
            break;
                
        case NewDetailComponent:{
            ComponentViewController * componentVc = [[ComponentViewController alloc]initWithNibName:@"ComponentViewController" bundle:nil];
            componentVc.title = self.title;

            componentVc.resultBlock = ^(NSDictionary * _Nonnull dict) {
                weakSelf.dataArray[indexPath.row] = dict;
                weakSelf.totalLab.text = [NSString stringWithFormat:@"本箱当前已保存货号%ld",weakSelf.dataArray.count];

                [weakSelf.tableView reloadData];

            };
            componentVc.dict = self.dataArray[indexPath.row];
            [self.navigationController pushViewController:componentVc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (IBAction)newDetailAction:(UIButton *)sender {
    MJWeakSelf;
    switch (self.detailType) {
        case NewDetailShoe:{
            NewApplyViewController * shoeDetailVc = [[NewApplyViewController alloc]initWithNibName:@"NewApplyViewController" bundle:nil];
            shoeDetailVc.title = self.title;
            shoeDetailVc.folderName = self.folderName;
            shoeDetailVc.resultBlock = ^(NSDictionary * _Nonnull dict) {
                [weakSelf.dataArray addObject:dict];
                weakSelf.totalLab.text = [NSString stringWithFormat:@"本箱当前已保存货号%ld",weakSelf.dataArray.count];

                [weakSelf.tableView reloadData];
            };
            if (self.isNormalShoe) {
                if ([self.dict[@"CaseCategory"] isEqualToString:@"鞋盒(不含鞋盒上的贴纸)"]){
                    NSString * shopping = self.dict[@"ShippingNumber"];
                    if (!IsStrEmpty(shopping)) {
                        if([[shopping substringToIndex:1] isEqualToString:@"T"]|| [[shopping substringToIndex:1] isEqualToString:@"t"]){
                            shoeDetailVc.type = normalNoStickerShoesTJ;
                        }else{
                            shoeDetailVc.type = normalNoStickerShoesSZ;
                        }
                    }else{
                        shoeDetailVc.type = normalNoStickerShoesSZ;
                    }
                }else{
                    shoeDetailVc.type = normalStickerShoesSZ;
                }
            }else{
                    shoeDetailVc.type = specialNoStickerShoes;
                    
            }
    
            [self.navigationController pushViewController:shoeDetailVc animated:YES];
        }
            break;
        case NewDetailDress:{
            ApplyDressViewController * dressDetailVc = [[ApplyDressViewController alloc]initWithNibName:@"ApplyDressViewController" bundle:nil];
            dressDetailVc.folderName = self.folderName;

            dressDetailVc.resultBlock = ^(NSDictionary * _Nonnull dict) {
                [weakSelf.dataArray addObject:dict];
                weakSelf.totalLab.text = [NSString stringWithFormat:@"本箱当前已保存货号%ld",weakSelf.dataArray.count];

                [weakSelf.tableView reloadData];
                

            };
            [self.navigationController pushViewController:dressDetailVc animated:YES];
        }
            break;
                
        case NewDetailComponent:{
            ComponentViewController * componentVc = [[ComponentViewController alloc]initWithNibName:@"ComponentViewController" bundle:nil];
            componentVc.folderName = self.folderName;
            componentVc.resultBlock = ^(NSDictionary * _Nonnull dict) {
                [weakSelf.dataArray addObject:dict];
                weakSelf.totalLab.text = [NSString stringWithFormat:@"本箱当前已保存货号%ld",weakSelf.dataArray.count];

                [weakSelf.tableView reloadData];

            };
            [self.navigationController pushViewController:componentVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}



@end
