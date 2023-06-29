//
//  InStallViewController.m
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import "CampaignPopViewController.h"
#import "AppDelegate.h"
#import "CommonDefine.h"
#import "Utilities.h"
#import "JSON.h"
#import "InstallNoteTableViewCell.h"
#import "CacheManagement.h"
#import "ASIHTTPRequest.h"
#import "XMLFileManagement.h"
#import "SqliteHelper.h"
#import "UIImageView+YYWebImage.h"
#import "CampaignListCustomCell.h"
#import "CommonUtil.h"
#import "ReviewDetailImageViewController.h"
#import "InstallCampaignPhotoViewController.h"

@interface CampaignPopViewController ()<SubmitDelegate>

@end

@implementation CampaignPopViewController
@synthesize campaignPopTable;
@synthesize campaignID;
@synthesize campaignPopList;
@synthesize Recordull;
@synthesize uploadmanagement;

//#pragma mark cell delegate
-(void)openCamera:(UIImagePickerController *)picker
{
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)showLargePic:(NSString *)pic_name {
    // 先判断本地是否有缓存
    self.largepicView.hidden = NO;
    self.largepicView.imageview.image = nil;
    [self.view bringSubviewToFront:self.largepicView];
    
    if ([[pic_name componentsSeparatedByString:@"Documents/dataCaches"] count] == 2) {
        
        [self.largepicView.imageview setImage:[UIImage imageWithContentsOfFile:pic_name]];
        self.largepicView.progressview.hidden = YES;
        return ;
    }
   
    NSString* imagePathString = [NSString stringWithFormat:@"%@/Library/Caches/images%@", NSHomeDirectory(), pic_name];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePathString]) {
        // remove 0 size file
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePathString error:nil];
        unsigned long long fileSize = [attributes fileSize];
        if (fileSize == 0) {
            [[NSFileManager defaultManager] removeItemAtPath:imagePathString error:nil];
        }
        else
        {
            [self.largepicView.imageview setImage:[UIImage imageWithContentsOfFile:imagePathString]];
            NSLog(@"从本地读取");
            self.largepicView.progressview.hidden = YES;
            
            return;
        }
    }
    self.largepicView.progressview.hidden = NO;
    [self.largepicView updateProgress:0.1];
    
    [self sendHttpRequest:pic_name withAddress:imagePathString];
}

// 下载图片同步方法
- (void) sendHttpRequest:(NSString *)urlString withAddress:(NSString *)path {
    ASIHTTPRequest*  request = nil;
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",kWebMobileHeadString,urlString];
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request setValidatesSecureCertificate:NO];
    
    Recordull = 0;
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [request addRequestHeader:@"Authorization"
                        value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode] ];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        
        Recordull += size;//Recordull全局变量，记录已下载的文件的大小
        
        CGFloat pro = (double_t)Recordull/total;
        [self.largepicView updateProgress:pro];

    }];

    [request startSynchronous];
    
    NSError *error = [request error];
    NSData *response = nil;
    if (!error) {
        response = [request responseData];
    }
    [HUD hideUIBlockingIndicator];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    [[NSFileManager defaultManager] createFileAtPath:path contents:response attributes:nil];
    [self.largepicView.imageview setImage:[UIImage imageWithData:response]];
}

-(void)Hidden
{
    self.largepicView.hidden = YES;
}


-(void)showAc:(UIActionSheet *)ac
{
    [ac showInView:self.view];
}

-(void)configCellHeightWithReason:(NSInteger)index
{
    if (index == 3) // 展示原因输入框
    {
        self.height = 177;
//        NSArray* arr =  [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
//        [self.campaignPopTable reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
        [self.campaignPopTable reloadData];
    }
    else
    {
        self.height = 120;
//        NSArray* arr =  [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
//        [self.campaignPopTable reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
        [self.campaignPopTable reloadData];
    }
}


