//
//  ExerciseViewController.m
//  MobileApp
//
//  Created by 桂康 on 2019/9/17.
//

#import "ExerciseViewController.h"
#import "Utilities.h"
#import "CommonDefine.h"
#import "ExerciseCustomCell.h"
#import "SqliteHelper.h"
#import "NVMTrainingCheckResultEntity.h"
#import "NVMTrainingCheckPhotoEntity.h"
#import "XMLFileManagement.h"
#import "DateTimeViewController.h"
#import "ExerciseTitleViewController.h"
#import "JSON.h"

@interface ExerciseViewController ()<DateTimePickerDelegate,SelectExerciseTitleDelegate>

@end

@implementation ExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    keyboardArray = [NSMutableArray array];
    self.uploadManage = [[UploadManagement alloc] init];
    self.uploadManage.delegate = self;
    self.view.multipleTouchEnabled = NO;
    self.waitView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(60, 176, 200, 108)];
    imageview.image = [UIImage imageNamed:@"waiting.png"];
    [self.waitView addSubview:imageview];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(60, 245, 200, 21)];
    label.tag = 88;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.waitView addSubview:label];
    UIActivityIndicatorView* acview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [acview startAnimating];
    acview.frame = CGRectMake(142, 193, 37, 37);
    [self.waitView addSubview:acview];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.waitView ];
    ((UILabel*)[self.waitView viewWithTag:88]).text = SYSLanguage?@"Processing,please wait …":@"请稍等,正在执行...";
    [self.waitView setHidden:YES];
    
    [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:SYSLanguage?@"Upload":@"上传"];
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.title =SYSLanguage?@"VM TRAINING": @"培训";
    
    self.dataSourceArray = [NSMutableArray array];
    studentArray = [NSMutableArray array];
    
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
    [self UpdateNVM_IST_ISSUE_CHECK];
    [self getDetailData];
    self.ExerciseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH,DEHEIGHT-64-40) style:UITableViewStylePlain];
    self.ExerciseTableView.delegate = self;
    self.ExerciseTableView.dataSource = self;
    [self.ExerciseTableView setSectionHeaderHeight:0];
    self.ExerciseTableView.tableFooterView = [[UIView alloc] init];
    [self.ExerciseTableView setBackgroundColor:[UIColor whiteColor]];
    [self.ExerciseTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:self.ExerciseTableView];
    self.dataSourceArray = [NSMutableArray arrayWithArray:@[@"培训形式",@"培训师",@"培训对象",@"开始时间",@"结束时间",@"培训主题",@"主要内容",@"配合度",@"备注"]] ;
    if ([self.resultSourceArray.firstObject containsString:@"课堂"]) [self.dataSourceArray addObject:@"课堂培训"];
    if ([self.resultSourceArray.firstObject containsString:@"实操"]) [self.dataSourceArray addObject:@"实操培训"];
    if ([self.resultSourceArray.firstObject containsString:@"远程"]) [self.dataSourceArray addObject:@"远程培训"];
}

