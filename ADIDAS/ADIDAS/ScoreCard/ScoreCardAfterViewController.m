//
//  ScoreCardAfterViewController.m
//  MobileApp
//
//  Created by 桂康 on 2017/12/7.
//

#import "ScoreCardAfterViewController.h"
#import "CommonDefine.h"
#import "TakePhotoListCell.h"
#import "SqliteHelper.h"
#import "UIImage+resize.h"
#import "Utilities.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"
#import "VMIstScoreCardEntity.h"
#import "UIImageView+YYWebImage.h"
#import "UIViewController+MJPopupViewController.h"

@interface ScoreCardAfterViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource,installcellDelegate>

@end

@implementation ScoreCardAfterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = SYSLanguage? @"After Photos" : @"After 照片" ;
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    locationview.image = [UIImage imageNamed:@"loactionbg.png"];
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEWIDTH-30, 40)];
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor =[UIColor clearColor];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.tag = 111;
    locationlabel.text = [CacheManagement instance].currentStore.StoreName;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];
    CGRect af = self.ImageBGView.frame ;
    af.size.width = DEWIDTH ;
    af.size.height = DEWIDTH/320.0*293.0;
    self.ImageBGView.frame = af ;
    self.checkPhotoIdArray = [self getAllCheckPhotoId];
    self.AfterTableView.delegate = self ;
    self.AfterTableView.dataSource = self ;
    self.AfterTableView.contentInset = UIEdgeInsetsMake(42, 0, 0, 0) ;
    self.AfterTableView.tableFooterView = [[UIView alloc] init];
    self.dataSourceArray = [self getAllPhoto];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL ischange = NO ;
    
    NSDictionary *result = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    NSString* beforePath = [result valueForKey:@"PHOTO_PATH1"] ;
    NSString* afterPath = [result valueForKey:@"PHOTO_PATH2"] ;
    NSString* beforePathWeb = [result valueForKey:@"PHOTO_WEB_PATH1"] ;
    NSString* afterPathWeb = [result valueForKey:@"PHOTO_WEB_PATH2"] ;
    NSString* beforePathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH1"] ;
    NSString* afterPathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH2"] ;
    
    
    if ((![beforePath isEqualToString:@""])&&(![beforePath isEqualToString:@"0"])&&(beforePath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:newfile]) {
            
            ischange = YES ;
        }
    }
    
    if ((![afterPath isEqualToString:@""])&&(![afterPath isEqualToString:@"0"])&&(afterPath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[afterPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:newfile]) {
            
            ischange = YES ;
        }
    }
    
    
    if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1)
    {
        if (beforePathWebUpload&&[beforePathWebUpload isEqualToString:@"1"]) {
            
            ischange = YES ;
        }
    }
    
    if ((![afterPathWeb isEqualToString:@""])&&(![afterPathWeb isEqualToString:@"0"])&&(afterPathWeb != nil)&&[afterPathWeb length] > 1)
    {
        if (afterPathWebUpload&&[afterPathWebUpload isEqualToString:@"1"]) {
            
            ischange = YES ;
        }
    }
    
    if (ischange) return 78 + 20 ;
    
    return 78 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    
    TakePhotoListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TakePhotoListCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.leftDetailButton.hidden = YES ;
    cell.rightDetailButton.hidden = YES ;
    cell.addNewbtn.hidden = YES ;
    cell.doneImage.hidden= YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.indexType = indexPath.row ;
    
    NSDictionary *result = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [result valueForKey:@"PHOTO_ZONE_NAME_CN"] ;
    cell.delegate = self ;
    
    cell.rightBtn.enabled = YES ;
    cell.rightBtn.hidden = NO ;
    cell.leftBtn.enabled = YES ;
    cell.leftBtn.hidden = NO ;
    [cell.before setImage:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"sbefore.png"]];
    [cell.after setImage:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"safter.png"]];
    
    
    NSString* beforePath = [result valueForKey:@"PHOTO_PATH1"] ;
    NSString* afterPath = [result valueForKey:@"PHOTO_PATH2"] ;
    
    NSString* beforePathWeb = [result valueForKey:@"PHOTO_WEB_PATH1"] ;
    NSString* afterPathWeb = [result valueForKey:@"PHOTO_WEB_PATH2"] ;
    NSString* beforePathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH1"] ;
    NSString* afterPathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH2"] ;
    
    
    if ((![beforePath isEqualToString:@""])&&(![beforePath isEqualToString:@"0"])&&(beforePath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:newfile]) {
            
            [cell.before setImage:[[UIImage imageWithContentsOfFile:newfile]scaleToSize:CGSizeMake(50, 50)] ];
            cell.leftDetailButton.hidden = NO ;
        }
    }
    
    if ((![afterPath isEqualToString:@""])&&(![afterPath isEqualToString:@"0"])&&(afterPath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[afterPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:newfile]) {
            
            [cell.after setImage:[[UIImage imageWithContentsOfFile:newfile] scaleToSize:CGSizeMake(50, 50)]];
            cell.rightDetailButton.hidden = NO ;
        }
    }
    
    
    if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1)
    {
        if (beforePathWebUpload&&[beforePathWebUpload isEqualToString:@"1"]) {
            
            [cell.before yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[beforePathWeb substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
            cell.leftDetailButton.hidden = NO ;
        }
    }
    
    if ((![afterPathWeb isEqualToString:@""])&&(![afterPathWeb isEqualToString:@"0"])&&(afterPathWeb != nil)&&[afterPathWeb length] > 1)
    {
        if (afterPathWebUpload&&[afterPathWebUpload isEqualToString:@"1"]) {
            
            [cell.after yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[afterPathWeb substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
            cell.rightDetailButton.hidden = NO ;
        }
    }
    
    return cell;
}

- (NSArray *)getAllPhoto {
    
    NSMutableArray *photo = [NSMutableArray array];
    
    NSString *where = @"" ;
    
    for (VMIstScoreCardEntity* checkScoreEntity in self.checkPhotoIdArray) {
        
        if ([where isEqualToString:@""]) {
            
            where = [NSString stringWithFormat:@"'%@'",checkScoreEntity.SCORECARD_CHECK_PHOTO_ID];
        }
        else {
            
            where = [NSString stringWithFormat:@"%@,'%@'",where,checkScoreEntity.SCORECARD_CHECK_PHOTO_ID];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_PHOTO_ZONE where SCORECARD_CHECK_PHOTO_ID in (%@) and SCORE_CARD_TYPE = 'D'",where];
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            if (([rs stringForColumn:@"PHOTO_PATH1"]&&![[rs stringForColumn:@"PHOTO_PATH1"] isEqualToString:@""]&&[[rs stringForColumn:@"PHOTO_PATH1"] length] > 5)||([rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]&&![[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"] isEqual:[NSNull null]]&&[[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"] isEqualToString:@"1"])) {
                
                NSDictionary *result = @{@"PHOTO_PATH1":[rs stringForColumn:@"PHOTO_PATH1"]?[rs stringForColumn:@"PHOTO_PATH1"]:@"",
                                         @"PHOTO_PATH2":[rs stringForColumn:@"PHOTO_PATH2"]?[rs stringForColumn:@"PHOTO_PATH2"]:@"",
                                         @"PHOTO_WEB_PATH1":[rs stringForColumn:@"PHOTO_WEB_PATH1"]?[rs stringForColumn:@"PHOTO_WEB_PATH1"]:@"",
                                         @"PHOTO_WEB_PATH2":[rs stringForColumn:@"PHOTO_WEB_PATH2"]?[rs stringForColumn:@"PHOTO_WEB_PATH2"]:@"",
                                         @"PHOTO_UPLOAD_PATH1":[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]:@"",
                                         @"PHOTO_UPLOAD_PATH2":[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]:@"",
                                         @"PHOTO_ZONE_NAME_CN":[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]?[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]:@"",
                                         @"SCORECARD_CHECK_PHOTO_ID":[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]?[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]:@""} ;
                [photo addObject:result] ;
            }
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)[rs close];
    }
    
    return photo ;
}

- (void)addNew:(id)cell {
    
}

- (void)openCamera:(NSInteger)index beforeafter:(int)type {
    
    self.currentSelectType =  [NSString stringWithFormat:@"%d",type] ;
    self.currentSelectIndex = index ;
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    if(!self.photoPicker) self.photoPicker = [[UIImagePickerController alloc]init];
    self.photoPicker.sourceType = sourceType;
    self.photoPicker.delegate = self;
    self.photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.photoPicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (ISFROMEHK) {
        
        EditPicViewController *controller = [[EditPicViewController alloc] initWithNibName:@"EditPicViewController" bundle:nil];
        
        controller.delegate = self ;
        controller.selectedImage = image ;
        
        if ([[info allKeys] containsObject:@"UIImagePickerControllerReferenceURL"]) {
            
            [picker pushViewController:controller animated:YES];
        }
        else {
            
            [picker dismissViewControllerAnimated:YES completion:^{
                
                UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
                [item setTitle:@""] ;
                self.navigationItem.backBarButtonItem = item ;
                
                controller.isPushFrom = YES ;
                [self.navigationController pushViewController:controller animated:YES];
            }];
        }
        
        return ;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:image delegate:self dataSource:self] ;
    editor.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:editor animated:YES completion:nil];
}

#pragma mark - WBGImageEditorDelegate
- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {
    
    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self setImageValueWith:image];
}

- (void)imageEditorDidCancel:(WBGImageEditor *)editor {
    
}

- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
    return @[];
}

