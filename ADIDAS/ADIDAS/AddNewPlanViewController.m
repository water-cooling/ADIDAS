//
//  AddNewPlanViewController.m
//  VM
//
//  Created by leo.you on 14-7-28.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "AddNewPlanViewController.h"
#import "AddNewPlanTableViewCell.h"
#import "CacheManagement.h"
#import "Utilities.h"
#import "StoreEntity.h"
#import "CommonDefine.h"
#import "JSON.h"
#import "NSString+filter.h"
#import "AppDelegate.h"
#import "PlanDetailViewController.h"

@interface AddNewPlanViewController ()

@end

@implementation AddNewPlanViewController

@synthesize storeListView;
@synthesize storeList=_storeList;

-(IBAction)refreshPressed:(id)sender
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    //友盟记录
//    [Utilities umengTracking:kUmAdidasGetStoreList userCode:nil];
    
    [HUD showUIBlockingIndicator];
    [_management getStoresServerByUserID];
    //    [self textFieldShouldReturn:storeCodeField];
}

-(void)RefreshView:(UIRefreshControl*)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"更新数据中..."];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString: [Utilities DateTimeNow]];
    
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        [refresh endRefreshing];
    }
    else
    {
        [HUD showUIBlockingIndicator];
        [_management getStoresServerByUserID];
    }
    //获取服务器StoreList
    
    
    
    //    //从服务器获取Store信息
    //    [_management getStoreByCodeServer:storeCodeField.text];
    //友盟记录
//    [Utilities umengTracking:kUmAdidasGetStoreList userCode:nil];
}

-(void)closekeyBoard
{
    [self.searchbar resignFirstResponder];
}

-(IBAction)SubmitEvent:(id)sender
{
    if(storeCodeField!=nil && storeCodeField.text.length >0)
    {
        //从服务器获取Store信息
        [HUD showUIBlockingIndicator];
        [_management getStoreByCodeServer:storeCodeField.text];
    }
    else
    {
        [Utilities alertMessage:NSLocalizedString(@"msgStoreCodeEmpty", nil)];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    [searchBar resignFirstResponder];
    
    [HUD showUIBlockingIndicator];
       dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* result =[_management getStoreByCodeServer_:[searchBar.text mk_urlEncodedString] ];
        NSArray* array = [result JSONValue];
        NSMutableArray* dictStores = [[NSMutableArray alloc]init];
        for (NSDictionary *dictionary  in array)
        {
            StoreEntity *entity = [[StoreEntity alloc] initWithDictionary2:dictionary];
            [dictStores addObject:entity];
        }
        [CacheManagement instance].currStoreList = dictStores;
        self.storeList = [CacheManagement instance].currStoreList;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideUIBlockingIndicator];
            [self.storeListView reloadData];
            
            //            if ([entity.CheckFlag isEqual:@"0"])
            //            {
            //                UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:[[result JSONValue] valueForKey:@"CheckError"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //                [av show];
            //            }
            //            else
            //            {
            //                [self UpdateWorkMain:[CacheManagement instance].currentStore];
            //                [self openStoreMain];
            //            }
        });
    });
}

