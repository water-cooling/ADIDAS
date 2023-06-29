//
//  DateListViewController.m
//  MobileApp
//
//  Created by 桂康 on 2017/11/2.
//

#import "DateListViewController.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "HttpAPIClient.h"
#import "JSON.h"
#import "CommonDefine.h"
#import "ModuleListViewController.h"
#import "SVProgressHUD.h"
#import "CommonUtil.h"

@interface DateListViewController ()
{
    NSDate *_dateSelected;
}
@end

@implementation DateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"计划" ;
    self.view.backgroundColor = [Utilities colorWithHexString:@"#f2f2f2"];
    if (SYSLanguage == EN) self.title = @"Visit Plan";
    
    self.calendarManager = [JTCalendarManager new];
    self.calendarManager.delegate = self;
    [self.calendarManager setContentView:self.CalendarView];
    [self.calendarManager setDate:[NSDate date]];
    self.calendarManager.settings.pageViewNumberOfWeeks = 5 ;
    self.calendarManager.settings.weekModeEnabled = NO ;
    [self.calendarManager reload];
    [HUD showUIBlockingIndicator];
    self.titleTimeLabel.text = [self NSDateToNSString:[NSDate date]] ;
    self.canlendarBGView.layer.cornerRadius = 4 ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
    [self getSelectedDate];
}

- (NSString *)NSDateToNSString:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *string = [formatter stringFromDate:date];
    
    return string;
}

- (IBAction)selectMonthAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender ;
    
    NSDate *currDate = self.calendarManager.date ;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *adcomps = nil;
    
    adcomps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currDate];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:0];
    [comps setDay:0];
    
    if (btn.tag == 10) {
        
        [comps setMonth:-1];
    }
    
    if (btn.tag == 20) {
        
        [comps setMonth:1];
    }
    
    NSDate *newdate = [calendar dateByAddingComponents:comps toDate:currDate options:0];
    
    [self.calendarManager setDate:newdate];
    
    self.titleTimeLabel.text = [self NSDateToNSString:newdate];
}


- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [Utilities colorWithHexString:@"#269bfc"] ;
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Other month
    else if(![_calendarManager.dateHelper date:[NSDate date] isEqualOrBefore:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Another day of the current month
    else{
        
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    dayView.dotView.hidden = YES;
    dayView.dotLeftView.hidden = YES;
    dayView.dotRightView.hidden = YES;
    
    for (NSDictionary *dic in returndDataArray) {
        
        if ([[self NSDateToDetailNSStringByLine:dayView.date] isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"WORK_DATE"]]]) {
         
            if ([[dic valueForKey:@"CHECK_TYPE"] isEqualToString:@"0"]) {
                
                dayView.dotView.backgroundColor = [UIColor redColor];
                dayView.dotView.hidden = NO;
                dayView.dotLeftView.hidden = YES;
                dayView.dotRightView.hidden = YES;
            }
            
            if ([[dic valueForKey:@"CHECK_TYPE"] isEqualToString:@"1"]) {
                
                dayView.dotView.backgroundColor = [UIColor greenColor];
                dayView.dotView.hidden = NO;
                dayView.dotLeftView.hidden = YES;
                dayView.dotRightView.hidden = YES;
            }
            
            if ([[dic valueForKey:@"CHECK_TYPE"] isEqualToString:@"01"]) {
                
                dayView.dotView.hidden = YES;
                dayView.dotLeftView.hidden = NO;
                dayView.dotRightView.hidden = NO;
            }
        }
    }
    
    self.titleTimeLabel.text = [self NSDateToNSString:self.calendarManager.date];
    
}


- (NSString *)NSDateToDetailNSStringByLine:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formatter stringFromDate:date];
    
    return string;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    self.titleTimeLabel.text = [self NSDateToNSString:self.calendarManager.date] ;
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![self.calendarManager.dateHelper date:self.CalendarView.date isTheSameMonthThan:dayView.date]){
        if([self.CalendarView.date compare:dayView.date] == NSOrderedAscending){
            [self.CalendarView loadNextPageWithAnimation];
        }
        else{
            [self.CalendarView loadPreviousPageWithAnimation];
        }
    }
    
    BOOL isExist = false ;
    
    for (NSDictionary *dic in returndDataArray) {
        
        if ([[self NSDateToDetailNSStringByLine:dayView.date] isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"WORK_DATE"]]]) {
            
            isExist = true ;
            [self getSelectedStoreList:[NSString stringWithFormat:@"%@",[dic valueForKey:@"WORK_DATE"]]];
            
            break ;
        }
    }
    
    if (!isExist) {
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack] ;
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"当前日期没有评论数据!"];
        [self performSelector:@selector(hidSvprogress) withObject:nil afterDelay:0.7];
    }
}

- (void)hidSvprogress {
    
    [SVProgressHUD dismiss];
}