- (void)selectPicWith:(UIImage *)img {
    
    [self.photoPicker dismissViewControllerAnimated:YES completion:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    
    [Utilities saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(img) completionBlock:^
     {}
                          failureBlock:^(NSError *error)
     {
         //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
         dispatch_async(dispatch_get_main_queue(), ^{
             
             //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
             if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
                 
                 
             }
         });
     }];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
}

- (void)setImageValueWith:(UIImage *)image {
    
    NSDictionary *result = [self getCurrentItem:self.currentSelectIndex];
    
    NSString *dateStr = [Utilities DateNow];
    
    if (self.commentDate) dateStr = self.commentDate ;
    
    NSString *path = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],dateStr,[CacheManagement instance].currentStore.StoreCode,[NSString stringWithFormat:@"SCORECARD_D"],[Utilities GetUUID]];
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    
    if(![fileMannager fileExistsAtPath:path])
    {
        [fileMannager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [fileMannager removeItemAtPath:path error:nil] ;
    
    [Utilities saveImage:image imgPath:path];
    
    
    NSString *column_name = @"" ;
    NSString *column_name_web = @"" ;
    
    if ([self.currentSelectType isEqualToString:@"1"]) {
        
        column_name_web = @"PHOTO_UPLOAD_PATH1" ;
        column_name = @"PHOTO_PATH1" ;
        
        NSString *oldFile = [result valueForKey:@"PHOTO_PATH1"];
        
        if ([fileMannager fileExistsAtPath:oldFile]) {
            
            [fileMannager removeItemAtPath:oldFile error:nil] ;
        }
    }
    
    if ([self.currentSelectType isEqualToString:@"2"]) {
        
        column_name_web = @"PHOTO_UPLOAD_PATH2" ;
        column_name = @"PHOTO_PATH2" ;
        
        NSString *oldFile = [result valueForKey:@"PHOTO_PATH2"];
        
        if ([fileMannager fileExistsAtPath:oldFile]) {
            
            [fileMannager removeItemAtPath:oldFile error:nil] ;
        }
    }
    
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_IST_SCORECARD_PHOTO_ZONE SET %@ = '%@', %@='0' where PHOTO_ZONE_NAME_CN = '%@' and SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = 'D'",column_name,path,column_name_web,[[self.dataSourceArray objectAtIndex:self.currentSelectIndex] valueForKey:@"PHOTO_ZONE_NAME_CN"],[[self.dataSourceArray objectAtIndex:self.currentSelectIndex] valueForKey:@"SCORECARD_CHECK_PHOTO_ID"]];
    
    [db executeUpdate:sql_];
    
    self.dataSourceArray = [self getAllPhoto];
    [self.AfterTableView reloadData];
}

- (NSDictionary *)getCurrentItem:(NSInteger)index {
    
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_PHOTO_ZONE where PHOTO_ZONE_NAME_CN = '%@' and SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = 'D'",[[self.dataSourceArray objectAtIndex:index] valueForKey:@"PHOTO_ZONE_NAME_CN"],[[self.dataSourceArray objectAtIndex:index] valueForKey:@"SCORECARD_CHECK_PHOTO_ID"]];
    
    NSDictionary *result = nil ;
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            result = @{@"PHOTO_PATH1":[rs stringForColumn:@"PHOTO_PATH1"]?[rs stringForColumn:@"PHOTO_PATH1"]:@"",
                       @"PHOTO_PATH2":[rs stringForColumn:@"PHOTO_PATH2"]?[rs stringForColumn:@"PHOTO_PATH2"]:@"",
                       @"PHOTO_WEB_PATH1":[rs stringForColumn:@"PHOTO_WEB_PATH1"]?[rs stringForColumn:@"PHOTO_WEB_PATH1"]:@"",
                       @"PHOTO_WEB_PATH2":[rs stringForColumn:@"PHOTO_WEB_PATH2"]?[rs stringForColumn:@"PHOTO_WEB_PATH2"]:@"",
                       @"PHOTO_UPLOAD_PATH1":[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]:@"",
                       @"PHOTO_UPLOAD_PATH2":[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]:@"",
                       @"PHOTO_ZONE_NAME_CN":[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]?[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]:@"",
                       @"SCORECARD_CHECK_PHOTO_ID":[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]?[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]:@""} ;
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)[rs close];
    }
    
    return result ;
}