- (void) getDetailData {
    
    NSString* sql_photo = [NSString stringWithFormat:@"select * from NVM_IST_TRAINING_PHOTO_LIST where TRAINING_CHECK_ID ='%@' ",[CacheManagement instance].currentVMCHKID];
    self.photoSourceArray = [NSMutableArray array];
    FMResultSet* rs1 = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql_photo];
    while ([rs1 next]) {
        [self.photoSourceArray addObject:[[NVMTrainingCheckPhotoEntity alloc] initWithFMResultSet:rs1]];
    }
    [rs1 close];
    
    self.resultSourceArray = [NSMutableArray array];
    
    NSString* sql_data = [NSString stringWithFormat:@"select * from NVM_IST_TRAINING_RESULT_LIST where TRAINING_CHECK_ID ='%@' ",[CacheManagement instance].currentVMCHKID];
    NVMTrainingCheckResultEntity *current = [[NVMTrainingCheckResultEntity alloc] init];
    FMResultSet* rs2 = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql_data];
    while ([rs2 next]) {
        current = [[NVMTrainingCheckResultEntity alloc] initWithFMResultSet:rs2] ;
    }
    [rs2 close];
    NSString *time = current.TRAINEE_NUMBER?current.TRAINEE_NUMBER:@"~" ;
    self.resultSourceArray = [NSMutableArray arrayWithArray:@[current.TRAINING_TYPE?current.TRAINING_TYPE:@"",
                                                              current.TRAINER?current.TRAINER:[CacheManagement instance].currentUser.UserName,
                                                              @"",
                                                              [time componentsSeparatedByString:@"~"].firstObject,
                                                              [time componentsSeparatedByString:@"~"].lastObject,
                                                              current.TRAIN_TITLE?current.TRAIN_TITLE:@"",
                                                              @"",
                                                              current.TRAIN_PARTICIPANT?current.TRAIN_PARTICIPANT:@"",
                                                              current.REMARK?current.REMARK:@""]] ;
    
    if (current.TRAIN_OBJECT&&![current.TRAIN_OBJECT isEqualToString:@""]&&![current.TRAIN_OBJECT isEqual:[NSNull null]]) {
        studentArray = [current.TRAIN_OBJECT JSONValue];
    } else {
        studentArray = [NSMutableArray array];
    }
    
    if (current.TRAIN_COMMENT&&![current.TRAIN_COMMENT isEqualToString:@""]&&![current.TRAIN_COMMENT isEqual:[NSNull null]]) {
        pointArray = [current.TRAIN_COMMENT JSONValue];
    } else {
        pointArray = [NSMutableArray array];
    }
}

- (void) UpdateNVM_IST_ISSUE_CHECK {
    
    NSArray* arr = [self checkNVM_IST_ISSUE_CHECK];
    
    if ( arr.count > 0)
    {
        [CacheManagement instance].currentVMCHKID = [arr objectAtIndex:0];
    }
    else
    {
        NSString* CHK_ID = [CacheManagement instance].currentWorkMainID;
        [CacheManagement instance].currentVMCHKID = CHK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_TRAINING_CHECK (TRAINING_CHECK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         CHK_ID,
         storeCode,
         userid,
         [CacheManagement instance].currentWorkMainID,
         workdate,
         workstarttime,
         workendtime,
         workendtime,   // 提交时间
         nil,
         nil];
    }
}