#pragma mark - tableview delegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WID, 44)];
    headview.backgroundColor = [UIColor whiteColor];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    //    label.textColor = [UIColor colorWithRed:246 green:200 blue:11 alpha:1];
    label.textColor = SYS_YELLOW;
    label.font = [UIFont systemFontOfSize:20];
    label.text = SYSLanguage?@"Material list": @"活动物料列表";
    
    UIImageView* backimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WID, 44)];
    backimageview.image = [UIImage imageNamed:@"headbg.png"];
    [headview addSubview:backimageview];
    [headview sendSubviewToBack:backimageview];
    [headview addSubview:label];
    return headview;

}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier_1 = @"wendy";
    static NSString* identifier_2 = @"cell";
    InstallNoteTableViewCell* cell_1;
    if (indexPath.row == 0)
    {
        cell_1 = [tableView dequeueReusableCellWithIdentifier:identifier_1];
        if (nil == cell_1)
        {
            cell_1 = [[[NSBundle mainBundle]loadNibNamed:@"InstallNoteTableViewCell" owner:self options:nil]objectAtIndex:0];
            cell_1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell_1.delegate = self;
            cell_1.isDelay = self.isDelay;
            cell_1.textview.text = [CacheManagement instance].campComment;
            cell_1.textfield.text = [CacheManagement instance].campReason;
            cell_1.reasontextview.text = [CacheManagement instance].campReasonNote;
            if ([cell_1.textfield.text isEqualToString:@"其他，请说明原因"])
            {
                self.height = 177;
                cell_1.reasonview.hidden = NO;
            }
            if ([cell_1.textfield.text length] >0)
            {
                cell_1.reasonholderlabel.hidden = YES;
            }
            if ([cell_1.textview.text length] > 0)
            {
                cell_1.holderlabel.hidden = YES;
            }
        }
        if (self.height == 177) {
            cell_1.commentViewFrame = CGRectMake(10, 98, DEWIDTH-20, 68);
        }
        else
        {
            cell_1.commentViewFrame = CGRectMake(10, 42, DEWIDTH-20, 68);
        }
        return  cell_1;
    }
    else
    {
        CampaignListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_2];
        
        if (cell == nil) {
            
            NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"CampaignListCustomCell" owner:self options:nil];
            
            for (UIView *view in nibAry) {
                
                if ([view isKindOfClass:[CampaignListCustomCell class]]) {
                    cell = (CampaignListCustomCell *)view ;
                    break ;
                }
            }
        }
        
        @try {
            cell.delegate = self ;
            cell.photoLabel.hidden = YES ;
            CampaignPopData *campData = [self.self.campaignPopList objectAtIndex:indexPath.row-1];
            cell.leftImageUrl = [NSString stringWithFormat:@"%@",campData.pic_serv_name];
            [cell.leftImageView yy_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,campData.pic_serv_thumbname] stringByReplacingOccurrencesOfString:@"~" withString:@""]] placeholder:[UIImage imageNamed:@"defaultadidas.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
            
            cell.detailLabel.text = [NSString stringWithFormat:@"物料名称：%@",campData.pop_name];
            cell.codeLabel.text = [NSString stringWithFormat:@"物料编号：%@",campData.pop_code];
            NSString *comment = [NSString stringWithFormat:@"%@",campData.PHOTO_COMMENT];
            if([comment isEqualToString:@""]||[[comment lowercaseString] containsString:@"null"]) comment = @"(未添加)" ;
            cell.commentLabel.text = [NSString stringWithFormat:@"拍照要求：%@",comment];
            cell.commentLabel.textColor = [UIColor redColor];
            cell.statusImageView.hidden = YES ;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } @catch (NSException *exception) {
        }
        
        return cell ;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.campaignPopList count]+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.height;
    }
    else
    {
        CampaignPopData *campData = [self.self.campaignPopList objectAtIndex:indexPath.row-1];
        NSString *comment = [NSString stringWithFormat:@"%@",campData.PHOTO_COMMENT];
        if([comment isEqualToString:@""]||[[comment lowercaseString] containsString:@"null"]) comment = @"(未添加)" ;
        NSString *commentstr = [NSString stringWithFormat:@"拍照要求：%@",comment];
        float height = [self getLabelHeightWithText:commentstr width:DEVICE_WID-97-32 font:14];
        if (height > 21) {
            return 80 + height - 21  ;
        }
        return 80 ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CampaignPopData *campData = [self.self.campaignPopList objectAtIndex:indexPath.row-1];
        InstallCampaignPhotoViewController *controller = [[InstallCampaignPhotoViewController alloc] initWithNibName:@"InstallCampaignPhotoViewController" bundle:nil];
        controller.campData = campData ;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)openDetailImage:(NSString *)type {
    
    if (type&&![type isEqualToString:@""]) {
        
        ReviewDetailImageViewController *rdivc = [[ReviewDetailImageViewController alloc] initWithNibName:@"ReviewDetailImageViewController" bundle:nil];
        rdivc.imageUrl = type ;
        rdivc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:rdivc animated:NO completion:nil];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    self.view.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
    self.view.tag = 0;
    [self readResult];
    self.height = 120;
    self.uploadmanagement = [[UploadManagement alloc]init];
    self.uploadmanagement.delegate = self;
    [Utilities createRightBarButton:self clichEvent:@selector(uploadInstallXml) btnSize:CGSizeMake(50, 30)
                           btnTitle:SYSLanguage?@"Submit":@"上传"];
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44) ];
    label.text =self.title;
    label.backgroundColor = [UIColor clearColor];
    //    [Utilities createLeftBarButton:self.tabBarController  clichEvent:@selector(back)];
    label.textColor = SYS_YELLOW;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
