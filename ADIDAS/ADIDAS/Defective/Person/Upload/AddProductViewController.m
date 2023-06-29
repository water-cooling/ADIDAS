//
//  AddProductViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "AddProductViewController.h"
#import "OrderDetailView.h"
#import "SeperateCustomCell.h"
#import "EditTableViewCell.h"
#import "DefectiveCustomCell.h"
#import "XMLFileManagement.h"
#import "SSZipArchive.h"
#import "PopoverMenu.h"
#import "UploadPicCustomCell.h"


@interface AddProductViewController ()<OperateDelegate,UIAlertViewDelegate>


@end

@implementation AddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTop) name:@"SCROLLTOPTABLEVIEW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disapearPull) name:@"TAPPULLBG" object:nil];
    
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
    
    if (!self.caseNumber) self.caseNumber = @"" ;
    
    if (!self.showOperate) {
        
        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 20, 8)];
        imageV1.image = [UIImage imageNamed:@"pulldownhomedot.png"];
        imageV1.backgroundColor = [UIColor clearColor];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setBackgroundColor:[UIColor clearColor]] ;
        [closeButton setFrame:CGRectMake(0, 0, 40, 44)] ;
        [closeButton addTarget:self action:@selector(OpenPull) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *viewBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        viewBtn.backgroundColor = [UIColor clearColor];
        
        [viewBtn addSubview:imageV1];
        [viewBtn addSubview:closeButton] ;

        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:viewBtn];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil action:nil];
        spacer.width = -10 ;
        
        self.navigationItem.rightBarButtonItems = @[spacer,item] ;
    }
    
    if ([self.showOperate isEqualToString:@"1"]) {
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"转发至邮箱" style:UIBarButtonItemStylePlain target:self action:@selector(complete)] ;
        self.navigationItem.rightBarButtonItem = right ;
    }
    
    self.ProductTableView.delegate = self ;
    self.ProductTableView.dataSource = self ;
    self.ProductTableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0) ;
    self.ProductTableView.tableFooterView = [[UIView alloc] init];
    
    if ([self.caseNumber isEqualToString:@""]) {
        
        if (!self.folderString) self.folderString = [NSUUID UUID].UUIDString ;
        if (!self.totalOriginAry) self.totalOriginAry = @[@{}];
        [self updateViewArray];
    }
    else {
        [self getDetailList];
    }
}


- (void)backAction {
    
    OrderDetailView *detail = [self.totalViewAry firstObject];
    
    if (!detail) {
        
        [self showAlertWithDispear:@"数据错误!"];
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    if (!detail.isEdited) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    EditTableViewCell *cell1 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];//货号
    EditTableViewCell *cell2 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];//尺码
    EditTableViewCell *cell3 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];//数量
    EditTableViewCell *cell4 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];//购买日期
    EditTableViewCell *cell5 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];//工单号
    EditTableViewCell *cell6 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];//门店电话
    EditTableViewCell *cell7 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];//门店人负责人手机号
    EditTableViewCell *cell8 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];//门店邮箱
    EditTableViewCell *cell14 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];//寄件地址
    EditTableViewCell *cell12 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];//申请人
    EditTableViewCell *cell13 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];//mi订单编号
    UITableViewCell *cell9 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];//残次类型
    DefectiveCustomCell *cell10 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];//残次描述
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],detail.folderName] error:nil];
    
    NSMutableArray *imageAry = [NSMutableArray array];
    
    
    UploadPicCustomCell *cell11 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if ([cell11.imageArray count]) {
        
        for (int i = 0; i < [cell11.imageArray count]; i++) {
            
            id oj = [cell11.imageArray objectAtIndex:i];
            
            if ([oj isKindOfClass:[NSDictionary class]]) {
                
                [imageAry addObject:oj] ;
            }
        }
    }
    
    
    for (NSString *file in fileList) {
        
        if ([[file componentsSeparatedByString:@"_"] count] != 2 &&
            [[[file componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"]) {
            
            [imageAry addObject:file] ;
        }
    }
    
    if ([cell1.rightTextField.text isEqualToString:@""]&&[cell2.rightTextField.text isEqualToString:@""]&&
        [cell3.rightTextField.text isEqualToString:@""]&&[cell4.rightTextField.text isEqualToString:@""]&&
        [cell6.regionTextField.text isEqualToString:@""]&&[cell7.rightTextField.text isEqualToString:@""]&&
        [cell8.rightTextField.text isEqualToString:@""]&&[cell10.defectiveTextView.text isEqualToString:@""]&&
        [cell6.phoneTextField.text isEqualToString:@""]&&[cell12.rightTextField.text isEqualToString:@""]&&
        [cell13.rightLabel.text isEqualToString:@""]&&[cell14.rightTextField.text isEqualToString:@""]&&
        ([cell9.detailTextLabel.text isEqualToString:@""] || [cell9.detailTextLabel.text isEqualToString:@"请选择残次类型"])&&
        [imageAry count] == 0&&[cell5.rightTextField.text isEqualToString:@""]) {
        
        self.tabBarController.selectedIndex = 0 ;
        
        return ;
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否保留当前的编辑内容?" message:@"" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"保存内容",@"不保存", nil];
    alert.tag = 888 ;
    [alert show];
}

- (void)viewWillDisappear:(BOOL)animated {

    [self disapearPull];
}

- (void)getDetailList {

    [self ShowSVProgressHUD];
    
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token,@"CaseNumber":self.caseNumber};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetNewCaseDetail",kWebDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        
        [self DismissSVProgressHUD];
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            if (!self.showOperate||[self.totalOriginAry count]) {
                
                if (!self.folderString) self.folderString = [NSUUID UUID].UUIDString ; //如果是待补充材料，这个需要赋值，只有待补充材料下才能拍照 或者历史记录下进来而且有casenumber
            }
            
            NSMutableArray *ary = [NSMutableArray array];
            
            NSDictionary *dic = [self.totalOriginAry firstObject];
            
            for (int i = 0 ; i < [[[[responseObject valueForKey:@"Msg"] JSONValue] allKeys] count]; i++) {
                
                [ary addObject:[[[responseObject valueForKey:@"Msg"] JSONValue] valueForKey:[NSString stringWithFormat:@"%d",i]]];
            }
            
            if ([self.totalOriginAry count]) {
                
                [ary replaceObjectAtIndex:0 withObject:dic] ;
            }
            
            self.totalOriginAry = [NSArray arrayWithArray:ary];
            
            [self updateViewArray];
        }
        else {
            
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
            
            if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                [ud synchronize];
                
                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
    }];
}

