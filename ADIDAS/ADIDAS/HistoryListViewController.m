//
//  HistoryListViewController.m
//  ADIDAS
//
//  Created by joinone on 15/1/26.
//
//

#import "HistoryListViewController.h"
#import "FMResultSet.h"
#import "SqliteHelper.h"
#import "IST_WORK_MAIN.h"
#import "StoreEntity.h"
#import "HistoryListCustomCell.h"
#import "VMStoreMenuViewController.h"

@interface HistoryListViewController ()

@end

@implementation HistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = SYSLanguage?@"History":@"查看历史" ;
    self.HistoryListTableView.delegate = self ;
    self.HistoryListTableView.dataSource = self ;
    
    NSString *sql = [NSString stringWithFormat:@"Select * From  IST_WORK_MAIN \
        where check_in_time >= date('now','localtime','-2 day') \
        and OPERATE_USER = '%@'",[CacheManagement instance].currentUser.UserId];
    
    FMResultSet *rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    
    NSMutableArray *DataArray = [[NSMutableArray alloc] init];
    while ([rs next]) {
        
        IST_WORK_MAIN *work_main = [[IST_WORK_MAIN alloc] initWithFMResultSet:rs] ;
        [DataArray addObject:work_main];
    }
    [rs close] ;
    self.ListArray = [NSArray arrayWithArray:DataArray];
    [self.HistoryListTableView reloadData];
    self.HistoryListTableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.ListArray count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 77 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"cell" ;
    HistoryListCustomCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *NibArray = [[NSBundle mainBundle] loadNibNamed:@"HistoryListCustomCell" owner:self options:nil];
        for (UIView *view in NibArray) {
            
            if ([view isKindOfClass:[HistoryListCustomCell class]]) {
                
                cell = (HistoryListCustomCell *)view ;
                break ;
            }
        }
    }
    
    IST_WORK_MAIN *work_main = [self.ListArray objectAtIndex:indexPath.row];
    cell.CheckinTimeLabel.text = work_main.CHECK_IN_TIME ;
    cell.StoreNameLabel.text = [NSString stringWithFormat:@"%@ %@",work_main.STORE_CODE,work_main.STORE_NAME];
    cell.StoreAddressLabel.text = [NSString stringWithFormat:@"%@",work_main.STORE_ADDRESS];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    
    return cell ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IST_WORK_MAIN *work_main = [self.ListArray objectAtIndex:indexPath.row];
    StoreEntity *store = [[StoreEntity alloc] init];
    
    store.StoreAddress = work_main.STORE_ADDRESS ;
    store.StoreCode = work_main.STORE_CODE ;
    store.StoreName = work_main.STORE_NAME ;
    store.StorePhone = work_main.STORE_TEL ;
    store.StoreRemark = work_main.REMARK ;
    
    [CacheManagement instance].currentStore = store;
    [CacheManagement instance].currentWorkMainID = work_main.WORK_MAIN_ID ;
    
    
    NSString *pathStore = [NSString stringWithFormat:@"%@/storetypeforkid.plist",[Utilities SysDocumentPath]] ;
    NSDictionary *storeType = [NSDictionary dictionaryWithContentsOfFile:pathStore];
    if (!storeType) storeType = [NSDictionary dictionary];
    
    [CacheManagement instance].dataSource = [storeType valueForKey:store.StoreCode] ? [storeType valueForKey:store.StoreCode] : @"" ;
    [CacheManagement instance].showScoreCard = [storeType valueForKey:[NSString stringWithFormat:@"%@_ScoreCard",store.StoreCode]] ? [storeType valueForKey:[NSString stringWithFormat:@"%@_ScoreCard",store.StoreCode]] : @"" ;
    
    VMStoreMenuViewController* storemvc = [[VMStoreMenuViewController alloc]initWithNibName:@"VMStoreMenuViewController" bundle:nil];
    storemvc.ShowLeftButton = YES ;
    FromHistory = 1 ;
    [self.navigationController pushViewController:storemvc animated:YES];
}



- (void)viewDidUnload {
    [self setHistoryListTableView:nil];
    [super viewDidUnload];
}




@end






