- (NSArray*)checkNVM_IST_ISSUE_CHECK {
    
    NSMutableArray* resultarr = [NSMutableArray array];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_TRAINING_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'  ",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    return resultarr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    ExerciseCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"ExerciseCustomCell" owner:self options:nil];
        for (UIView *view in nibAry) {
            if ([view isKindOfClass:[ExerciseCustomCell class]]) {
                cell = (ExerciseCustomCell *)view ;
                break ;
            }
        }
    }
    
    cell.studentTableView.hidden = YES ;
    CGRect tframe = cell.studentTableView.frame ;
    tframe.size.height = 0;
    cell.shortView.hidden = YES ;
    cell.tallView.hidden = YES ;
    cell.picView.hidden = YES ;
    cell.saveArray = self.resultSourceArray ;
    cell.checkId = [CacheManagement instance].currentVMCHKID;
    cell.vc = self ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    if (self.dataSourceArray.count > indexPath.row) {
        
        NSString *name = [self.dataSourceArray objectAtIndex:indexPath.row] ;
        
        if ([name containsString:@"课堂"] || [name containsString:@"实操"] || [name containsString:@"远程"]) {
            cell.picView.hidden = NO ;
        } else if ( [name containsString:@"备注"]) {
            cell.tallView.hidden = NO ;
        } else {
            cell.shortView.hidden = NO ;
        }
        
        if (!cell.shortView.hidden) {
            cell.titleLabel.text = [NSString stringWithFormat:@" %@：",name] ;
            cell.valueTextField.text = [self.resultSourceArray objectAtIndex:indexPath.row];
            cell.valueTextField.enabled = NO ;
            cell.valueTextField.placeholder = [NSString stringWithFormat:@"请选择%@",name];
            if (indexPath.row == 1){
                cell.valueTextField.text = [CacheManagement instance].currentUser.UserName ;
            }
            if (indexPath.row == 2) {
                cell.valueTextField.placeholder = [NSString stringWithFormat:@"点击添加%@",name];
            }
            if (indexPath.row == 6) {
                cell.valueTextField.placeholder = [NSString stringWithFormat:@"点击添加%@(至少添加2条)",name];
            }
        }
    
        if (!cell.tallView.hidden) {
            cell.secTitleLabel.text = [NSString stringWithFormat:@" %@：",name] ;
            cell.holderLabel.text = [NSString stringWithFormat:@"请输入%@",name];
            cell.valueTextView.text = [self.resultSourceArray objectAtIndex:indexPath.row];
            cell.holderLabel.hidden = ![cell.valueTextView.text isEqualToString:@""] ;
        }
        
        if (!cell.picView.hidden) {
            
            NSString *showTit = [NSString stringWithFormat:@" %@ (至少添加培训师、培训对象两张图片,长按图片查看大图)",name] ;
            @try {
                NSString *oldString = showTit;
                NSString *normalString = [NSString stringWithFormat:@" %@ ",name];
                NSMutableAttributedString *statusLabel = [[NSMutableAttributedString alloc] initWithString:oldString];
                NSRange r1 = NSMakeRange([normalString length], [oldString length]- [normalString length]) ;
                [statusLabel addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:r1];
                cell.picTitleLabel.attributedText = statusLabel ;
            } @catch (NSException *exception) {
                cell.picTitleLabel.text = showTit ;
            }
            
            NSString *type = @"" ;
            if ([name containsString:@"课堂"]) type = @"1" ;
            if ([name containsString:@"实操"]) type = @"2" ;
            if ([name containsString:@"远程"]) type = @"3" ;
            NSMutableArray *allPic = [NSMutableArray array];
            for (NVMTrainingCheckPhotoEntity *ent in self.photoSourceArray) {
                if ([ent.PHOTO_TYPE isEqualToString:type]) {
                    [allPic addObject:ent];
                }
            }
            cell.imageArray = allPic;
        }
        
        if ([name containsString:@"培训对象"]) {
            cell.dataArray = studentArray;
            cell.studentTableView.hidden = NO ;
            tframe.size.height = [studentArray count]*40;
        }
        
        if ([name containsString:@"主要内容"]) {
            cell.dataArray = pointArray;
            cell.studentTableView.hidden = NO ;
            tframe.size.height = [pointArray count]*40;
        }
        
        cell.studentTableView.frame = tframe ;
    }
    
    if (![keyboardArray containsObject:cell.valueTextView]) [keyboardArray addObject:cell.valueTextView];

    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataSourceArray.count) {
        
        NSString *name = [self.dataSourceArray objectAtIndex:indexPath.row] ;
        
        if ([name containsString:@"备注"]) {
            
            return 155 ;
        }
        
        if ([name containsString:@"课堂"]||[name containsString:@"实操"]||[name containsString:@"远程"]) {
            
            NSString *type = @"" ;
            if ([name containsString:@"课堂"]) type = @"1" ;
            if ([name containsString:@"实操"]) type = @"2" ;
            if ([name containsString:@"远程"]) type = @"3" ;
            
            int count = 1 ;
            for (NVMTrainingCheckPhotoEntity *ent in self.photoSourceArray) {
                if ([ent.PHOTO_TYPE isEqualToString:type]) {
                    count += 1 ;
                }
            }
            if (count  >  3) {
                int line = count/3 ;
                if (count % 3 != 0) line = line + 1 ;
                return 172 + (line-1)*(90.0/320*DEWIDTH>117?117:90.0/320*DEWIDTH) + (line-1)*20;
            }
            return 172 ;
        }
        
        int otherHeight = 0 ;
        
        if ([name containsString:@"培训对象"]) {
            
            otherHeight = (int)[studentArray count]*40;
        }
        
        if ([name containsString:@"主要内容"]) {
            
            otherHeight = (int)[pointArray count]*40;
        }
        
        return 55 + otherHeight ;
    }
    
    return 0 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self resignAllKeyBoard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self resignFirstResponder];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"请选择培训形式" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"课堂培训" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.resultSourceArray replaceObjectAtIndex:indexPath.row withObject:@"课堂培训"];
            [self.dataSourceArray removeObject:@"课堂培训"];
            [self.dataSourceArray removeObject:@"实操培训"];
            [self.dataSourceArray removeObject:@"远程培训"];
            [self.dataSourceArray addObject:@"课堂培训"];
            [self.ExerciseTableView reloadData];
        }];
        UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"实操培训" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.resultSourceArray replaceObjectAtIndex:indexPath.row withObject:@"实操培训"];
            [self.dataSourceArray removeObject:@"课堂培训"];
            [self.dataSourceArray removeObject:@"实操培训"];
            [self.dataSourceArray removeObject:@"远程培训"];
            [self.dataSourceArray addObject:@"实操培训"];
            [self.ExerciseTableView reloadData];
        }];
        UIAlertAction *ac3 = [UIAlertAction actionWithTitle:@"课堂+实操培训" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.resultSourceArray replaceObjectAtIndex:indexPath.row withObject:@"课堂+实操培训"];
            [self.dataSourceArray removeObject:@"课堂培训"];
            [self.dataSourceArray removeObject:@"实操培训"];
            [self.dataSourceArray removeObject:@"远程培训"];
            [self.dataSourceArray addObject:@"课堂培训"];
            [self.dataSourceArray addObject:@"实操培训"];
            [self.ExerciseTableView reloadData];
        }];
        UIAlertAction *ac5 = [UIAlertAction actionWithTitle:@"远程培训" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.resultSourceArray replaceObjectAtIndex:indexPath.row withObject:@"远程培训"];
            [self.dataSourceArray removeObject:@"课堂培训"];
            [self.dataSourceArray removeObject:@"实操培训"];
            [self.dataSourceArray removeObject:@"远程培训"];
            [self.dataSourceArray addObject:@"远程培训"];
            [self.ExerciseTableView reloadData];
        }];
        UIAlertAction *ac4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [ac addAction:ac1];[ac addAction:ac2];[ac addAction:ac3];[ac addAction:ac5];[ac addAction:ac4];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    if (indexPath.row == 2) {
        
        NSArray *students = @[@"Store management",@"Store staff",@"RO",@"CVM",@"AVM",@"OVM"] ;
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"请选择培训对象" preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *str in students) {
            UIAlertAction *ac1 = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                BOOL isAdded  = NO ;
                for (NSDictionary *added in studentArray) {
                    if ([[NSString stringWithFormat:@"%@",[added valueForKey:@"name"]] isEqualToString:str]) {
                        isAdded = YES ;
                        break ;
                    }
                }
                if (isAdded) {
                    ALERTVIEW(@"已经添加过此培训对象!");
                } else {
                    UIAlertController *others = [UIAlertController alertControllerWithTitle:nil message:@"培训人数" preferredStyle:UIAlertControllerStyleAlert];
                    [others addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = [NSString stringWithFormat:@"请输入%@培训人数",str];
                        textField.keyboardType = UIKeyboardTypeNumberPad;
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    }];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (others.textFields.count && others.textFields.firstObject.text.intValue > 0) {
                            
                            BOOL isAdded  = NO ;
                            for (NSDictionary *added in studentArray) {
                                if ([[NSString stringWithFormat:@"%@",[added valueForKey:@"name"]] isEqualToString:str]) {
                                    isAdded = YES ;
                                    break ;
                                }
                            }
                            if (isAdded) {
                                ALERTVIEW(@"已经添加过此培训对象!");
                            } else {
                                NSDictionary *dic = @{@"name":str,@"count":others.textFields.firstObject.text};
                                [studentArray addObject:dic];
                                [self.ExerciseTableView reloadData];
                            }
                        } else {
                             ALERTVIEW(@"请输入大于0的数字");
                        }
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [others addAction:cancel];[others addAction:ok];
                    [self presentViewController:others animated:YES completion:nil];
                }
            }];
            [ac addAction:ac1];
        }
        UIAlertAction *ac4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:ac4];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    if (indexPath.row == 3 || indexPath.row == 4) {
        DateTimeViewController *recommandVC = [[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil] ;
        recommandVC.delegate = self;
        recommandVC.index = indexPath.row;
        recommandVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:recommandVC animated:NO completion:^{}];
    }
    
    if (indexPath.row == 5) {
        
        ExerciseTitleViewController *title = [[ExerciseTitleViewController alloc] initWithNibName:@"ExerciseTitleViewController" bundle:nil] ;
        title.delegate = self;
        title.index = indexPath.row;
        NSArray *dataSourceAry = @[@"月度活动执行",@"陈列入门",@"12课题",@"其它"];
        if (SYSLanguage) {
            dataSourceAry = @[@"Monthly campaign execution",@"VM orientation",@"12 topics",@"Other"];
        }
        title.dataSourceAry = dataSourceAry;
        if ([self.resultSourceArray count] > indexPath.row) title.oldString = [self.resultSourceArray objectAtIndex:indexPath.row];
        title.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:title animated:NO completion:^{}];
    }
    
    if (indexPath.row == 6) {
        
        UIAlertController *others = [UIAlertController alertControllerWithTitle:nil message:@"主要内容" preferredStyle:UIAlertControllerStyleAlert];
            [others addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入主要内容";
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            }];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (others.textFields.count && others.textFields.firstObject.text.length > 0) {
                    [pointArray addObject:others.textFields.firstObject.text];
                    [self.ExerciseTableView reloadData];
                } else {
                     ALERTVIEW(@"请输入主要内容");
                }
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [others addAction:cancel];[others addAction:ok];
            [self presentViewController:others animated:YES completion:nil];
        
    }
    
    if (indexPath.row == 7) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"请选择配合度" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"完全参与" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.resultSourceArray replaceObjectAtIndex:indexPath.row withObject:@"完全参与"];
            [self.ExerciseTableView reloadData];
        }];
        UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"部分参与" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.resultSourceArray replaceObjectAtIndex:indexPath.row withObject:@"部分参与"];
            [self.ExerciseTableView reloadData];
        }];
        [ac addAction:ac1];[ac addAction:ac2];
        
        UIAlertAction *ac4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [ac addAction:ac4];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)currentDate:(NSString *)date withIndex:(NSUInteger)index{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *current = [formatter dateFromString:date];
    
    if (index == 3 && ![@"" isEqualToString:[self.resultSourceArray objectAtIndex:4]]) {
        NSDate *other = [formatter dateFromString:[self.resultSourceArray objectAtIndex:4]];
        if ([[other laterDate:current] isEqualToDate:current]) {
            ALERTVIEW(@"开始时间应该早于结束时间!");
            return ;
        }
    }
    
    if (index == 4 && ![@"" isEqualToString:[self.resultSourceArray objectAtIndex:3]]) {
        NSDate *other = [formatter dateFromString:[self.resultSourceArray objectAtIndex:3]];
        if ([[other laterDate:current] isEqualToDate:other]) {
            ALERTVIEW(@"结束时间应该晚于结开始时间!");
            return ;
        }
    }
    
    [self.resultSourceArray replaceObjectAtIndex:index withObject:date];
    [self.ExerciseTableView reloadData];
}