- (void)disapearPull {

    [PopoverMenu dismissMenu];
}

- (void)OpenPull {
    
    OrderDetailView *detail = [self.totalViewAry firstObject];
    
    if (detail) [detail clearKeyBoard];
    
    
    NSMutableArray *menuItems = [NSMutableArray array];
    
    PopoverMenuItem *item1 = [[PopoverMenuItem alloc] init:@" 即时上传    " image:nil target:self action:@selector(SelectType:)];
    [menuItems addObject:item1];
    
    PopoverMenuItem *item2 = [[PopoverMenuItem alloc] init:@" 保存草稿    " image:nil target:self action:@selector(SelectType:)];
    [menuItems addObject:item2];
    
    [PopoverMenu setTintColor:[UIColor darkGrayColor]];
    [PopoverMenu setTitleFont:[UIFont systemFontOfSize:17]];
    
    [PopoverMenu showMenuInView:self.view
                       fromRect:CGRectMake(PHONE_WIDTH-33, 17, 16, 54)
                      menuItems:menuItems
                   isAddGesture:YES];
}

- (void)SelectType:(PopoverMenuItem *)item {

    if ([[item.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"即时上传"]) {
        
        [self uploadFile];
    }
    
    if ([[item.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"保存草稿"]) {
        
        [self saveFile:NO];
    }
}

- (void)saveFile:(BOOL)isExist {

    OrderDetailView *detail = [self.totalViewAry firstObject];
    
    if (!detail) {
        
        [self showAlertWithDispear:@"数据错误!"];
        [self.navigationController popViewControllerAnimated:isExist];
        return ;
    }
    
    
    EditTableViewCell *cell1 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];//货号
    EditTableViewCell *cell2 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];//尺码
    EditTableViewCell *cell3 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];//数量
    EditTableViewCell *cell4 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];//购买日期
    EditTableViewCell *cell5 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];//工单号
    EditTableViewCell *cell6 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];//门店电话
    EditTableViewCell *cell7 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];//门店人负责人手机号
    EditTableViewCell *cell8 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];//门店邮箱
    EditTableViewCell *cell16 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];//寄件地址
    EditTableViewCell *cell12 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];//申请人
    EditTableViewCell *cell15 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];//mi订单编号
    
    EditTableViewCell *cell13 = nil ;
    EditTableViewCell *cell14 = nil ;
    @try {
        cell13 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];//是否定制鞋
        cell14 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];//是否RBK
    } @catch (NSException *exception) {
    }
    
    UITableViewCell *cell9 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];//残次类型
    DefectiveCustomCell *cell10 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];//残次描述
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],detail.folderName] error:nil];
    
    NSMutableArray *imageAry = [NSMutableArray array];
    
    
    UploadPicCustomCell *cell11 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if ([cell11.imageArray count]) {
        
        for (int i = 0; i < [cell11.imageArray count]; i++) {
            
            id oj = [cell11.imageArray objectAtIndex:i];
            
            if ([oj isKindOfClass:[NSDictionary class]]) {
                
                [imageAry addObject:oj] ;
            }
        }
    }
    
    
    for (NSString *file in fileList) {
        
        if ([[file componentsSeparatedByString:@"_"] count] != 2 &&
            [[[file componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"]) {
            
            [imageAry addObject:file] ;
        }
    }
    
    if ([cell1.rightTextField.text isEqualToString:@""]&&[cell2.rightTextField.text isEqualToString:@""]&&
        [cell3.rightTextField.text isEqualToString:@""]&&[cell4.rightTextField.text isEqualToString:@""]&&
        [cell6.regionTextField.text isEqualToString:@""]&&[cell7.rightTextField.text isEqualToString:@""]&&
        [cell8.rightTextField.text isEqualToString:@""]&&[cell10.defectiveTextView.text isEqualToString:@""]&&
        [cell6.phoneTextField.text isEqualToString:@""]&&[cell12.rightTextField.text isEqualToString:@""]&&
        [cell15.rightLabel.text isEqualToString:@""]&&[cell16.rightTextField.text isEqualToString:@""]&&
        ([cell9.detailTextLabel.text isEqualToString:@""] || [cell9.detailTextLabel.text isEqualToString:@"请选择残次类型"])&&
        [imageAry count] == 0) {
        
        [self showAlertWithLongDispear:@"请输入必填信息或拍摄照片后才能保存!"];
        
        return ;
    }
    
    if (cell1.rightTextField.text.length != 6 && cell1.rightTextField.text.length > 0) {
        
        [self showAlertWithDispear:@"请输入6位长度的货号!"];
        return ;
    }
    
    if ([cell16.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入寄件地址!"];
        return ;
    }
    
    
    NSMutableArray *newAry = [NSMutableArray array];
    
    for (id oj in imageAry) {
        
        if ([oj isKindOfClass:[NSDictionary class]]) {
            
            [newAry addObject:oj] ;
        }
    }
    
    NSString *lastring = @"" ;
    NSString *firstring = @"" ;
    
    if (![cell9.detailTextLabel.text isEqualToString:@"请选择残次类型"]) {
        
        lastring = [[cell9.detailTextLabel.text componentsSeparatedByString:@" - "] lastObject] ;
        firstring = [[cell9.detailTextLabel.text componentsSeparatedByString:@" - "] firstObject] ;
    }
    
    
    NSDictionary *dic = @{@"ArtilceNo":cell1.rightTextField.text,
                          @"ArtilceSize":cell2.rightTextField.text,
                          @"ArtilceQuantity":cell3.rightTextField.text,
                          @"SalesDate":cell4.rightTextField.text,
                          @"WorkerNumber":cell5.rightTextField.text,
                          @"StorePhone":[NSString stringWithFormat:@"%@-%@",cell6.regionTextField.text,cell6.phoneTextField.text],
                          @"StoreManagePhone":cell7.rightTextField.text,
                          @"StoreMail":cell8.rightTextField.text,
                          @"CaseTitle":lastring,
                          @"CaseTitleType":firstring,
                          @"CaseComment":cell10.defectiveTextView.text,
                          @"Requestor":cell12.rightTextField.text,
                          @"PostAddress":cell16.rightTextField.text,
                          @"CaseNumber":self.caseNumber,
                          @"MiOrderNumber":cell15?cell15.rightTextField.text:@"",
                          @"CreateDate":[CommonUtil NSDateToNSString:[NSDate date]],
                          @"IsSpecial":(cell13&&cell13.selectWitch.isOn)?@"1":@"0",
                          @"IsRBK":(cell14&&cell14.selectWitch.isOn)?@"1":@"0",
                          @"CasePicture":newAry} ;
    
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],HISTORYDATA]]];
        
        if (!historyArray) historyArray = [NSMutableArray array];
        
        BOOL isexist = NO ;
        
        for (NSDictionary *goodDic in historyArray) {
            
            if ([[[goodDic allKeys] firstObject] isEqualToString:detail.folderName]) {
                
                [goodDic setValue:dic forKey:detail.folderName] ;
                isexist = YES ;
            }
        }
        
        if (!isexist) {
            
            BOOL isexistCaseNumber = NO ;
            
            for (NSDictionary *goodDic in historyArray) {
                
                if (![[[[goodDic allValues] firstObject] valueForKey:@"CaseNumber"] isEqualToString:@""]&&[[[[goodDic allValues] firstObject] valueForKey:@"CaseNumber"] isEqualToString:self.caseNumber]) {
                    
                    [goodDic setValue:dic forKey:[[goodDic allKeys] firstObject]] ;
                    isexistCaseNumber = YES ;
                }
            }
            
            if (!isexistCaseNumber) [historyArray addObject:[NSDictionary dictionaryWithObject:dic forKey:detail.folderName]] ;
        }
        
        BOOL res = [historyArray writeToFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],HISTORYDATA]] atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (res) {
                
                [self showAlertWithDispear:@"保存成功!"] ;
                [self.navigationController popViewControllerAnimated:isExist];
            }
            else [self showAlertWithDispear:@"保存失败,请重试!"] ;
        });
    });
   
}