- (void) getSelectedDate {
    
    NSDictionary *dic = @{@"Action":@"COMMENTDATE",@"account":[CacheManagement instance].currentDBUser.userName,@"ActionType":@"en"};
    
    HttpAPIClient *sharedClient = [[HttpAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWebMobileHeadString]];
        
    sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
    sharedClient.requestSerializer.timeoutInterval = 20;
        
    sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        
    sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    [sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
    sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [sharedClient GET:@"/DataSyncService.aspx?osType=iPhone" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HUD hideUIBlockingIndicator];
        
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if(![response JSONValue]){
            response = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]];
        }
        NSArray *dataAry = [response JSONValue];
        
        if (dataAry&&[dataAry count]>0) {
            
            NSMutableArray *tempAry = [NSMutableArray array];
            NSMutableArray *finalAry = [NSMutableArray array];
            
            for (NSDictionary *dic in dataAry) {
                
                if (![tempAry containsObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"WORK_DATE"]]]) {
                    
                    [tempAry addObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"WORK_DATE"]]] ;
                }
            }
            
            for (NSString *datestr in tempAry) {
                
                int count = 0 ;
                NSDictionary *targetDic = nil ;
                
                for (NSDictionary *dic in dataAry) {
                    
                    if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"WORK_DATE"]] isEqualToString:datestr]) {
                        
                        count += 1 ;
                        if(!targetDic) targetDic = dic ;
                    }
                }
                
                if (count == 1) {
                    
                    [finalAry addObject:targetDic] ;
                }
                else {
                    
                    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:targetDic];
                    [newDic setValue:@"01" forKey:@"CHECK_TYPE"] ;
                    [finalAry addObject:newDic];
                }
            }
            
            [[[[CacheManagement instance]leveyTabbarController].tabBar viewWithTag:8888] setHidden:NO];
            returndDataArray = [NSArray arrayWithArray:finalAry];
            [self.calendarManager reload];
        }
        else [[[[CacheManagement instance]leveyTabbarController].tabBar viewWithTag:8888] setHidden:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HUD hideUIBlockingIndicator];
        [[[[CacheManagement instance]leveyTabbarController].tabBar viewWithTag:8888] setHidden:YES];
    }];
}


- (void) getSelectedStoreList:(NSString *)seledate {
    
    [HUD showUIBlockingIndicator];
    
    NSDictionary *dic = @{@"Action":@"COMMENTSTORE",@"account":[CacheManagement instance].currentDBUser.userName,@"workdate":seledate,@"ActionType":@"en"};
    
    HttpAPIClient *sharedClient = [[HttpAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWebMobileHeadString]];
    
    sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    sharedClient.requestSerializer.timeoutInterval = 20;
    
    sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
    
    sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [sharedClient GET:@"/DataSyncService.aspx?osType=iPhone" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HUD hideUIBlockingIndicator];
        
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if(![response JSONValue]){
            response = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]];
        }
        NSArray *dataAry = [response JSONValue];
       
        if ([dataAry count] == 1) {
            
            [CacheManagement instance].dataSource = [NSString stringWithFormat:@"%@",[[dataAry firstObject] valueForKey:@"IS_KIDS"]];
            ModuleListViewController *controller = [[ModuleListViewController alloc] initWithNibName:@"ModuleListViewController" bundle:nil];
            controller.selectedDate = seledate ;
            controller.storename = [NSString stringWithFormat:@"%@",[[dataAry firstObject] valueForKey:@"STORE_NAME"]] ;
            controller.workmainid = [NSString stringWithFormat:@"%@",[[dataAry firstObject] valueForKey:@"WORK_MAIN_ID"]] ;
            controller.type = [[NSString stringWithFormat:@"%@",[[dataAry firstObject] valueForKey:@"CHECK_TYPE"]] isEqualToString:@"1"] ? @"M":@"D";
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationItem setBackBarButtonItem:item];
            [self.leveyTabBarController hidesTabBar:YES animated:YES];
            [self.navigationController pushViewController:controller animated:YES] ;
            
            return  ;
        }
        else if([dataAry count] > 1) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择店铺" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            for (NSDictionary *dic in dataAry) {
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@-%@",[dic valueForKey:@"STORE_NAME"],[[dic valueForKey:@"CHECK_TYPE"] isEqualToString:@"1"]?(SYSLanguage?@"Monthly Report":@"月度报告"):(SYSLanguage?@"Daily Visit":@"日常巡店")] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [CacheManagement instance].dataSource = [NSString stringWithFormat:@"%@",[dic valueForKey:@"IS_KIDS"]];
                    ModuleListViewController *controller = [[ModuleListViewController alloc] initWithNibName:@"ModuleListViewController" bundle:nil];
                    controller.selectedDate = seledate ;
                    controller.storename = [NSString stringWithFormat:@"%@",[dic valueForKey:@"STORE_NAME"]] ;
                    controller.workmainid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"WORK_MAIN_ID"]] ;
                    controller.type = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"CHECK_TYPE"]] isEqualToString:@"1"] ? @"M":@"D";
                    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:item];
                    [self.leveyTabBarController hidesTabBar:YES animated:YES];
                    [self.navigationController pushViewController:controller animated:YES] ;
                }];
                
                [alert addAction:ok];
            }
            
            UIAlertAction *ok3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            
            [alert addAction:ok3];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack] ;
            [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"当前日期没有评论数据!"];
            [self performSelector:@selector(hidSvprogress) withObject:nil afterDelay:0.7];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HUD hideUIBlockingIndicator];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(showMsg) withObject:nil afterDelay:0.8];
}

-(void)showMsg
{
    if (Uploadstatu == 1)
    {
        {
            if ([CacheManagement instance].uploaddata == NO)
            {
                [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Instant upload closed,please upload in system": @"即时上传功能已关闭，请到系统中手工上传数据" withTimeout:2] ;
            }
            else
            {
                [HUD showUIBlockingSuccessIndicatorWithText:SYSLanguage?@"Submit successfully": @"上传成功" withTimeout:2];
            }
            
        }
    }
    Uploadstatu = 0;
}


@end