//    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.largepicButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.largepicButton.frame = [UIScreen mainScreen].applicationFrame;
//    [self.view addSubview:self.largepicButton];
//    [self.largepicButton setHidden:YES];
//    [self.largepicButton addTarget:self action:@selector(hidLargePic) forControlEvents:UIControlEventTouchUpInside];
    self.largepicView = [[[NSBundle mainBundle]loadNibNamed:@"LargeImageView" owner:self options:nil]objectAtIndex:0];
    [self.view addSubview:self.largepicView];
   
    self.largepicView.frame = CGRectMake(0, 64, DEVICE_WID, DEVICE_HEIGHT-64);
    
    self.largepicView.hidden = YES;
    self.largepicView.delegate = self;
    
    self.campaignPopList = [[NSMutableArray alloc]init];
    self.picResultArr = [[NSMutableArray alloc]init];
    //启用等待提示框
    [HUD showUIBlockingIndicator];
    //获取服务器StoreList
    _management = [[StoreManagement alloc] init];
    _management.delegate = self;
    [_management getPopList:self.campaignID];
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    locationview.image = [UIImage imageNamed:@"locationBarbg.png"];
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEWIDTH-30, 40)];
    locationlabel.tag = 111;
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor = [UIColor clearColor];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.text = [CacheManagement instance].currentStore.StoreName;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];
    
    self.campaignPopTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEVICE_WID, DEVICE_HEIGHT-40 - 64) style:UITableViewStylePlain];
    self.campaignPopTable.showsVerticalScrollIndicator = NO;
    campaignPopTable.delegate = self;
    campaignPopTable.dataSource = self;
    campaignPopTable.tableFooterView = [[UIView alloc] init];
    self.campaignPopTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:campaignPopTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)completeGetStoreInfoServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    if (error) {
        
        [HUD hideUIBlockingIndicator];
        [Utilities showAlertMessageView:@"请求活动物料列表失败"];
        return;
    }
    NSArray* array = [responseString JSONValue];
    for (id obj in array) {
        
        CampaignPopData* data  = [[CampaignPopData alloc]init];
        data.campaign_id = [obj valueForKey:@"CAMPAIGN_ID"];
        data.pop_name = [obj valueForKey:@"POP_NAME"];
        data.pop_code = [obj valueForKey:@"POP_CODE"];
        data.pop_id = [obj valueForKey:@"CAMPAIGN_POP_ID"];
        [[obj valueForKey:@"PICTURE_SERVER_NAME"] deleteCharactersInRange:NSMakeRange(0, 1)];
        [[obj valueForKey:@"PICTURE_SERVER_NAME_THUMB"] deleteCharactersInRange:NSMakeRange(0, 1)];
        data.pic_serv_name = [obj valueForKey:@"PICTURE_SERVER_NAME"];
        data.pic_serv_thumbname = [obj valueForKey:@"PICTURE_SERVER_NAME_THUMB"];
        data.picpath = [NSString stringWithFormat:kVM_Score_PicturePathString,[Utilities SysDocumentPath],self.campaignID,[CacheManagement instance].currentStore.StoreCode,@"INSTALL",data.pop_id];
        
        data.MAX_PHOTO_COUNT = [obj valueForKey:@"MAX_PHOTO_COUNT"];
        data.MIN_PHOTO_COUNT = [obj valueForKey:@"MIN_PHOTO_COUNT"];
        data.PHOTO_COMMENT = [obj valueForKey:@"PHOTO_COMMENT"];
        
        [self.campaignPopList addObject:data];
    }
    
    [self.campaignPopTable reloadData];
    [HUD hideUIBlockingIndicator];
}