- (void)uploadFile {
    
    OrderDetailView *detail = [self.totalViewAry firstObject];
    
    if (!detail) {
    
        [self showAlertWithDispear:@"数据错误!"];
        [self.navigationController popViewControllerAnimated:NO];
        return ;
    }
    
    EditTableViewCell *cell1 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];//货号
    EditTableViewCell *cell2 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];//尺码
    EditTableViewCell *cell3 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];//数量
    EditTableViewCell *cell4 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];//购买日期
    EditTableViewCell *cell5 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];//工单号
    EditTableViewCell *cell6 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];//门店电话
    EditTableViewCell *cell7 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];//门店人负责人手机号
    EditTableViewCell *cell8 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];//门店邮箱
    UITableViewCell *cell9 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];//残次类型
    DefectiveCustomCell *cell10 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];//残次描述
    EditTableViewCell *cell16 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];//寄件地址
    EditTableViewCell *cell12 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];//申请人
    EditTableViewCell *cell15 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];//mi订单编号
    
    EditTableViewCell *cell13 = nil ;
    EditTableViewCell *cell14 = nil ;
    @try {
        cell13 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];//是否定制鞋
        cell14 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];//是否RBK
    } @catch (NSException *exception) {
    }
    
    if ([cell1.rightTextField.text isEqualToString:@""] ||
        cell1.rightTextField.text.length != 6) {
        
        [self showAlertWithDispear:@"请输入6位长度的货号!"];
        return ;
    }
    
    if ([cell2.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入尺码!"];
        return ;
    }
    
    if ([cell3.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入数量!"];
        return ;
    }
    
    if ([cell4.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请选择购买日期!"];
        return ;
    }
    
    if ([cell6.regionTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入电话区号!"];
        return ;
    }
    
    if ([cell6.phoneTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入门店电话!"];
        return ;
    }
    
    if ([cell7.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入门店负责人手机号!"];
        return ;
    }
    
    if ([cell8.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入门店邮箱!"];
        return ;
    }
    
    if ([cell12.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入申请人!"];
        return ;
    }
    
    if ([cell16.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入寄件地址!"];
        return ;
    }
    
    if ([cell9.detailTextLabel.text isEqualToString:@""] || [cell9.detailTextLabel.text isEqualToString:@"请选择残次类型"]) {
        
        [self showAlertWithDispear:@"请选择残次类型!"];
        return ;
    }
    
    if ([cell10.defectiveTextView.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入残次描述!"];
        return ;
    }
    
    if (cell13.selectWitch.isOn&&[cell15.rightTextField.text isEqualToString:@""]) {
        
        [self showAlertWithDispear:@"请输入mi订单编号!"];
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *imageAry = [NSMutableArray array];
    NSMutableArray *zipFileAry = [NSMutableArray array];
    
    UploadPicCustomCell *cell11 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if ([cell11.imageArray count] == 0&&(!self.caseStatus||![self.caseStatus isEqualToString:@"4"])) {
        
        [self showAlertWithDispear:@"请至少拍摄一张图片!"];
        
        return ;
    }
    

        
    for (int i = 0; i < [cell11.imageArray count]; i++) {
            
        [imageAry addObject:[cell11.imageArray objectAtIndex:i]] ;
        
        if ([[cell11.imageArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
            
            [zipFileAry addObject:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[cell11.imageArray objectAtIndex:i]]];
            [zipFileAry addObject:[NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil SysDocumentPath],[[[cell11.imageArray objectAtIndex:i] componentsSeparatedByString:@"_s"] firstObject]]];
        }
    }

    
    [self ShowSVProgressHUD];
    
    if(![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],detail.folderName]])
    {
        [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],detail.folderName] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString = [xmlcon CreateDefectiveXmlStringWith:[cell1.rightTextField.text uppercaseString]
                                                   andGoodSize:cell2.rightTextField.text
                                                  andGoodCount:cell3.rightTextField.text
                                                andGoodBuyDate:cell4.rightTextField.text
                                                      andJobNo:cell5.rightTextField.text
                                                 andStorePhone:[NSString stringWithFormat:@"%@-%@",cell6.regionTextField.text,cell6.phoneTextField.text]
                                                  andRequestor:cell12.rightTextField.text
                                                andPostAddress:cell16.rightTextField.text
                                                andStoreLeader:cell7.rightTextField.text
                                                  andStoreMail:cell8.rightTextField.text
                                                   andGoodType:cell9.detailTextLabel.text
                                               andGoodDescribe:cell10.defectiveTextView.text
                                              andMiOrderNumber:cell15.rightTextField.text
                                                   andAllPic:imageAry
                                                       andUser:[self GetLoginUser].UserAccount
                                                    andOrderNo:self.caseNumber
                                                   andCaseDate:[CommonUtil NSDateToNSString:[NSDate date]]
                                                  andIsSpecial:(cell13&&cell13.selectWitch.isOn)?@"1":@"0"
                                                      andIsRBK:(cell14&&cell14.selectWitch.isOn)?@"1":@"0"] ;
    
    NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *xmlPath = [NSString stringWithFormat:@"%@/%@/iosupload.xml",[CommonUtil SysDocumentPath],detail.folderName] ;
    [xmlData writeToFile:xmlPath atomically:YES];
    [zipFileAry addObject:xmlPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result =
        [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/%@/iospacket.zip",[CommonUtil SysDocumentPath],detail.folderName]
                         withFilesAtPaths:zipFileAry];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result) {
                
                [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 500;
                
                [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@UploadCase&CaseNumber=%@&Token=%@&CaseDate=%@",kWebDefectiveString,self.caseNumber,[self GetLoginUser].Token,[[[CommonUtil NSDateToNSString:[NSDate date]] componentsSeparatedByString:@" "] firstObject]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    [formData appendPartWithFileData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/iospacket.zip",[CommonUtil SysDocumentPath],detail.folderName]] name:@"zip" fileName:@"iospacket.zip" mimeType:@"application/zip"];
                    
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
                            
                            NSMutableDictionary *userSaveData = [NSMutableDictionary dictionaryWithContentsOfFile:[CommonUtil getPlistPath:LOGINDATA]];
                            
                            [userSaveData setValue:cell8.rightTextField.text forKey:@"StoreEmail"] ;
                            [userSaveData setValue:cell7.rightTextField.text forKey:@"StoreManagePhone"] ;
                            [userSaveData setValue:[NSString stringWithFormat:@"%@-%@",cell6.regionTextField.text,cell6.phoneTextField.text] forKey:@"StorePhone"] ;
                            
                            [userSaveData writeToFile:[CommonUtil getPlistPath:LOGINDATA] atomically:YES] ;
                            
                            NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                            [df setObject:cell8.rightTextField.text forKey:[NSString stringWithFormat:@"StoreEmail_%@",[[self GetLoginUser].UserAccount uppercaseString]]] ;
                            [df setObject:cell7.rightTextField.text forKey:[NSString stringWithFormat:@"StoreManagePhone_%@",[[self GetLoginUser].UserAccount uppercaseString]]] ;
                            [df setObject:[NSString stringWithFormat:@"%@-%@",cell6.regionTextField.text,cell6.phoneTextField.text] forKey:[NSString stringWithFormat:@"StorePhone_%@",[[self GetLoginUser].UserAccount uppercaseString]]] ;
                            [df synchronize] ;
                            
                        } @catch (NSException *exception) {
                            
                            NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};
                            
                            [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@UserLoinOut",kWebDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                                [ud synchronize];
                                
                                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
                            
                        } @finally {}
                        
                        [self ShowSuccessSVProgressHUDForTen:@"上传成功！我们会在3个工作日内回复。"];
                        
                        if (self.delegate&&[self.delegate respondsToSelector:@selector(refreshList)]) [self performSelector:@selector(refreshLastPage) withObject:nil afterDelay:8] ;
                        
                        else [self.navigationController popViewControllerAnimated:NO] ;
                        
                        NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],HISTORYDATA]]];
                        
                        if (historyArray) {
                            
                            
                            NSMutableArray *lastAry = [NSMutableArray array];
                            
                            for (NSDictionary *goodDic in historyArray) {
                                
                                if (![[[goodDic allKeys] firstObject] isEqualToString:detail.folderName]) {
                                    
                                    [lastAry addObject:goodDic] ;
                                }
                            }
                            
                            historyArray = [NSMutableArray arrayWithArray:lastAry];
                            lastAry = nil ;
                        }
                        else historyArray = [NSMutableArray array];
                        
                        NSFileManager* fileMannager = [NSFileManager defaultManager];
                        
                        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],detail.folderName]]) {
                            
                            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],detail.folderName] error:nil];
                        }
                        
                        [historyArray writeToFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],HISTORYDATA]] atomically:YES] ;
                        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 888) {
        
        OrderDetailView *detail = [self.totalViewAry firstObject];
        
        if (detail) [detail clearKeyBoard];
        
        if (buttonIndex == 1) { //保存内容
            
            [self saveFile:YES];
           
        }
        
        if (buttonIndex == 2) { //不保存
            
            NSMutableArray *foldName = [NSMutableArray array];
            
            NSArray *noupload = [NSArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],NOUPLOADDATA]]];
            NSArray *history = [NSArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],HISTORYDATA]]];
            
            for (NSDictionary *dic in noupload) {
                
                [foldName addObject:[[dic allKeys] firstObject]] ;
            }
            
            for (NSDictionary *dic in history) {
                
                [foldName addObject:[[dic allKeys] firstObject]] ;
            }
            
            if (![foldName containsObject:self.folderString]) {
                
                NSFileManager *fileManager = [NSFileManager defaultManager] ;
                
                if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderString]]) {
                    
                    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.folderString] error:nil];
                }
            }
            
            if (self.isShowBack) {
                
                self.tabBarController.selectedIndex = 0 ;
            }
            else [self.navigationController popViewControllerAnimated:YES] ;
        }
    }

    if (alertView.tag == 999 && buttonIndex == 1) {
        
        [self ShowSVProgressHUD];
        
        UITextField *nameField = [alertView textFieldAtIndex:0];
     
        NSDictionary *dic = @{@"Token":[self GetLoginUser].Token,@"CaseNumber":self.caseNumber,@"Email":nameField.text};
        
        [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 500;
        
        [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@FinishCase",kWebDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (![responseStr JSONValue]) {
                NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
                responseObject = [aesString JSONValue] ;
            }else {
                responseObject = [responseStr JSONValue] ;
            }
            
            [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 20;
            
            [self DismissSVProgressHUD];
            
            if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
                
                [self showAlertWithDispear:@"操作成功!"];
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate refreshList];
            }
            else {
                
                if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                    [ud synchronize];
                    [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
                }
                
                [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [HttpAPIClient sharedClient].requestSerializer.timeoutInterval = 20;
            
            [self DismissSVProgressHUD];
            
            [self showAlertWithDispear:error.localizedDescription];
        }];
    }
}

