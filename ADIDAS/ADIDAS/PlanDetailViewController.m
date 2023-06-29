//
//  PlanDetailViewController.m
//  VM
//
//  Created by leo.you on 14-7-28.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "PlanDetailViewController.h"
#import "EventViewController.h"
#import "StoreListCell.h"
#import "AddNewPlanViewController.h"
#import "HandleEntity.h"
#import "CacheManagement.h"
#import "CommonDefine.h"
#import "StoreEntity.h"
#import "SBJsonWriter.h"
#import "SBJsonBase.h"
#import "NSString+SBJSON.h"
#import "Utilities.h"
#import "ASIFormDataRequest.h"
#import "PlanViewController.h"

@interface PlanDetailViewController ()

@end

@implementation PlanDetailViewController

-(void)dealloc
{
    NSLog(@"plandetaildealloc%@, storelistview %@",self.description,self.storeListView);
    self.storeListView.delegate = nil;
    self.storeListView.dataSource = nil;
    self.storeListView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.storelist = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}

-(void)uploadResult
{
    int result = [self.planentity.VisitDate compare:[Utilities DateNow]];
    if (result < 0)
    {
        if (SYSLanguage == CN) {
            [Utilities alertMessage:@"对不起,不能修改之前的巡店计划信息"];

        }
        else if (SYSLanguage == EN)
        {
            [Utilities alertMessage:@"Can not modify the expired store visit plan"];
        }
        return;
    }
    
//    [HUD showUIBlockingIndicator];
//    [Utilities showWaiting];
    self.waitView.hidden = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        [self.resultList removeAllObjects];
        for (HandleEntity* obj in self.handleList)
        {
            NSMutableDictionary*dic = [[NSMutableDictionary alloc]init];
            [dic setObject:obj.StoreCode forKey:@"StoreCode"];
            [dic setObject:obj.Id forKey:@"Id"];
            [self.resultList addObject:dic];
        }
        
        NSString* listStoreInfo = [writer stringWithObject:self.resultList];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setObject:self.planentity.VisitPlanMainId forKey:@"VisitPlanMainId"];
        [dic setObject:self.planentity.TaskName forKey:@"TaskName"];
        [dic setObject:self.planentity.VisitDate forKey:@"VisitDate"];
        [dic setObject:[CacheManagement instance].currentUser.UserId forKey:@"UserId"];
//        if ([self.resultList count] == 0)
//        {
//            [dic setObject:@"[]" forKey:@"listStoreInfo"];
//        }
//        else
        {
            [dic setObject:listStoreInfo  forKey:@"listStoreInfo"];
        }
        NSString *datajson = [writer stringWithObject:dic];
        
        // 去除转移字符串 以及 多余的'"'
        NSMutableString *jsonString = [NSMutableString stringWithString:datajson];
        NSString *character = nil;
        for (int i = 0; i < jsonString.length; i ++)
        {
            character = [jsonString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"]"])
                [jsonString deleteCharactersInRange:NSMakeRange(i+1, 1)];
            if ([character isEqualToString:@"\\"])
                [jsonString deleteCharactersInRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"["])
                [jsonString deleteCharactersInRange:NSMakeRange(i-1, 1)];
        }
        if (self.resultList.count == 0)
            for (int i = 0; i < jsonString.length; i ++)
            {
                character = [jsonString substringWithRange:NSMakeRange(i, 1)];
                if ([character isEqualToString:@"]"])
                    [jsonString deleteCharactersInRange:NSMakeRange(i+1, 1)];
            }

        NSString* urlString = [NSString stringWithFormat:kUpdateVisitPlan,kWebDataString,[CacheManagement instance].currentUser.UserId];
        ASIFormDataRequest* _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
        [_request setValidatesSecureCertificate:NO];
        [_request setRequestMethod:@"GET"];
        [_request addRequestHeader:@"Accept" value:@"application/json"];
        [_request addRequestHeader:@"Content-Type" value:@"application/json"];
        [_request setPostValue:jsonString forKey:@"dataJson"];
        //添加ISA 密文验证
        if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
            [_request addRequestHeader:@"Authorization"
                             value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
        
        [_request setTimeOutSeconds:200];
        [_request startSynchronous];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [_request error];
            [self.waitView setHidden:YES];
            
            if (!error)
            {
                Uploadstatu = 1;
                [self.superViewController RefreshView:nil];
                [self.navigationController popViewControllerAnimated:NO];
            }
        });
    });
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11)
    {
        if (buttonIndex == 1)
        {
            [self back];
        }
    }
    
    else
    {
        if (buttonIndex == 1)
        {
            [self uploadResult];
        }
    }

}

