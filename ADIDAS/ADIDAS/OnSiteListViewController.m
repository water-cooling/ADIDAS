//
//  OnSiteListViewController.m
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "OnSiteListViewController.h"
#import "SqliteHelper.h"
#import "CacheManagement.h"
#import "AppDelegate.h"
#import "XMLFileManagement.h"
#import "CommonDefine.h"
#import "VisitStoreEntity.h"
#import "TakePhotoListCell.h"
#import "OnSiteViewController.h"
#import "OnSiteEntity.h"
#import "Utilities.h"
#import "UIImage+resize.h"


@interface OnSiteListViewController ()<installcellDelegate>

@end

@implementation OnSiteListViewController
@synthesize takePhoto_list_TableView;

// 本地数据库读取见检查项
- (void)GetCheckIssueFromDB {
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    self.PhotoListArr = [[NSMutableArray alloc]init];
    {
        NSString *sql = [NSString stringWithFormat:@"select b.ZONE_ID as ZONE_ID_NEW,a.*,b.BEFORE_PHOTO_PATH,b.AFTER_PHOTO_PATH,b.BEFORE_ADJUSTMENT_MODE,b.AFTER_ADJUSTMENT_MODE,b.COMMENT from NVM_MST_ONSITE_PHOTOZONE a left join NVM_IST_ONSITE_CHECK_DETAIL b on b.ZONE_ID like '%%'||a.ZONE_ID||'%%' and b.ONSITE_CHECK_ID = '%@' where a.ZONE_ID = '%@' order by a.ZONE_ORDER asc",[CacheManagement instance].currentTakeID,self.currentEntity.ZONE_ID] ;
        FMResultSet* rs = [db executeQuery:sql];
        
        while([rs next])
        {
            NvmMstOnSitePhotoZoneEntity* checkEntity = [[NvmMstOnSitePhotoZoneEntity alloc]initWithFMResultSet:rs];
            [self.PhotoListArr addObject:checkEntity] ;
        }
        [rs close];
    }
}

#pragma mark - tableviewdelegate