- (void)jumpToSelect:(NSString *)index {
    
    ExerciseTitleViewController *title = [[ExerciseTitleViewController alloc] initWithNibName:@"ExerciseTitleViewController" bundle:nil] ;
    title.delegate = self;
    title.index = [index integerValue];
    NSString *trainTitle = (SYSLanguage?[CacheManagement instance].currentUser.TrainingTitleEN:[CacheManagement instance].currentUser.TrainingTitleCN);
    title.dataSourceAry = [trainTitle componentsSeparatedByString:@";"];
    if ([self.resultSourceArray count] > [index integerValue]) title.oldString = [self.resultSourceArray objectAtIndex:[index integerValue]];
    title.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:title animated:NO completion:^{}];
}

- (void)jumpToEdit:(NSString *)index {
    
    UIAlertController *others = [UIAlertController alertControllerWithTitle:nil message:@"培训主题" preferredStyle:UIAlertControllerStyleAlert];
    [others addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入培训主题" ;
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (others.textFields.count) {
            [self.resultSourceArray replaceObjectAtIndex:[index integerValue] withObject:others.textFields.firstObject.text];
            [self.ExerciseTableView reloadData];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [others addAction:cancel];[others addAction:ok];
    [self presentViewController:others animated:YES completion:nil];
}

- (void)currentTitle:(NSString *)title withIndex:(NSUInteger)index{
    
    if ([title isEqualToString:@"12课题"]||[title isEqualToString:@"12 topics"]) {
        
        [self performSelector:@selector(jumpToSelect:) withObject:[NSString stringWithFormat:@"%d",(int)index] afterDelay:0.5];
        return;
    }
    
    if ([title isEqualToString:@"Other"]||[title isEqualToString:@"其它"]) {
        
        [self performSelector:@selector(jumpToEdit:) withObject:[NSString stringWithFormat:@"%d",(int)index] afterDelay:0.5];
        return;
    }
    
    [self.resultSourceArray replaceObjectAtIndex:index withObject:title];
    [self.ExerciseTableView reloadData];
}


- (void) back {
    [self resignAllKeyBoard];
    [self.navigationController popViewControllerAnimated:YES];
    [self saveAllData];
}

- (void)saveAllData {
    
    NVMTrainingCheckResultEntity *current = [[NVMTrainingCheckResultEntity alloc] init];
    current.TRAINING_TYPE = [self.resultSourceArray objectAtIndex:0];
    current.TRAINER = [self.resultSourceArray objectAtIndex:1];
    current.TRAIN_OBJECT = [studentArray JSONRepresentation];
    current.TRAINEE_NUMBER = [NSString stringWithFormat:@"%@~%@",[self.resultSourceArray objectAtIndex:3],[self.resultSourceArray objectAtIndex:4]];
    current.TRAIN_TITLE = [self.resultSourceArray objectAtIndex:5];
    current.TRAIN_COMMENT = [pointArray JSONRepresentation];
    current.TRAIN_PARTICIPANT = [self.resultSourceArray objectAtIndex:7];
    current.REMARK = [self.resultSourceArray objectAtIndex:8];
    
    NSString* sql_data = [NSString stringWithFormat:@"select * from NVM_IST_TRAINING_RESULT_LIST where TRAINING_CHECK_ID ='%@' ",[CacheManagement instance].currentVMCHKID];
    FMResultSet* rs2 = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql_data];
    BOOL exist = NO ;
    while ([rs2 next]) {
        exist = YES ;
    }
    [rs2 close];
    
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    [db beginTransaction];
    BOOL result = YES;
    
    @try
    {
        if (exist) {
            NSString *sql = [NSString stringWithFormat:@"UPDATE NVM_IST_TRAINING_RESULT_LIST SET TRAINING_TYPE = '%@',TRAINER = '%@',TRAIN_COMMENT = '%@',TRAINEE_NUMBER = '%@',TRAIN_OBJECT = '%@',TRAIN_TITLE = '%@',REMARK = '%@',LAST_MODIFIED_TIME = '%@',LAST_MODIFIED_BY = '%@',TRAIN_PARTICIPANT = '%@' where TRAINING_CHECK_ID = '%@'",current.TRAINING_TYPE,
            current.TRAINER,
            current.TRAIN_COMMENT,
            current.TRAINEE_NUMBER,
            current.TRAIN_OBJECT,
            current.TRAIN_TITLE,
            current.REMARK,
            [Utilities DateTimeNow],
            [CacheManagement instance].currentUser.UserName,
            current.TRAIN_PARTICIPANT,
            [CacheManagement instance].currentVMCHKID];
            [db executeUpdate:sql];
        } else {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_TRAINING_RESULT_LIST (TRAINING_RESULT_LIST_ID,TRAINING_CHECK_ID,TRAINING_TYPE,TRAINER,TRAIN_COMMENT,TRAINEE_NUMBER,TRAIN_OBJECT,TRAIN_TITLE,REMARK,LAST_MODIFIED_TIME,LAST_MODIFIED_BY,TRAIN_PARTICIPANT) values (?,?,?,?,?,?,?,?,?,?,?,?)"];
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
             [NSUUID UUID].UUIDString,
             [CacheManagement instance].currentVMCHKID,
             current.TRAINING_TYPE,
             current.TRAINER,
             current.TRAIN_COMMENT,
             current.TRAINEE_NUMBER,
             current.TRAIN_OBJECT,
             current.TRAIN_TITLE,
             current.REMARK,
             [Utilities DateTimeNow],
             [CacheManagement instance].currentUser.UserName,
             current.TRAIN_PARTICIPANT];
        }
        
        NSString* sql_delete = [NSString stringWithFormat:@"delete from NVM_IST_TRAINING_PHOTO_LIST where TRAINING_CHECK_ID ='%@' ",[CacheManagement instance].currentVMCHKID];
        [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql_delete];
        
        if (self.photoSourceArray&&self.photoSourceArray.count) {
            
            for (NVMTrainingCheckPhotoEntity *entity in self.photoSourceArray) {
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_TRAINING_PHOTO_LIST (TRAINING_PHOTO_LIST_ID,TRAINING_CHECK_ID,PHOTO_TYPE,PHOTO_PATH,COMMENT,LAST_MODIFIED_TIME,LAST_MODIFIED_BY) values (?,?,?,?,?,?,?)"];
                FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                 [NSUUID UUID].UUIDString,
                 [CacheManagement instance].currentVMCHKID,
                 entity.PHOTO_TYPE,
                 entity.PHOTO_PATH,
                 entity.COMMENT,
                 [Utilities DateTimeNow],
                 [CacheManagement instance].currentUser.UserName];
            }
        }
    }
    @catch (NSException *exception)
    {
        result = NO;
    }
    @finally
    {
        if (result == YES)
        {
            [db commit];
        }
        else
        {
            [db rollback];
        }
        
        for (UIView *view in keyboardArray) {
            [view removeFromSuperview];
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGRect keyboardBounds = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGRect tframe = self.ExerciseTableView.frame;
    
    tframe.size.height = DEHEIGHT- 104 - keyboardBounds.size.height;
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         
                         self.ExerciseTableView.frame = tframe;
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect tframe = self.ExerciseTableView.frame;
    
    tframe.size.height = DEHEIGHT - 104 ;
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         
                         self.ExerciseTableView.frame = tframe;
                     }
                     completion:nil];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void) resignAllKeyBoard {
    
    for (UIView *view in keyboardArray) {
        if (view&&[view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            [field resignFirstResponder];
        }
        if (view&&[view isKindOfClass:[UITextView class]]) {
            UITextView *field = (UITextView *)view;
            [field resignFirstResponder];
        }
    }
}

- (void)resetImage:(NSMutableArray *)image with:(nonnull NSString *)type{
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NVMTrainingCheckPhotoEntity *ent in self.photoSourceArray) {
        if (![ent.PHOTO_TYPE isEqualToString:type]) {
            [temp addObject:ent];
        }
    }
    self.photoSourceArray = [NSMutableArray arrayWithArray:temp];
    [self.photoSourceArray addObjectsFromArray:image];
    
    [self.ExerciseTableView reloadData];
    [self saveAllData];
}