-(void) completeGetStoreInfoServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    [HUD hideUIBlockingIndicator];
    if (error) {
        
        return;
    }
    
    //
    
    if([interface isEqualToString:kGetVisitStore])
    {
        //解析返回值
        NSArray *array = [responseString JSONValue];
        NSMutableArray *dictStores = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary  in array)
        {
            StoreEntity *entity = [[StoreEntity alloc] initWithDictionary2:dictionary];
            [dictStores addObject:entity];
        }
        [CacheManagement instance].currStoreList = dictStores;

        self.storeList = [CacheManagement instance].currStoreList;
        [self.refreshcontrol endRefreshing];
        [storeListView reloadData];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return TRUE;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField;
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//table list method

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.storeList count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddNewPlanTableViewCell* cell = (AddNewPlanTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.currentstore.StoreCode length] == 0)
    {
        return;
    }
    if (cell.added == NO)
    {
        [cell addStore:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    AddNewPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddNewPlanTableViewCell" owner:self options:nil]objectAtIndex:0];
		cell.titleLabel.backgroundColor = [UIColor clearColor];
        cell.titleLabel.tag = kTitleLabelTag;
        
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.tag = kPicLabelTag;
		cell.nameLabel.numberOfLines = 3;
        
        cell.remarkLabel.backgroundColor = [UIColor clearColor];
		cell.remarkLabel.tag = kRemarkLabelTag;
		cell.remarkLabel.numberOfLines = 1;
        cell.frame = CGRectMake(10, 0, 300, 60);
        
        cell.superviewcontroller = self;
    }
    if (SYSLanguage == CN) {
        [cell.addButton setImage:[UIImage imageNamed:@"addvisitStore.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.addButton setImage:[UIImage imageNamed:@"addvisitStore_en.png"] forState:UIControlStateNormal];
    }

    cell.addButton.userInteractionEnabled = NO;
    cell.added = NO;
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    UILabel *podTitleLabel = (UILabel *)[cell.contentView viewWithTag:kTitleLabelTag];
    UILabel *podNameLabel = (UILabel *)[cell.contentView viewWithTag:kPicLabelTag];
    UILabel *podRemarkLabel = (UILabel *)[cell.contentView viewWithTag:kRemarkLabelTag];
    
    StoreEntity *ent =  [self.storeList objectAtIndex:indexPath.row];
  	if([ent.CheckFlag isEqual:@"0"])
    {
        podNameLabel.text = ent.CheckError;
        podRemarkLabel.hidden = YES;
        podTitleLabel.hidden = YES;
    }
    else
    {
        podRemarkLabel.hidden = NO;
        podTitleLabel.hidden = NO;
        
        podTitleLabel.text = ent.StoreCode;
        podNameLabel.text = ent.StoreName;
        podRemarkLabel.text = ent.StoreAddress;
        cell.currentstore = ent;
    }
    for (StoreEntity* obj in self.superViewController.storelist)
    {
        if ([cell.currentstore.StoreCode isEqualToString:obj.StoreCode])
        {
            if (SYSLanguage == CN) {
                 [cell.addButton setImage:[UIImage imageNamed:@"exist.png"] forState:UIControlStateNormal];
            }
            else
            {
                 [cell.addButton setImage:[UIImage imageNamed:@"exist_en.png"] forState:UIControlStateNormal];
            }
           
            
            cell.addButton.userInteractionEnabled = NO;
            cell.added = YES;
        }
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = SYSLanguage?@"Store List": @"店铺列表";
    if (SYSLanguage == EN) {
        self.searchbar.placeholder = @"Search Store";
    }
//    self.existStoreList = [[NSMutableArray alloc]init];
    self.refreshcontrol = [[UIRefreshControl alloc]init];
    //    self.refreshControl.tintColor = [UIColor blueColor];
    self.refreshcontrol.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    if (SYSLanguage == EN) {
         self.refreshcontrol.attributedTitle = [[NSAttributedString alloc]initWithString:@"refresh"];
    }
    [self.refreshcontrol addTarget:self action:@selector(RefreshView:) forControlEvents:UIControlEventValueChanged];
    [self.storeListView addSubview:self.refreshcontrol];
    _management = [[StoreManagement alloc] init];
    _management.delegate = self;
    //启用等待提示框
    if (![APPDelegate checkNetWork])
    {
        if (SYSLanguage == CN)
        {
            ALERTVIEW(NO_NETWORK);
        }
        else if (SYSLanguage == EN)
        {
            ALERTVIEW(@"No Network");
        }
    }
    else
    {
        [HUD showUIBlockingIndicator];
        [_management getStoresServerByUserID];
    }
    //获取服务器StoreList
    
    //友盟记录
//    [Utilities umengTracking:kUmAdidasGetStoreList userCode:nil];
    //    [self.view bringSubviewToFront:inputView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closekeyBoard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    self.storeListView.delaysContentTouches = YES;
    self.storeListView.canCancelContentTouches = YES;
//    self.storeListView.separatorStyle = UITableViewCellSeparatorStyleNone;


    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
