//
//  EcAddProductViewController.m
//  MobileApp
//
//  Created by Connor Gui on 2022/3/22.
//

#import "EcAddProductViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRScanningViewController.h"
#import "ZRTakeVideoViewController.h"
#import "PreviewerVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZRMediaCaptureController.h"
#import "ZRVideoPlayerController.h"
#import "ZRAssetExportSession.h"
#import "ZRCircleProgress.h"
#import "ZRWaterPrintComposition.h"
#import "XMLFileManagement.h"
#import "SSZipArchive.h"
#import "GoodImageCustomCell.h"
#import "UIImageView+YYWebImage.h"
#import "ImageDetailViewController.h"


@interface EcAddProductViewController ()<OpenDetailDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DeleteSelectImageDelegate,UITextFieldDelegate>

@end

@implementation EcAddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"申请单" ;
    self.selectedIndex = -1;
    if (self.dataDic) {
        self.transactionOrderTextField.enabled = false;
        self.transactionOrderTextField.text = [NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"ExpressNo"]];
        self.typeTextField.text = [NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"CaseTitle"]];
        
        NSMutableArray *temp1 = [NSMutableArray array];
        NSMutableArray *temp2 = [NSMutableArray array];
        if ([self.dataDic valueForKey:@"AttachmentFiles"]&&![[self.dataDic valueForKey:@"AttachmentFiles"] isEqual:[NSNull null]]&&[[self.dataDic valueForKey:@"AttachmentFiles"] count] > 0) {
            
            for (NSDictionary *path in [self.dataDic valueForKey:@"AttachmentFiles"] ) {
                NSString *first = [NSString stringWithFormat:@"%@",[path valueForKey:@"AttachmentFile"]];
                if ([first.lowercaseString containsString:@"mp4"]) {
                    [temp2 addObject:first];
                }
                if ([first.lowercaseString containsString:@"jpg"]) {
                    [temp1 addObject:first];
                }
            }
        }
        self.webVideoUrlArray = [NSArray arrayWithArray:temp2];
        self.webUrlArray = [NSArray arrayWithArray:temp1];
    } else {
        self.transactionOrderTextField.delegate = self;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    }
    self.bgScrollView.contentSize = CGSizeMake(10, 700);
    self.imageCollectView.dataSource = self;
    self.imageCollectView.delegate = self;
    self.videoCollectView.dataSource = self;
    self.videoCollectView.delegate = self;
    self.imageArray = [NSMutableArray array];
    self.videoArray = [NSMutableArray array];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)clearAction:(id)sender {
    if (self.dataDic) return;
    self.typeTextField.text = @"" ;
}

- (IBAction)selectTypeAction:(id)sender {
    if (self.dataDic) return;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择残次类型" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *btn in [CacheManagement instance].listEcCaseTitle) {
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:btn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.typeTextField.text = btn;
        }];
        [ac addAction:ac1];
    }
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:ac2];
    [self presentViewController:ac animated:YES completion:nil];
    
    
}

- (void)openBarCode:(NSString *)barcode {
    
    self.transactionOrderTextField.text = barcode;
}