- (void) showUploadAlert {
    
    [self resignAllKeyBoard];
    
    if ([self.resultSourceArray.firstObject isEqualToString:@""]) {
        ALERTVIEW(SYSLanguage?@"Please select training type": @"请选择培训形式");
        return ;
    }
    
    if ([[self.resultSourceArray objectAtIndex:3] isEqualToString:@""]) {
        ALERTVIEW(@"请选择培训开始时间!");
        return ;
    }
    
    if ([[self.resultSourceArray objectAtIndex:4] isEqualToString:@""]) {
        ALERTVIEW(@"请选择培训结束时间!");
        return ;
    }
    
    if ([[self.resultSourceArray objectAtIndex:5] isEqualToString:@""]) {
        ALERTVIEW(@"请选择培训主题!");
        return ;
    }
    
    if (studentArray.count <= 0) {
        ALERTVIEW(@"请添加培训对象!");
        return ;
    }
    
    if (pointArray.count < 2) {
        ALERTVIEW(@"请添加2条培训内容!");
        return ;
    }
    
    if (self.photoSourceArray.count == 0) {
        ALERTVIEW(SYSLanguage?@"Sorry,not exist image!":@"上传失败,没有照片,请至少拍摄一组照片!");
        return ;
    }
    
    
    int firCount = 0 ;
    BOOL existFirst = false ;
    if ([self.resultSourceArray.firstObject containsString:@"课堂"]) {
        for (NVMTrainingCheckPhotoEntity *entity in self.photoSourceArray) {
            if ([entity.PHOTO_TYPE isEqualToString:@"1"]) {
                existFirst = true ;
                firCount +=1 ;
            }
        }
    }
    
    if (existFirst && firCount < 2) {
        ALERTVIEW(@"上传失败,课堂培训请至少拍摄2张照片！");
        return ;
    }
    
    int secCount = 0 ;
    BOOL existSecond = false ;
    if ([self.resultSourceArray.firstObject containsString:@"实操"]) {
        for (NVMTrainingCheckPhotoEntity *entity in self.photoSourceArray) {
            if ([entity.PHOTO_TYPE isEqualToString:@"2"]) {
                existSecond = true ;
                secCount +=1 ;
            }
        }
    }
    
    if (existSecond && secCount < 2) {
        ALERTVIEW(@"上传失败,实操培训请至少拍摄2张照片！");
        return ;
    }
    
    int thiCount = 0 ;
    BOOL existThird = false ;
    if ([self.resultSourceArray.firstObject containsString:@"远程"]) {
        for (NVMTrainingCheckPhotoEntity *entity in self.photoSourceArray) {
            if ([entity.PHOTO_TYPE isEqualToString:@"3"]) {
                existThird = true ;
                thiCount +=1 ;
            }
        }
    }
    
    if (existThird && thiCount < 2) {
        ALERTVIEW(@"上传失败,远程培训请至少有2张照片！");
        return ;
    }
    
    NSString* title = @"是否确定上传";
    if (SYSLanguage == EN) {
        title = @"Are you sure to upload ?";
    }
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:SYSLanguage?@"Sure": @"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self upload];
    }];

    
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel": @"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [ac addAction:ac1];
    [ac addAction:ac2];
    [self presentViewController:ac animated:YES completion:nil];
}