- (void)openCamera:(UIImagePickerController *)picker Cell:(id)cell {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OnSiteViewController* photoVC = [[OnSiteViewController alloc]initWithNibName:@"OnSiteViewController" bundle:nil];
    NvmMstOnSitePhotoZoneEntity *entity = [self.PhotoListArr objectAtIndex:indexPath.row];
    photoVC.entity = entity;
    photoVC.PhotoListArr = [NSArray arrayWithArray:self.PhotoListArr];
    [self.navigationController pushViewController:photoVC animated:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Back":@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:item] ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"cell";
    TakePhotoListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TakePhotoListCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.indexType = indexPath.row;
    cell.delegate = self ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.before.userInteractionEnabled = NO;
    cell.after.userInteractionEnabled = NO;
    [cell.before setImage:[UIImage imageNamed:@"sbefore.png"]];
    [cell.after setImage:[UIImage imageNamed:@"safter.png"]];
    cell.doneImage.hidden = NO;
    BOOL isDone = NO ;
    
    NvmMstOnSitePhotoZoneEntity *entity = [self.PhotoListArr objectAtIndex:indexPath.row];
    
    if (![entity.BEFORE_PHOTO_PATH isEqualToString:@"0"]&&
        ![entity.BEFORE_PHOTO_PATH.lowercaseString containsString:@"null"]&&
        entity.BEFORE_PHOTO_PATH.length > 10) {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[entity.BEFORE_PHOTO_PATH componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            [cell.before setImage:[[UIImage imageWithContentsOfFile:newfile] scaleToSize:CGSizeMake(50, 50)]];
            isDone = YES;
        }
    }
    
    if (![entity.AFTER_PHOTO_PATH isEqualToString:@"0"]&&
        ![entity.AFTER_PHOTO_PATH.lowercaseString containsString:@"null"]&&
        entity.AFTER_PHOTO_PATH.length > 10) {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[entity.AFTER_PHOTO_PATH componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            [cell.after setImage:[[UIImage imageWithContentsOfFile:newfile] scaleToSize:CGSizeMake(50, 50)]];
        }else if (([entity.AFTER_ADJUSTMENT_MODE.lowercaseString containsString:@"null"]||[entity.AFTER_ADJUSTMENT_MODE isEqualToString:@""]))
            isDone = NO ;
    } else if (([entity.AFTER_ADJUSTMENT_MODE.lowercaseString containsString:@"null"]||[entity.AFTER_ADJUSTMENT_MODE isEqualToString:@""]))
        isDone = NO ;
    
    if (![entity.BEFORE_ADJUSTMENT_MODE.lowercaseString containsString:@"null"]&&![entity.BEFORE_ADJUSTMENT_MODE isEqualToString:@""]) isDone = YES;
    
    if (isDone) {
        cell.doneImage.image = [UIImage imageNamed:@"yes.png"];
    } else {
        cell.doneImage.image = [UIImage imageNamed:@"not_complete.png"];
    }
    
    cell.titleLabel.text = SYSLanguage?entity.ZONE_NAME_EN: entity.ZONE_NAME_CN;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.PhotoListArr count];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)addNew:(id)cell {
    
    TakePhotoListCell *Cell = cell;
    if (self.PhotoListArr.count > Cell.indexType) {
        NvmMstOnSitePhotoZoneEntity *entity = [self.PhotoListArr objectAtIndex:Cell.indexType];
        
        int count = 0 ;
        for (NvmMstOnSitePhotoZoneEntity *entityTemp in self.PhotoListArr) {
            if ([[entityTemp.ZONE_ID componentsSeparatedByString:@"_"].firstObject isEqualToString:[entity.ZONE_ID componentsSeparatedByString:@"_"].firstObject]) {
                count += 1;
            }
        }
        if (count >= entity.PHOTO_NUM.intValue) {
            ALERTVIEW(SYSLanguage?@"Sorry,can not add":@"对不起,不能再添加了");
            return;
        }
        
        OnSiteViewController* photoVC = [[OnSiteViewController alloc]initWithNibName:@"OnSiteViewController" bundle:nil];
        if (!entity.ZONE_ID_NEW||[entity.ZONE_ID_NEW isEqual:[NSNull null]]||[entity.ZONE_ID_NEW isEqualToString:@""]) {
            photoVC.entity = entity;
        } else {
            NvmMstOnSitePhotoZoneEntity *entityNEW = [[NvmMstOnSitePhotoZoneEntity alloc] init];
            entityNEW.ZONE_ID = [NSString stringWithFormat:@"%@_%d",[entity.ZONE_ID componentsSeparatedByString:@"_"].firstObject,count];
            entityNEW.ZONE_NAME_CN = [NSString stringWithFormat:@"%@_%d",[entity.ZONE_NAME_CN componentsSeparatedByString:@"_"].firstObject,count];
            entityNEW.ZONE_NAME_EN = [NSString stringWithFormat:@"%@_%d",[entity.ZONE_NAME_EN componentsSeparatedByString:@"_"].firstObject,count];
            entityNEW.PHOTO_NUM = entity.PHOTO_NUM;
            entityNEW.ZONE_ORDER = entity.ZONE_ORDER;
            entityNEW.ZONE_STATUS = entity.ZONE_STATUS;
            entityNEW.LAST_MODIFIED_BY = entity.LAST_MODIFIED_BY;
            entityNEW.LAST_MODIFIED_TIME = entity.LAST_MODIFIED_TIME;
            entityNEW.DATA_SOURCE = entity.DATA_SOURCE;
            entityNEW.BEFORE_PHOTO_PATH = @"0";
            entityNEW.AFTER_PHOTO_PATH = @"0";
            entityNEW.BEFORE_ADJUSTMENT_MODE = @"";
            entityNEW.AFTER_ADJUSTMENT_MODE = @"";
            entityNEW.COMMENT = @"";
            photoVC.entity = entityNEW;
        }
        
        [self.navigationController pushViewController:photoVC animated:YES];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Back":@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:item] ;
    }
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.multipleTouchEnabled = NO;
    self.navigationItem.title = SYSLanguage?self.currentEntity.ZONE_NAME_EN:self.currentEntity.ZONE_NAME_CN;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    
    [self GetCheckIssueFromDB];
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
    
    self.takePhoto_list_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH,DEVICE_HEIGHT-64-40) style:UITableViewStylePlain];
    self.takePhoto_list_TableView.delegate = self;
    self.takePhoto_list_TableView.dataSource = self;
    self.takePhoto_list_TableView.tableFooterView = [[UIView alloc] init];
    [self.takePhoto_list_TableView setSectionHeaderHeight:0];
    self.takePhoto_list_TableView.rowHeight = 78;
    [self.takePhoto_list_TableView setBackgroundColor:[UIColor whiteColor]];
    [self.takePhoto_list_TableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:self.takePhoto_list_TableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self GetCheckIssueFromDB];
    [self.takePhoto_list_TableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