- (IBAction)ScanAction:(id)sender {
    if (self.dataDic) return;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        QRScanningViewController *vc = [[QRScanningViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES ;
                        vc.delegate = self ;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showRemindAlertWithMessage:@"您拒绝了访问相机权限"];
                    });
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            QRScanningViewController *vc = [[QRScanningViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES ;
            vc.delegate = self ;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在 [设置 - 隐私 - 相机 - Mobile Solution] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在 [设置 - 通用 - 访问限制 - 相机] 允许访问相机" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}



- (void) openCamera {
    
    ZRTakeVideoViewController *takeVideo = [[ZRTakeVideoViewController alloc] init];
    takeVideo.averageBitRate = 4.0;
    [takeVideo setCaptureCompletion:^(int statusCode, NSString *errorMessage, NSURL *videoURL, NSTimeInterval videoInterval) {
        NSLog(@"视频地址：%@", videoURL.absoluteString);

        if (errorMessage.length) {
            NSLog(@"拍摄视频失败 %@", errorMessage);
        } else {
            [self calculateFizeSize:videoURL];
        }
    }];
    takeVideo.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:takeVideo animated:YES completion:nil];
}


- (void) backAction {
    
    if ([self.transactionOrderTextField.text isEqualToString:@""]) {
        [self showAlertWithDispear:@"请输入运单号"];
        return;
    }
    
    if ([self.typeTextField.text isEqualToString:@""]) {
        [self showAlertWithDispear:@"请选择残次类型"];
        return;
    }
    
    int total = 0;
    if (!self.videoArray||[self.videoArray count] == 0) {
        total += 1;
    }
    
    if (!self.imageArray||[self.imageArray count] == 0) {
        total += 1;
    }
    
    if (total == 2) {
        [self showAlertWithDispear:@"请拍摄视频或者照片"];
    }
    
    [self uploadData];
    
}


- (void)calculateFizeSize:(NSURL *)playURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    int random = arc4random();
    NSString* videoPathCopy = [NSString stringWithFormat:@"%@/%d.mp4", path, abs(random)];

    BOOL success = [fileManager copyItemAtURL:playURL toURL:[NSURL fileURLWithPath:videoPathCopy isDirectory:NO] error:&error];
    if (!success) {
        success = [fileManager copyItemAtPath:playURL.absoluteString toPath:videoPathCopy error:&error];
    }
    NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:videoPathCopy error:&error];
    long fileSize = [[fileAttr objectForKey:NSFileSize] longValue];
    NSString *bytes = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    float fileMB = fileSize / 1024.0 / 1024.0;
    NSLog(@"压缩前视频文件大小 fileMB = %lf   bytes=%@", fileMB, bytes);
    
    if (self.selectedIndex >= 0&&self.videoArray.count > self.selectedIndex) {
        [self.videoArray replaceObjectAtIndex:self.selectedIndex withObject:videoPathCopy];
    } else {
        [self.videoArray addObject:videoPathCopy];
    }
    [self.videoCollectView reloadData];
}



- (void)previewVideoByURL:(NSURL *)url {
    ZRVideoPlayerController *moviePlayer = [[ZRVideoPlayerController alloc] initWithURL:url];
    moviePlayer.playVideOnly = YES;
    moviePlayer.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:moviePlayer animated:NO completion:nil];
}



- (UIImage*)getVideoFirstViewImage:(NSURL *)path {
  
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
  AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  
  assetGen.appliesPreferredTrackTransform = YES;
  CMTime time = CMTimeMakeWithSeconds(0.0, 600);
  NSError *error = nil;
  CMTime actualTime;
  CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
  UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
  CGImageRelease(image);
  return videoImage;
}


- (void)uploadData {
    
    NSMutableArray *zipFileAry = [NSMutableArray array];
    
    for (NSString *path in self.imageArray) {
        [zipFileAry addObject:[[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],path] stringByReplacingOccurrencesOfString:@"_s" withString:@""]];
    }
    for (NSString *path in self.videoArray) {
        [zipFileAry addObject:path];
    }
    [self ShowSVProgressHUD];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/EC",[CommonUtil SysDocumentPath]]])
    {
        [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/EC",[CommonUtil SysDocumentPath]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString = [xmlcon CreateECDefectiveXmlStringWith:self.typeTextField.text
                                                    andExpressNo:self.transactionOrderTextField.text
                                                    andVideoName:self.videoArray
                                                    andImageName:self.imageArray
                                                       andUser:[self GetLoginUser].UserAccount
                                                   andCaseDate:[CommonUtil NSDateToNSString:[NSDate date]]];
    
    NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *xmlPath = [NSString stringWithFormat:@"%@/EC/iosupload.xml",[CommonUtil SysDocumentPath]] ;
    [xmlData writeToFile:xmlPath atomically:YES];
    [zipFileAry addObject:xmlPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result =
        [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/EC/iospacket.zip",[CommonUtil SysDocumentPath]]
                         withFilesAtPaths:zipFileAry];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result) {
                
                [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 500;
                
                [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@UploadCase&CaseNumber=&Token=%@&CaseDate=%@",kWebECDefectiveString,[self GetLoginUser].Token,[[[CommonUtil NSDateToNSString:[NSDate date]] componentsSeparatedByString:@" "] firstObject]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    [formData appendPartWithFileData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/EC/iospacket.zip",[CommonUtil SysDocumentPath]]] name:@"zip" fileName:@"iospacket.zip" mimeType:@"application/zip"];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    [self ShowProgressSVProgressHUD:[NSString stringWithFormat:@"正在上传"] andProgress:uploadProgress.completedUnitCount*1.0/uploadProgress.totalUnitCount];
                    
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
                        
                        @try {
                            
                            
    
                        } @catch (NSException *exception) {
                            
                            NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};
                            
                            [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@UserLoinOut",kWebDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                                [ud synchronize];
                                
                                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
                            
                        } @finally {}
                        
                        [self ShowSuccessSVProgressHUD:@"上传成功！"];
                        
                        [CacheManagement instance].toHomeFlag = YES;
                        [self.navigationController popViewControllerAnimated:NO] ;
                        
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
                    
                    [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 20;
                    
                    [self DismissSVProgressHUD];
                    
                    [self showAlertWithDispear:error.localizedDescription];
                }];
            }
            else [self ShowErrorSVProgressHUD:@"上传失败,未生成压缩包!"];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [CacheManagement instance].toHomeFlag = YES;
}

- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.videoCollectView) {
        
        if (self.webVideoUrlArray) {
            return [self.webVideoUrlArray count] ;
        }
        if ([self.videoArray count] == 3) return 3 ;
        return 1 + [self.videoArray count] ;
    }
    
    if (self.webUrlArray) {
        return [self.webUrlArray count] ;
    }
    if ([self.imageArray count] == 50) return 50 ;
    return 1 + [self.imageArray count] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView == self.videoCollectView) {
        
        [collectionView registerClass:[GoodImageCustomCell class] forCellWithReuseIdentifier:@"cell"];
        GoodImageCustomCell *cell = (GoodImageCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        if ([self.webVideoUrlArray count]) {
        
            cell.bgView.hidden = YES ;
            cell.goodImageView.image = [self getVideoPreViewImage:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[self.webVideoUrlArray objectAtIndex:indexPath.row] substringFromIndex:1]]]];
            return cell ;
        }
        
        cell.bgView.hidden = !(indexPath.row == [self.videoArray count]) ;
        
        if ([self.videoArray count] > indexPath.row) {
            
            cell.goodImageView.image = [self getVideoFirstViewImage:[NSURL fileURLWithPath:[self.videoArray objectAtIndex:indexPath.row]]];
        }
        else cell.goodImageView.image = nil ;
        
        return cell ;
    }
    
    
    [collectionView registerClass:[GoodImageCustomCell class] forCellWithReuseIdentifier:@"cell"];
    GoodImageCustomCell *cell = (GoodImageCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([self.webUrlArray count]) {
    
        cell.bgView.hidden = YES ;
        
        [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[self.webUrlArray objectAtIndex:indexPath.row] substringFromIndex:1]]] placeholder:nil] ;
        
        return cell ;
    }
    
    cell.bgView.hidden = !(indexPath.row == [self.imageArray count]) ;
    
    if ([self.imageArray count] > indexPath.row) {
        
        id oj = [self.imageArray objectAtIndex:indexPath.row];
        
        if ([oj isKindOfClass:[NSString class]]) {
        
            UIImage *few = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.imageArray objectAtIndex:indexPath.row]]] ;
            
            cell.goodImageView.image = few ;
        }
        
        if ([oj isKindOfClass:[NSDictionary class]]) {
            
            if (![[[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"SmallPictureUrl"] isEqualToString:@""]) {
                
                [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"SmallPictureUrl"] substringFromIndex:1]]] placeholder:nil] ;
            }
            else if (![[[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] isEqualToString:@""]) {
                
                [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] substringFromIndex:1]]] placeholder:nil] ;
            }
        }
        
    }
    else cell.goodImageView.image = nil ;
    
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(75.0/320*(PHONE_WIDTH),75.0/320*(PHONE_WIDTH)) ;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10 ;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0 ;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.videoCollectView) {
        
        if ([self.webVideoUrlArray count]) {
        
            [self previewVideoByURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[self.webVideoUrlArray objectAtIndex:indexPath.row] substringFromIndex:1]]]];
            return ;
        }
        
        if (indexPath.row == [self.videoArray count]) {
            self.selectedIndex = -1;
            [self openCamera];
        }
        else {
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择操作" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"更换视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.selectedIndex = indexPath.row;
                [self openCamera];
            }];
            [ac addAction:ac1];
            
            UIAlertAction *ac3 = [UIAlertAction actionWithTitle:@"播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self previewVideoByURL:[NSURL fileURLWithPath:[self.videoArray objectAtIndex:indexPath.row]]];
            }];
            [ac addAction:ac3];
            UIAlertAction *ac4 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.videoArray removeObjectAtIndex:indexPath.row];
                [self.videoCollectView reloadData];
            }];
            [ac addAction:ac4];
            UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [ac addAction:ac2];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
        return;
    }
    
    if ([self.webUrlArray count]) {
    
        ImageDetailViewController *controller = [[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:nil];
        controller.infoDic =  @{@"PictureUrl":[self.webUrlArray objectAtIndex:indexPath.row]} ;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:NO completion:nil];
        
        return ;
    }
    
    if (indexPath.row == [self.imageArray count]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init]  ;
        picker.delegate = self;
        @try {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera ;
        } @catch (NSException *exception) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
        }
        picker.navigationBar.backgroundColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
        picker.navigationBar.barTintColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
        [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        [picker.navigationBar setTintColor:[UIColor whiteColor]];
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else {
        
        ImageDetailViewController *controller = [[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:nil];
        
        controller.DeleteDelegate = self ;
        
        controller.index = indexPath.row ;
        
        id oj = [self.imageArray objectAtIndex:indexPath.row];
        
        if ([oj isKindOfClass:[NSString class]]) {
            
            controller.imageData = [self.imageArray objectAtIndex:indexPath.row] ;
        }
        
        if ([oj isKindOfClass:[NSDictionary class]]) {
        
            controller.imageData = [[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] ;
        }
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:NO completion:nil];
    }
}

- (void)DeleteSelectImageWith:(NSInteger)index {
    
    if ([[self.imageArray objectAtIndex:index] isKindOfClass:[NSString class]]) {
        
        NSFileManager* fileMannager = [NSFileManager defaultManager];
        
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.imageArray objectAtIndex:index]]]) {
            
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.imageArray objectAtIndex:index]] error:nil];
        }
        
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil SysDocumentPath],[[[self.imageArray objectAtIndex:index] componentsSeparatedByString:@"_"] firstObject]]]) {
            
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil SysDocumentPath],[[[self.imageArray objectAtIndex:index] componentsSeparatedByString:@"_"] firstObject]] error:nil];
        }
    }

    [self.imageArray removeObjectAtIndex:index] ;
    
    [self.imageCollectView reloadData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self ShowSVProgressHUD];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
    
    UIImageOrientation imageOrientation = image.imageOrientation;
    
    if(imageOrientation != UIImageOrientationUp) {
       
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    CGSize size = CGSizeMake(133, 100);
    if(image.size.width < image.size.height) size = CGSizeMake(100, 133);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
     
    NSString *imageName = [NSUUID UUID].UUIDString ;
    
    NSString *picPath = [NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],@"EcDefective"] ;
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    
    if(![fileMannager fileExistsAtPath:picPath])
    {
        [fileMannager createDirectoryAtPath:picPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        BOOL res = [UIImageJPEGRepresentation(image, 0.4) writeToFile:[NSString stringWithFormat:@"%@/%@.jpg",picPath,imageName] atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self DismissSVProgressHUD];
            
            if (res) {
                
                [self.imageArray addObject:[NSString stringWithFormat:@"%@/%@_s.jpg",@"EcDefective",imageName]];
                [UIImagePNGRepresentation(reSizeImage) writeToFile:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName] atomically:YES];
                
                [self.imageCollectView reloadData];
                
                CGRect frame = self.imageCollectView.frame;
                frame.size.height = (75.0/320*(PHONE_WIDTH) + 10) *(self.imageArray.count/3+1);
                self.imageCollectView.frame = frame;
                self.bgScrollView.contentSize = CGSizeMake(10, frame.size.height + frame.origin.y + 15);
            }
            else {
                
                [self showAlertWithDispear:@"图片保存失败!"];
                
                if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName]]) {
                    
                    [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName] error:nil];
                }
            }
        });
    });
}


@end