-(void)readResult
{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:[NSString stringWithFormat:@"%@,%@",self.campaignID,[CacheManagement instance].currentStore.StoreCode]];
    [CacheManagement instance].campComment = [dic valueForKey:@"comment"];
    [CacheManagement instance].campReason = [dic valueForKey:@"reason"];
    [CacheManagement instance].campReasonNote = [dic valueForKey:@"reasonnote"];
    if ([[dic valueForKey:@"upload"] isEqualToString:@"Y"])
    {
        self.view.tag = 34;
    }
    else
    {
        self.view.tag = 0;
    }
}

-(void)saveResult
{
//    NSArray* arr = [NSArray arrayWithObjects:[CacheManagement instance].campReason,[CacheManagement instance].campComment,nil];
//    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:self.campaignID];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (self.view.tag == 34 )
    {
        [dic setValue:@"Y" forKey:@"upload"];
    }
    else
    {
        [dic setValue:@"N" forKey:@"upload"];
    }
    [dic setValue:[CacheManagement instance].campComment forKey:@"comment"];
    [dic setValue:[CacheManagement instance].campReason forKey:@"reason"];
    [dic setValue:[CacheManagement instance].campReasonNote forKey:@"reasonnote"];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:[NSString stringWithFormat:@"%@,%@",self.campaignID,[CacheManagement instance].currentStore.StoreCode]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveResult];
}