-(void)showUploadAlert
{
    if ([self.planentity.TaskName isEqualToString:SYSLanguage?@"Visit store+Report":@"巡店+报告"]||[self.planentity.TaskName isEqualToString:SYSLanguage?@"Visit store":@"巡店"]||[self.planentity.TaskName isEqualToString:SYSLanguage?@"Visit store+Training":@"巡店+培训"])
        if ([self.storelist count] == 0)
        {
            [HUD hideUIBlockingIndicator];
            [Utilities alertMessage:SYSLanguage?@"Please Add the Store":@"巡店计划信息不能提交，请添加店铺"];
            return;
        }
    
    NSString* title = @"是否确定更改?";
    NSString* cancel = @"取消";
    NSString* sure = @"确定";
    if (SYSLanguage == EN) {
        title = @"Are you sure?";
        cancel = @"Cancel";
        sure = @"OK";
    }
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:cancel otherButtonTitles:sure , nil];
    [av show];
}

-(void)back
{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)tryback
{
//    NSLog(@"%@,%@",self.originTaskName,self.planentity.TaskName);
    if ([self.originTaskName isEqualToString:self.planentity.TaskName])
    {
        self.changeAndSave = YES;
        if ([self.originStore count] != [self.storelist count])
        {
            self.changeAndSave = NO;
        }
        else
        {
            for (StoreEntity* obj1 in self.storelist)
            {
                for (StoreEntity* obj2 in self.originStore) {
                    if ([obj1.StoreCode isEqualToString:obj2.StoreCode])
                    {
                        self.changeAndSave = YES;
                        break;
                    }
                    else
                    {
                        self.changeAndSave = NO;
                        continue;
                    }
                }
            }
        }
    }
    else
    {
        self.changeAndSave = NO;
    }
    if (self.changeAndSave == NO)
    {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"" message:SYSLanguage?@"Store visit plan is modified, are you sure to return?": @"巡店计划信息已被修改，您确定返回吗?" delegate:self cancelButtonTitle: SYSLanguage?@"Cancel":@"取消" otherButtonTitles:SYSLanguage?@"Sure": @"确定", nil];
        av.tag=  11;
        [av show];
    }
    else
    {
        [self back];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    //    self.waitView .backgroundColor = [UIColor blackColor];
    //    self.waitView .alpha = 0.5;
    //    [self.view addSubview:view];
    //    [self.view bringSubviewToFront:view];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.waitView ];
    //    [[UIApplication sharedApplication].keyWindow.rootViewController.view  bringSubviewToFront:self.waitView];
    ((UILabel*)[self.waitView viewWithTag:88]).text = SYSLanguage?@"Processing,please wait …":@"请稍等,正在执行...";
    [self.waitView setHidden:YES];

    CGRect mframe = self.monthlabel.frame ;
    CGRect dframe = self.daylabel.frame ;
    
    
    if (DEWIDTH == 375) {
        
        mframe.origin.x = DEWIDTH/2.0-130 ;
        dframe.origin.x = DEWIDTH/2.0-130 ;
    }
    
    if (DEWIDTH == 414) {
        
        mframe.origin.x = DEWIDTH/2.0-135 ;
        dframe.origin.x = DEWIDTH/2.0-135 ;
    }
    
    self.monthlabel.frame = mframe ;
    self.daylabel.frame = dframe ;
    
    self.changeAndSave = YES;
    self.title = @"巡店明细";
    if (SYSLanguage == EN)
    {
        self.title = @"Item";
    }
    self.originTaskName = self.planentity.TaskName;
    self.originStore = [NSArray arrayWithArray:self.storelist];
    self.handleList = [[NSMutableArray alloc]init];
    self.resultList = [[NSMutableArray alloc]init];
    [self.storeListView setEditing:NO];
    if (SYSLanguage == CN) {
          [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"提交"];
    }
    else if (SYSLanguage == EN)
    {
        [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"Submit"];
    }
    [Utilities createLeftBarButton:self clichEvent:@selector(tryback)];
    NSArray* arr = [self.planentity.VisitDate componentsSeparatedByString:@"-"];
    self.eventlabel.text = self.planentity.TaskName;
  
    if (SYSLanguage == CN) {
        [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"提交"];
        self.monthlabel.text = [NSString stringWithFormat:@"%@月",[arr objectAtIndex:1]];
        self.daylabel.text = [NSString stringWithFormat:@"%@日",[arr lastObject]];
    }
    else if (SYSLanguage == EN)
    {
        [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"Submit"];
        self.monthlabel.font = [UIFont systemFontOfSize:12];
        self.monthlabel.text = [NSString stringWithFormat:@"M:%@",[arr objectAtIndex:1]];
        self.daylabel.font  = [UIFont systemFontOfSize:12];
        self.daylabel.text = [NSString stringWithFormat:@"D:%@",[arr lastObject]];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.eventlabel.font = [UIFont boldSystemFontOfSize:SYSLanguage?14:17];
    if([self.eventlabel.text isEqualToString:SYSLanguage?@"Visit store": @"巡店"])
    {
        self.addButton.hidden = NO;
        self.menuimage.image = [UIImage imageNamed:@"visitplanMenuBG.png"];
        if (SYSLanguage == EN) {
            self.menuimage.image = [UIImage imageNamed:@"visitplanMenuBG_en.png"];
        }
    }
    else if([self.eventlabel.text isEqualToString:SYSLanguage?@"Visit store+Report":@"巡店+报告"]||[self.eventlabel.text isEqualToString:SYSLanguage?@"Visit store+Training":@"巡店+培训"])
    {
        self.addButton.hidden = NO;
        self.menuimage.image = [UIImage imageNamed:@"visitplanMenuBG.png"];
        if (SYSLanguage == EN) {
            self.menuimage.image = [UIImage imageNamed:@"visitplanMenuBG_en.png"];
        }
    }
    else
    {
        self.addButton.hidden = YES;
        self.menuimage.image = [UIImage imageNamed:@"visitplanMenuBG2.png"];
        [self.storelist removeAllObjects];
    }
    
    [self.handleList removeAllObjects];
    for (StoreEntity* obj in self.storelist)
    {
        HandleEntity* entity = [[HandleEntity alloc]init];
        entity.VisitPlanMainId = self.planentity.VisitPlanMainId;
        entity.Id = @"0";
        entity.TaskName = self.eventlabel.text;
        entity.StoreCode = obj.StoreCode;
        entity.UserId = [CacheManagement instance].currentUser.UserId;
        [self.handleList addObject:entity];
    }
    [self.storeListView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)chooseEvent:(id)sender
{
    int result = [self.planentity.VisitDate compare:[Utilities DateNow]];
    if (result < 0)
    {
        if (SYSLanguage == CN) {
            [Utilities alertMessage:@"对不起,不能修改之前的巡店计划信息"];
            
        }
        else if (SYSLanguage == EN)
        {
            [Utilities alertMessage:@"Can not modify the expired store visit plan"];
        }
        return;
    }
    EventViewController* eventViewController = [[EventViewController alloc]initWithNibName:@"EventViewController" bundle: nil];
    eventViewController.superViewController = self;
    [self.navigationController pushViewController:eventViewController animated:YES];
}

-(IBAction)addStore:(id)sender
{
    int result = [self.planentity.VisitDate compare:[Utilities DateNow]];
    if (result < 0)
    {
        if (SYSLanguage == CN) {
            [Utilities alertMessage:@"对不起,不能修改之前的巡店计划信息"];
            
        }
        else if (SYSLanguage == EN)
        {
            [Utilities alertMessage:@"Can not modify the expired store visit plan"];
        }
        return;
    }
    AddNewPlanViewController* addnew = [[AddNewPlanViewController alloc]initWithNibName:@"AddNewPlanViewController" bundle:nil];
    addnew.superViewController = self;
    [self.navigationController pushViewController:addnew animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.storelist count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    StoreListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"StoreListCell" owner:self options:nil]objectAtIndex:0];
        [cell.contentView viewWithTag:100].hidden = YES;
    }
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@",((StoreEntity*)[self.storelist objectAtIndex:indexPath.row]).StoreCode,((StoreEntity*)[self.storelist objectAtIndex:indexPath.row]).StoreName] ;
    cell.remarkLabel.text = ((StoreEntity*)[self.storelist objectAtIndex:indexPath.row]).StoreAddress;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SYSLanguage?@"Delete": @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
    
        
        [self.storelist removeObjectAtIndex:indexPath.row];
        [self.handleList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