- (void)upload {
    [self saveAllData];
    
    NVMTrainingCheckResultEntity *current = [[NVMTrainingCheckResultEntity alloc] init];
    current.TRAINING_TYPE = [self.resultSourceArray objectAtIndex:0];
    current.TRAINER = [self.resultSourceArray objectAtIndex:1];
    current.TRAIN_OBJECT = [studentArray JSONRepresentation];
    current.TRAINEE_NUMBER = [NSString stringWithFormat:@"%@~%@",[self.resultSourceArray objectAtIndex:3],[self.resultSourceArray objectAtIndex:4]];
    current.TRAIN_TITLE = [self.resultSourceArray objectAtIndex:5];
    current.TRAIN_COMMENT = [pointArray JSONRepresentation];
    current.TRAIN_PARTICIPANT = [self.resultSourceArray objectAtIndex:7];
    current.REMARK = [self.resultSourceArray objectAtIndex:8];
    
    // 制作xml 文件
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString = [xmlcon CreateTrainingCheckString:self.photoSourceArray
                                                WorkEndTime:[Utilities DateTimeNow]
                                              TrainingChkId:[CacheManagement instance].currentVMCHKID
                                              WorkStartTime:[Utilities DateTimeNow]
                                                  StoreCode:[CacheManagement instance].currentStore.StoreCode
                                                 submittime:[Utilities DateTimeNow]
                                                   WorkDate:[Utilities DateNow]
                                                     result:current
                                ClientUploadTimeForWorkMain:[CacheManagement instance].checkinTime] ;
    
    if ([CacheManagement instance].uploaddata == YES)
    {
        NSMutableArray *pic = [NSMutableArray array];
        for (NVMTrainingCheckPhotoEntity *entity in self.photoSourceArray) {
            [pic addObject:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],entity.PHOTO_PATH]];
        }
        
        [self.uploadManage uploadVMRailCheckFileToServer:xmlString
                                                fileType:kVMXmlUploadTraining
                                          andfilePathArr:pic
                                              andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        // 更新本地事项状态
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET TRAININGCHECK = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
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
            NSString* cachePath = [rs stringForColumn:@"TRINING_XML_PATH"];
            
            if ([cachePath length] < 10) {
                cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
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
            NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 数据库存在记录 update
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"TRAINING"];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET TRINING_PIC_PATH = '%@',TRINING_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            [db executeUpdate:update_sql];
        }
        else{
            // 写xml到本地
            NSString* cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath])
            {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"TRAINING"];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,TRINING_PIC_PATH,STORE_NAME,USER_ID,TRINING_XML_PATH) values (?,?,?,?,?,?)"];
            
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,picpath,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
        self.waitView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)completeUploadServer:(NSString *)error
{
    self.waitView.hidden = YES;
    if ([error length] == 0)
    {
        Uploadstatu = 1;
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET TRAININGCHECK = '%@' where WORKMAINID = '%@'",@"2",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [HUD showUIBlockingIndicatorWithText:error withTimeout:2];
    }
}
@end