- (void)complete {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否将此结果转发至邮箱?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput ;
    
    UITextField *nameField = [alert textFieldAtIndex:0];
    nameField.placeholder = @"请输入邮箱地址";
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing ;
    
    OrderDetailView *detail = [self.totalViewAry firstObject];
    
    if (detail) {
        
        EditTableViewCell *cell8 = [detail.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
        nameField.text = cell8.rightTextField.text ;
    }
    
    UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    paddingView.text = @"邮箱:" ;
    paddingView.textAlignment = NSTextAlignmentCenter ;
    paddingView.font = [UIFont systemFontOfSize:13];
    paddingView.backgroundColor = [UIColor clearColor];
    nameField.leftView = paddingView;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    
    alert.tag = 999 ;
    [alert show];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataAry count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    id oj = [self.viewAry objectAtIndex:indexPath.row];
    
    if ([oj isKindOfClass:[OrderDetailView class]]) {
    
        OrderDetailView *od = (OrderDetailView *)oj ;
        
        BOOL isShowMi = NO ;
        @try {
            EditTableViewCell *cell13 = [od.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];//是否定制鞋
            if (cell13) isShowMi = cell13.selectWitch.on ;
            else if(od.dataDic) isShowMi = [@"1" isEqualToString:[NSString stringWithFormat:@"%@",[od.dataDic valueForKey:@"IsSpecial"]]] ;
        } @catch (NSException *exception) {
        }
        
        if (!od.isEdited) {
            
            int expressCount = 0 ;
            
            @try {
                BOOL isShow = [[NSString stringWithFormat:@"%@",[od.dataDic valueForKey:@"ShowStoreTrackingNo"]] isEqualToString:@"Y"] ;
                if (isShow) {
                    expressCount = 1 ;
                    NSString *MatterStoreTrackingNo = [od.dataDic valueForKey:@"MatterStoreTrackingNo"];
                    if (MatterStoreTrackingNo&&![MatterStoreTrackingNo isEqual:[NSNull null]]&&![MatterStoreTrackingNo isEqualToString:@""]&&![MatterStoreTrackingNo containsString:@"null"]) {
                        expressCount += 1;
                    }
                    NSString *ReturnType = [od.dataDic valueForKey:@"ReturnType"];
                    if (ReturnType&&![ReturnType isEqual:[NSNull null]]&&![ReturnType isEqualToString:@""]&&![ReturnType containsString:@"null"]) {
                        expressCount += 1;
                    }
                    NSString *DefectiveCode = [od.dataDic valueForKey:@"DefectiveCode"];
                    if (DefectiveCode&&![DefectiveCode isEqual:[NSNull null]]&&![DefectiveCode isEqualToString:@""]&&![DefectiveCode containsString:@"null"]) {
                        expressCount += 1;
                    }
                }
            } @catch (NSException *exception) {}
            
            return 117*2 + 20 + 687 + 44 + 44 + (44*([[CacheManagement instance].showSpecial isEqualToString:@"1"]?(isShowMi?3:2):0) + 44*expressCount + 5) ;
        }
        else return 687 + 44 + 44 + (44*([[CacheManagement instance].showSpecial isEqualToString:@"1"]?(isShowMi?3:2):0)) ;
    }
    
    if ([oj isKindOfClass:[SeperateCustomCell class]]) {
    
        if ([self.viewAry count] > indexPath.row+1) {
            
            id next = [self.viewAry objectAtIndex:indexPath.row+1];
            
            if ([next isKindOfClass:[SeperateCustomCell class]]) return 49 ;
            
            else return 35 ;
        }
        else return 49 ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *viewsArray = [NSArray array];
    if (IOSVersion < 8) {
        
        viewsArray = [[cell.subviews firstObject] subviews] ;
    }
    else {
        
        viewsArray = [cell subviews] ;
    }
    
    for (UIView *aView in viewsArray) {
        
        if ([aView isKindOfClass:[OrderDetailView class]]) {
            
            [aView removeFromSuperview] ;
        }
        
        if ([aView isKindOfClass:[SeperateCustomCell class]]) {
            
            [aView removeFromSuperview] ;
        }
    }
    
    [cell.contentView addSubview:[self.viewAry objectAtIndex:indexPath.row]] ;

    return cell ;
}


- (void)operateType:(int)type withIndex:(NSInteger)index{

    NSMutableArray *ary1 = [NSMutableArray arrayWithArray:self.dataAry];
    
    NSMutableArray *ary2 = [NSMutableArray arrayWithArray:self.viewAry];
    
    if (type == 1) {
        
        for (int i = 0 ; i < [self.totalViewAry count]; i++) {
            
            id viewcu = [self.totalViewAry objectAtIndex:i];
            
            if (viewcu == [ary2 objectAtIndex:index]) {
                
                [ary1 insertObject:[self.totalOriginAry objectAtIndex:i+1] atIndex:index+1] ;
                
                [ary2 insertObject:[self.totalViewAry objectAtIndex:i+1] atIndex:index+1];
                
                break ;
            }
        }
        
    }
    
    if (type == 0) {
        
        [ary1 removeObjectAtIndex:index+1] ;
        [ary2 removeObjectAtIndex:index+1];
    }
    
    self.dataAry = [NSArray arrayWithArray:ary1];
    self.viewAry = [NSArray arrayWithArray:ary2];
    
    [self refreshViewAry];
    
    [self.ProductTableView reloadData];
}

- (void)updateViewArray {
    
    //为传进来的dic增加string，得到完全的数据数组totalOriginAry -----dic代表detailview，string代表seperateview
    NSMutableArray *tempAry = [NSMutableArray array];
    
    for (int i = 0 ; i < [self.totalOriginAry count]; i++) {
        
        [tempAry addObject:[self.totalOriginAry objectAtIndex:i]] ;
        if ([self.totalOriginAry count] > i+1) {
            
            [tempAry addObject:[[self.totalOriginAry objectAtIndex:i+1] valueForKey:@"SubmitDate"]];
        }
        else [tempAry addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    [tempAry removeLastObject];
    
    self.totalOriginAry = [NSArray arrayWithArray:tempAry];
    
    
    //根据完全的数据数组生成完全的view数组totalViewAry（所有的打开和关闭都在view数组中取view，这样不会丢失之前view的内容）
    NSMutableArray *newAry = [NSMutableArray array];
    
    for (int i = 0 ; i < [self.totalOriginAry count] ; i++) {
        
        id oj = [self.totalOriginAry objectAtIndex:i];
        
        if ([oj isKindOfClass:[NSDictionary class]]) {
            
            NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"OrderDetailView" owner:nil options:nil];
            
            for (UIView *view in nibAry) {
                
                if ([view isKindOfClass:[OrderDetailView class]]) {
                    
                    OrderDetailView *detailView = (OrderDetailView *)view ;
                    detailView.vc = self ;
                    
                    CGRect df = detailView.frame ;
                    df.size.width = PHONE_WIDTH ;
                    detailView.frame = df ;
                    
                    [newAry addObject:detailView];
                    
                    break ;
                }
            }
        }
        
        
        if ([oj isKindOfClass:[NSString class]]) {
            
            NSArray *nibAry2 = [[NSBundle mainBundle] loadNibNamed:@"SeperateCustomCell" owner:nil options:nil];
            
            for (UIView *view in nibAry2) {
                
                if ([view isKindOfClass:[SeperateCustomCell class]]) {
                    
                    SeperateCustomCell *seperate= (SeperateCustomCell *)view ;
                    seperate.delegate = self ;
                    
                    CGRect sf = seperate.frame ;
                    sf.size.width = PHONE_WIDTH ;
                    
                    if ([self.totalOriginAry count] > i+1) {
                        
                        id next = [self.totalOriginAry objectAtIndex:i+1];
                        
                        if ([next isKindOfClass:[NSDictionary class]]) {
                            
                            sf.size.height = 35 ;
                            
                            seperate.openBGView.hidden = YES ;
                            seperate.closeBGView.hidden = NO ;
                        }
                    }
                    
                    seperate.frame = sf ;
                    [newAry addObject:seperate];
                    
                    break ;
                }
            }
        }
    }
    
    self.totalViewAry = [NSArray arrayWithArray:newAry];
    
    //获取用于显示tableview的数组，默认进来显示一条detailview，其余detailview关闭收起不显示，显示seperateview
    //dataAry对应数据数组，viewAry对应view数组
    NSMutableArray *displayDataAry = [NSMutableArray array];
    NSMutableArray *displayViewAry = [NSMutableArray array];
    
    for (int i = 0 ; i < [self.totalOriginAry count] ; i++) {
        
        id oj = [self.totalOriginAry objectAtIndex:i];

//        if ([oj isKindOfClass:[NSString class]]) {
        
            [displayDataAry addObject:oj] ;
            [displayViewAry addObject:[self.totalViewAry objectAtIndex:i]];
//        }
    }
    
//    [displayDataAry insertObject:[self.totalOriginAry firstObject] atIndex:0] ;
//    [displayViewAry insertObject:[self.totalViewAry firstObject] atIndex:0] ;
    
    self.dataAry = [NSArray arrayWithArray:displayDataAry] ;
    self.viewAry = [NSArray arrayWithArray:displayViewAry];
    
    [self refreshViewAry];
    [self.ProductTableView reloadData];
}


- (void)refreshViewAry {

    for (int i = 0 ; i < [self.viewAry count] ; i++) {
        
        id oj = [self.viewAry objectAtIndex:i];
        
        if ([oj isKindOfClass:[OrderDetailView class]]) {
            
            OrderDetailView *od = (OrderDetailView *)oj ;
            
            if (i == 0  && self.folderString) od.folderName = self.folderString ;
            if (i == 0 && !self.showOperate) od.isEdited = YES ;
            od.dataDic = [self.dataAry objectAtIndex:i];
            od.vc = self ;
            
            BOOL isShowMi = NO ;
            @try {
                EditTableViewCell *cell13 = [od.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];//是否定制鞋
                if (cell13) isShowMi = cell13.selectWitch.on ;
                else if(od.dataDic) isShowMi = [@"1" isEqualToString:[NSString stringWithFormat:@"%@",[od.dataDic valueForKey:@"IsSpecial"]]] ;
            } @catch (NSException *exception) {
            }
            
            CGRect vf = od.frame ;
            
            vf.size.height = 687 + 44 + 44 + (44*([[CacheManagement instance].showSpecial isEqualToString:@"1"]?(isShowMi?3:2):0)) ;
            
            if (!od.isEdited) {
                
                int expressCount = 0 ;
                @try {
                    BOOL isShow = [[NSString stringWithFormat:@"%@",[od.dataDic valueForKey:@"ShowStoreTrackingNo"]] isEqualToString:@"Y"] ;
                    if (isShow) {
                        expressCount = 1 ;
                        NSString *MatterStoreTrackingNo = [od.dataDic valueForKey:@"MatterStoreTrackingNo"];
                        if (MatterStoreTrackingNo&&![MatterStoreTrackingNo isEqual:[NSNull null]]&&![MatterStoreTrackingNo isEqualToString:@""]&&![MatterStoreTrackingNo containsString:@"null"]) {
                            expressCount += 1;
                        }
                        NSString *ReturnType = [od.dataDic valueForKey:@"ReturnType"];
                        if (ReturnType&&![ReturnType isEqual:[NSNull null]]&&![ReturnType isEqualToString:@""]&&![ReturnType containsString:@"null"]) {
                            expressCount += 1;
                        }
                        NSString *DefectiveCode = [od.dataDic valueForKey:@"DefectiveCode"];
                        if (DefectiveCode&&![DefectiveCode isEqual:[NSNull null]]&&![DefectiveCode isEqualToString:@""]&&![DefectiveCode containsString:@"null"]) {
                            expressCount += 1;
                        }
                    }
                } @catch (NSException *exception) {}
                
                vf.size.height = 117*2 + 20 + 687 + 44  + 44 + (44*([[CacheManagement instance].showSpecial isEqualToString:@"1"]?(isShowMi?3:2):0) + 44*expressCount + 5) ;
            }

            od.frame = vf ;
        }
        
        if ([oj isKindOfClass:[SeperateCustomCell class]]) {
        
            SeperateCustomCell *seperate= (SeperateCustomCell *)oj ;
            seperate.index = i ;
            seperate.dateLabel.text = [self.dataAry objectAtIndex:i] ;
            seperate.closeDateLabel.text = [NSString stringWithFormat:@"申请时间：%@",[self.dataAry objectAtIndex:i]];
            
            CGRect sf = seperate.frame ;
            sf.size.width = PHONE_WIDTH ;
            
            if ([self.viewAry count] > i+1) {
                
                id next = [self.viewAry objectAtIndex:i+1];
                
                if ([next isKindOfClass:[OrderDetailView class]]) {
                    
                    sf.size.height = 35 ;
                    
                    seperate.openBGView.hidden = NO ;
                    seperate.closeBGView.hidden = YES ;
                    seperate.backgroundColor = [CommonUtil colorWithHexString:@"#c8c7cc"] ;
                }
                else {
                
                    sf.size.height = 49 ;
                    
                    seperate.openBGView.hidden = YES ;
                    seperate.closeBGView.hidden = NO ;
                    seperate.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
                }
            }
            else {
            
                sf.size.height = 49 ;
                
                seperate.openBGView.hidden = YES ;
                seperate.closeBGView.hidden = NO ;
                seperate.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
            }
            
            seperate.frame = sf ;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGRect keyboardBounds = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGRect tframe = self.ProductTableView.frame;
    
    tframe.size.height = PHONE_HEIGHT - keyboardBounds.size.height;
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         
                         self.ProductTableView.frame = tframe;
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect tframe = self.ProductTableView.frame;
    
    tframe.size.height = PHONE_HEIGHT ;
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         
                         self.ProductTableView.frame = tframe;
                     }
                     completion:nil];
}

- (void)scrollToTop {

    [self.ProductTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)dealloc {

    [super dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)refreshLastPage{
    
    [self.delegate refreshList] ;
    [self.navigationController popViewControllerAnimated:NO] ;
}

- (void)refreshDetailList {
    
    for (int i = 0 ; i < [self.viewAry count] ; i++) {
        
        id oj = [self.viewAry objectAtIndex:i];
        
        if ([oj isKindOfClass:[OrderDetailView class]]) {
            
            OrderDetailView *od = (OrderDetailView *)oj ;
            
            BOOL isShowMi = NO ;
            @try {
                EditTableViewCell *cell13 = [od.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];//是否定制鞋
                if (cell13) isShowMi = cell13.selectWitch.on ;
                else if(od.dataDic) isShowMi = [@"1" isEqualToString:[NSString stringWithFormat:@"%@",[od.dataDic valueForKey:@"IsSpecial"]]] ;
            } @catch (NSException *exception) {
            }
            
            CGRect vf = od.frame ;
            
            vf.size.height = 687 + 44 + 44 + (44*([[CacheManagement instance].showSpecial isEqualToString:@"1"]?(isShowMi?3:2):0)) ;
            
            od.frame = vf ;
        }
    }
    
    [self.ProductTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

@end

