-(void)uploadInstallXml
{
    
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    
//    NSString* aPicpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],self.campaignID,[CacheManagement instance].currentStore.StoreCode,@"INSTALL"] ;
//    NSFileManager* fileManager = [NSFileManager defaultManager];
//    NSMutableArray* installArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:aPicpath error:nil];
//
//    NSMutableArray *newListArray = [NSMutableArray array];
//    for (NSString *aPath in installArrTemp) {
//
//        for (CampaignPopData* popdata in self.campaignPopList)
//        {
//            if ([[[popdata.picpath componentsSeparatedByString:@"/"] lastObject] isEqualToString:aPath])
//            {
//                [newListArray addObject:popdata] ;
//                break ;
//            }
//        }
//    }
//    self.campaignPopList = [NSMutableArray arrayWithArray:newListArray];
//
//    // 获得图片数组
//    [self.picResultArr removeAllObjects];
//    for (CampaignPopData* popdata in self.campaignPopList)
//    {
//        if ([[NSFileManager defaultManager]fileExistsAtPath:popdata.picpath])
//        {
//            [self.picResultArr addObject:popdata.picpath];
//        }
//    }

    NSMutableArray *picarray = [NSMutableArray array];
    BOOL isCanDo = YES ;
    for (CampaignPopData *data in self.campaignPopList) {
        
        NSString *savedStr = [NSString stringWithFormat:@"%@_%@_%@",[CacheManagement instance].currentUser.UserId,[CacheManagement instance].currentStore.StoreCode,data.campaign_id] ;
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:savedStr];
        NSArray *sourceArray ;
        if (dic&&[[dic allKeys] containsObject:data.pop_id]) {
            sourceArray = [dic objectForKey:data.pop_id];
        }
        if (!sourceArray) {
            isCanDo = NO ;
            break ;
        }
        for (NSDictionary *dic in sourceArray) {
            if ((![dic valueForKey:@"comment"]||[[dic valueForKey:@"comment"] isEqualToString:@""])&&
                (![dic valueForKey:@"path"]||[[dic valueForKey:@"path"] isEqualToString:@""])) {
                isCanDo = NO ;
                break ;
            }
            [picarray addObject:[dic valueForKey:@"path"]];
        }
        if (!isCanDo) break ;
    }
    
    if (!isCanDo) {
        [Utilities alertMessage:@"请完成所有物料照片或者填写备注!"];
        return ;
    }
    
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* XmlString = [xmlcon CreateInstallCheckString:self.campaignPopList
                                             WorkStartTime:[Utilities DateTimeNow]
                                               WorkEndTime:[Utilities DateTimeNow]
                                                CampaignID:[CacheManagement instance].currentCAMPID
                                                 StoreCode:[CacheManagement instance].currentStore.StoreCode
                                                submittime:[Utilities DateTimeNow]
                                                  WorkDate:[Utilities DateNow]
                                                    reason:[CacheManagement instance].campReason
                                                   comment:[CacheManagement instance].campComment];
    
    if ([CacheManagement instance].uploaddata == YES)
    {
        [HUD showUIBlockingIndicator];
        
        [self.uploadmanagement uploadInstallFileToServer:XmlString
                                                fileType:kXmlFrCampInstall
                                          andfilePathArr:picarray
         andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],self.campaignID,[CacheManagement instance].currentStore.StoreCode]];
    }
    else
    {
        // 更新本地事项状态
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET INSTALL = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql_];
        
        NSString *CurrentDate = [Utilities DateNow] ;
        NSString* DateSql  = [NSString stringWithFormat:@"select CHECK_IN_TIME from IST_WORK_MAIN where WORK_MAIN_ID = '%@'",[CacheManagement instance].currentWorkMainID];
        FMResultSet* DateResult = [[SqliteHelper shareCommonSqliteHelper] selectResult:DateSql];
        if ([DateResult next]) {
            
            CurrentDate = [[DateResult stringForColumn:@"CHECK_IN_TIME"] substringToIndex:10];
        }
        
        // 非几时上传 保存文件到本地
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        if ([rs next] == YES)
        {
            NSString* cachePath = [rs stringForColumn:@"INSTALL"];
            if ([cachePath length] < 10) {
                cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],self.campaignID,[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
                NSFileManager* fileMannager = [NSFileManager defaultManager];
                if(![fileMannager fileExistsAtPath:cachePath])
                {
                    [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
            }
            else {
                
                NSString *newfi = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[cachePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
                cachePath = newfi ;
            }
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [XmlString dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 数据库存在记录 update
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[Utilities SysDocumentPath],self.campaignID,[CacheManagement instance].currentStore.StoreCode,@"INSTALL",[CacheManagement instance].currentUser.UserId];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET INSTALL_PIC_PATH = '%@',INSTALL_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            [db executeUpdate:update_sql];
            
        }
        else
        {
            // 写xml到本地
            NSString* cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],self.campaignID,[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath])
            {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [XmlString dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 不存在记录 insert
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[Utilities SysDocumentPath],self.campaignID,[CacheManagement instance].currentStore.StoreCode,@"INSTALL",[CacheManagement instance].currentUser.UserId];

            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,INSTALL_PIC_PATH,STORE_NAME,USER_ID,INSTALL_XML_PATH) values (?,?,?,?,?,?)"];
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,picpath,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)completeUploadServer:(NSString *)error
{

//    sleep(1);
    [HUD hideUIBlockingIndicator];
    if (error == nil)
    {
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET INSTALL = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql_];
        Uploadstatu = 1 ;
        
        self.view.tag = 34;
        [self saveResult];
        if (SYSLanguage == CN) {
            [HUD showUIBlockingSuccessIndicatorWithText: @"上传成功" withTimeout:2];
        }
        else if (SYSLanguage == EN)
        {
            [HUD showUIBlockingSuccessIndicatorWithText:@"Submit successfully" withTimeout:2];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [HUD showUIBlockingIndicatorWithText:error withTimeout:2];
    }
}

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}
@end
