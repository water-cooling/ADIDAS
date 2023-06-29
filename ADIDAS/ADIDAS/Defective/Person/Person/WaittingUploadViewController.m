//
//  WaittingUploadViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/26.
//
//

#import "WaittingUploadViewController.h"
#import "GoodRecordCustomCell.h"
#import "XMLFileManagement.h"
#import "SSZipArchive.h"
#import "UIImageView+YYWebImage.h"

@interface WaittingUploadViewController ()<UIAlertViewDelegate>

@end

@implementation WaittingUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"待上传列表" ;
    
    NSArray *uploadArray = [NSMutableArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],NOUPLOADDATA]]];
    
    if (!uploadArray) self.dataArray = [NSArray array];
    else self.dataArray = uploadArray ;
    
    self.recordTableView.dataSource = self ;
    self.recordTableView.delegate = self ;
    self.recordTableView.tableFooterView = [[UIView alloc] init];
    self.recordTableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0) ;
    
    self.currentIndex = 1 ;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadAll)];
    self.navigationItem.rightBarButtonItem = item ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uploadAll {
    
    if ([self.dataArray count] == 0) {
        
        [self showAlertWithDispear:@"当前无待上传数据!"];
    }
    else {
    
        [self uploadAction];
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES ;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete ;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除" ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除这条记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil] ;
        alert.tag = indexPath.row ;
        [alert show];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArray count] ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 71 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    
    GoodRecordCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"GoodRecordCustomCell" owner:self options:nil];
        
        for (UIView *view in nibAry) {
            
            if ([view isKindOfClass:[GoodRecordCustomCell class]]) {
                
                cell = (GoodRecordCustomCell *)view ;
                break ;
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    NSMutableArray *imageAry = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]] error:nil];
    
    for (NSString *file in fileList) {
        
        if ([[file componentsSeparatedByString:@"_"] count] == 2 &&
            [[[file componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"]) {
            
            [imageAry addObject:file] ;
            break ;
        }
    }
    
    if ([imageAry count]) {
    
        cell.goodImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject],[imageAry firstObject]]];
        cell.defaultImageView.hidden = YES ;
    }
    
    else if ([[[[dic allValues] firstObject] valueForKey:@"CasePicture"] count] &&
             ![[[[[[dic allValues] firstObject] valueForKey:@"CasePicture"] firstObject] valueForKey:@"SmallPictureUrl"] isEqualToString:@""]){
        
        [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[[[[dic allValues] firstObject] valueForKey:@"CasePicture"] firstObject] valueForKey:@"SmallPictureUrl"] substringFromIndex:1]]] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}] ;
        cell.defaultImageView.hidden = YES ;
    }
    else {
    
        cell.defaultImageView.hidden = NO ;
        cell.goodImageView.image = nil ;
    }
    
    NSDictionary *valueDic = [[dic allValues] firstObject] ;
    
    cell.createDateLabel.text = [NSString stringWithFormat:@"创建日期：%@",[valueDic valueForKey:@"CreateDate"] ];
    
    if ([[valueDic valueForKey:@"ArtilceNo"] isEqualToString:@""]) {
        
        cell.goodNumberLabel.text = [NSString stringWithFormat:@"货号：待填写"];
    }
    else cell.goodNumberLabel.text = [NSString stringWithFormat:@"货号：%@",[valueDic valueForKey:@"ArtilceNo"]];
    
    if ([[valueDic valueForKey:@"ArtilceSize"] isEqualToString:@""]) {
        
        cell.sizeLabel.text = [NSString stringWithFormat:@"尺码：待填写"];
    }
    else cell.sizeLabel.text = [NSString stringWithFormat:@"尺码：%@",[valueDic valueForKey:@"ArtilceSize"]];
    
    return cell ;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSDictionary *dic = [self.dataArray objectAtIndex:alertView.tag];
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],NOUPLOADDATA]]];
        
        if (historyArray) {
            
            NSMutableArray *lastAry = [NSMutableArray array];
            
            for (NSDictionary *goodDic in historyArray) {
                
                if (![[[goodDic allKeys] firstObject] isEqualToString:[[dic allKeys] firstObject]]) {
                    
                    [lastAry addObject:goodDic] ;
                }
            }
            
            historyArray = [NSMutableArray arrayWithArray:lastAry];
            lastAry = nil ;
            
            
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            
            if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]]]) {
                
                [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]] error:nil];
            }
            
            self.dataArray = [NSArray arrayWithArray:historyArray];
            [historyArray writeToFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],NOUPLOADDATA]] atomically:YES] ;
            [self.recordTableView reloadData] ;
        }
    }
}