- (NSArray *)getAllCheckPhotoId {
    
    NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE = 'D' ORDER BY SCORECARD_CHECK_PHOTO_ID",[CacheManagement instance].currentVMCHKID];
    
    NSMutableArray *cateArray = [NSMutableArray array];
    
    FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    while ([rs_ next])
    {
        VMIstScoreCardEntity* checkScoreEntity = [[VMIstScoreCardEntity alloc]initWithFMResultSet:rs_];
        
        [cateArray addObject:checkScoreEntity];
    }
    
    [rs_ close];
    
    return cateArray ;
}

- (void)showDetailImage:(NSInteger)index beforeafter:(int)type {
    
    NSDictionary *result = [self.dataSourceArray objectAtIndex:index];

    
    NSString* beforePath = [result valueForKey:@"PHOTO_PATH1"] ;
    NSString* afterPath = [result valueForKey:@"PHOTO_PATH2"] ;
    
    NSString* beforePathWeb = [result valueForKey:@"PHOTO_WEB_PATH1"] ;
    NSString* afterPathWeb = [result valueForKey:@"PHOTO_WEB_PATH2"] ;
    NSString* beforePathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH1"] ;
    NSString* afterPathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH2"] ;
    
    
    if ((![beforePath isEqualToString:@""])&&(![beforePath isEqualToString:@"0"])&&(beforePath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:newfile]) {
            
            if(type == 1) [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile]];
        }
    }
    
    if ((![afterPath isEqualToString:@""])&&(![afterPath isEqualToString:@"0"])&&(afterPath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[afterPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:newfile]) {
            
            if(type == 2) [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile] ];
        }
    }
    
    
    if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1)
    {
        if (beforePathWebUpload&&[beforePathWebUpload isEqualToString:@"1"]) {
            
            if(type == 1) [self.bigImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[beforePathWeb substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
        }
    }
    
    
    if ((![afterPathWeb isEqualToString:@""])&&(![afterPathWeb isEqualToString:@"0"])&&(afterPathWeb != nil)&&[afterPathWeb length] > 1)
    {
        if (afterPathWebUpload&&[afterPathWebUpload isEqualToString:@"1"]) {
            
            if(type == 2) [self.bigImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[afterPathWeb substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
        }
    }
    
    [self presentPopupView:self.ImageBGView];
}


@end