- (void)uploadAction {

    [self ShowSVProgressHUD];
    
    NSDictionary *dic = [self.dataArray firstObject] ;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]]])
    {
        [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]] error:nil];
    
    NSMutableArray *imageAry = [NSMutableArray array];
    NSMutableArray *zipFileAry = [NSMutableArray array];
    
    for (NSString *file in fileList) {
        
        if ([[file componentsSeparatedByString:@"_"] count] != 2 &&
            [[[file componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"]) {
            
            [imageAry addObject:file] ;
        }
        
        if ([[[file componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"]) {
            
            [zipFileAry addObject:[NSString stringWithFormat:@"%@/%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject],file]];
        }
    }
    
    NSDictionary *infoDic = [[dic allValues] firstObject] ;
    
    for (NSDictionary *webdic in [infoDic valueForKey:@"CasePicture"]) {
        
        [imageAry addObject:webdic] ;
    }
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    
    NSString* xmlString = [xmlcon CreateDefectiveXmlStringWith:[infoDic valueForKey:@"ArtilceNo"]
                                                   andGoodSize:[infoDic valueForKey:@"ArtilceSize"]
                                                  andGoodCount:[infoDic valueForKey:@"ArtilceQuantity"]
                                                andGoodBuyDate:[infoDic valueForKey:@"SalesDate"]
                                                      andJobNo:[infoDic valueForKey:@"WorkerNumber"]
                                                 andStorePhone:[infoDic valueForKey:@"StorePhone"]
                                                  andRequestor:[infoDic valueForKey:@"Requestor"]
                                                andPostAddress:[infoDic valueForKey:@"PostAddress"]
                                                andStoreLeader:[infoDic valueForKey:@"StoreManagePhone"]
                                                  andStoreMail:[infoDic valueForKey:@"StoreMail"]
                                                   andGoodType:[infoDic valueForKey:@"CaseTitle"]
                                               andGoodDescribe:[infoDic valueForKey:@"CaseComment"]
                                              andMiOrderNumber:[infoDic valueForKey:@"MiOrderNumber"]
                                                     andAllPic:imageAry
                                                       andUser:[self GetLoginUser].UserAccount
                                                    andOrderNo:[infoDic valueForKey:@"CaseNumber"]
                                                   andCaseDate:[infoDic valueForKey:@"CreateDate"]
                                                  andIsSpecial:[infoDic valueForKey:@"IsSpecial"]
                                                      andIsRBK:[infoDic valueForKey:@"IsRBK"]] ;
    
    NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *xmlPath = [NSString stringWithFormat:@"%@/%@/iosupload.xml",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]] ;
    [xmlData writeToFile:xmlPath atomically:YES];
    [zipFileAry addObject:xmlPath];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL result =
        [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/%@/iospacket.zip",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]]
                         withFilesAtPaths:zipFileAry];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result) {
                
                [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 500;
              
                [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@UploadCase&CaseNumber=%@&Token=%@&CaseDate=%@",kWebDefectiveString,[infoDic valueForKey:@"CaseNumber"],[self GetLoginUser].Token,[[[infoDic valueForKey:@"CreateDate"] componentsSeparatedByString:@" "] firstObject]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    [formData appendPartWithFileData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/iospacket.zip",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]]] name:@"zip" fileName:@"iospacket.zip" mimeType:@"application/zip"];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    [self ShowProgressSVProgressHUD:[NSString stringWithFormat:@"正在上传第 %d 条记录",self.currentIndex] andProgress:uploadProgress.completedUnitCount*1.0/uploadProgress.totalUnitCount];
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    if (![responseStr JSONValue]) {
                        NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
                        responseObject = [aesString JSONValue] ;
                    }else {
                        responseObject = [responseStr JSONValue] ;
                    }
                    
                    [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 20;
                    
                    if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
                        
                        NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],NOUPLOADDATA]]];
                        
                        if (historyArray) {
                            
                            NSMutableArray *lastAry = [NSMutableArray array];
                            
                            for (NSDictionary *goodDic in historyArray) {
                                
                                if (![[[goodDic allKeys] firstObject] isEqualToString:[[dic allKeys] firstObject]]) {
                                    
                                    [lastAry addObject:goodDic] ;
                                }
                            }
                            
                            historyArray = [NSMutableArray arrayWithArray:lastAry];
                            lastAry = nil ;
                        }
                        else historyArray = [NSMutableArray array];
                        
                        NSFileManager* fileMannager = [NSFileManager defaultManager];
                        
                        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]]]) {
                            
                            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]] error:nil];
                        }
                        
                        [historyArray writeToFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],NOUPLOADDATA]] atomically:YES] ;
                        
                        self.dataArray = [NSArray arrayWithArray:historyArray] ;
                        
                        [self.recordTableView reloadData];
                        
                        if ([self.dataArray count]) {
                            
                            self.currentIndex += 1 ;
                            [self uploadAction];
                        }
                        else {
                            
                            [self ShowSuccessSVProgressHUD:@"上传成功!"];
                            self.currentIndex = 1 ;
                        }
                    }
                    else {
                        
                        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
                            
                            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                            [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                            [ud synchronize];
                            [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
                        }
                        
                        [self ShowErrorSVProgressHUD:[NSString stringWithFormat:@"第%d条记录上传失败,失败原因:\n%@",self.currentIndex,[responseObject objectForKey:@"Msg"]]];
                        
                        self.currentIndex = 1 ;
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 20;
                    
                    [self ShowErrorSVProgressHUD:[NSString stringWithFormat:@"第%d条记录上传失败,失败原因:\n%@",self.currentIndex,error.localizedDescription]];
                    
                    self.currentIndex = 1 ;
                }];
            }
            else [self ShowErrorSVProgressHUD:@"上传失败,未生成压缩包!"];
        });
    });
}

@end


















