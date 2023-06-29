//
//  StoreReviewViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/6/11.
//

#import "StoreReviewViewController.h"
#import "CampgainStoreCustomCell.h"
#import "HttpAPIClient.h"
#import "JSON.h"
#import "CommonDefine.h"
#import "CommonUtil.h"
#import "ReviewFilterViewController.h"
#import "ReviewDetailViewController.h"



@interface StoreReviewViewController ()<ReviewFilterDelegate,RefreshStoreDelegate>

@end

@implementation StoreReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adidas.png"]]autorelease] ;
    self.navigationItem.title = @"首页";
    
    self.firCondition = @"" ;
    self.secCondition = @"" ;
    self.thiCondition = @"" ;
    self.fourCondition = @"" ;
    
    self.storeTableView.delegate = self ;
    self.storeTableView.dataSource = self ;
    self.storeTableView.tableFooterView = [[UIView alloc] init];
    self.loadingIndicator.hidden = NO ;
    [self getFilterInfo];
    [self getStoreListData];
    
    self.refreshcontrol = [[UIRefreshControl alloc]init];
    self.refreshcontrol.attributedTitle = [[[NSAttributedString alloc]initWithString:SYSLanguage?@"refresh":@"下拉刷新"]autorelease];
    [self.refreshcontrol addTarget:self action:@selector(RefreshView:) forControlEvents:UIControlEventValueChanged];
    [self.storeTableView addSubview:self.refreshcontrol];
    [self.storeTableView sendSubviewToBack:self.refreshcontrol];
    
    [self.monthBtn setImageEdgeInsets:UIEdgeInsetsMake(2, PHONE_WIDTH/4.0-15+(PHONE_WIDTH==320?2:0), 0, 0)];
    [self.monthBtn setImage:[UIImage imageNamed:@"filterbutton.png"] forState:UIControlStateNormal];
    
    [self.campaignBtn setImageEdgeInsets:UIEdgeInsetsMake(2, PHONE_WIDTH/4.0-5+(PHONE_WIDTH==320?5:0), 0, -5-(PHONE_WIDTH==320?5:0))];
    [self.campaignBtn setImage:[UIImage imageNamed:@"filterbutton.png"] forState:UIControlStateNormal];
    
    [self.formatBtn setImageEdgeInsets:UIEdgeInsetsMake(2, PHONE_WIDTH/4.0-15+(PHONE_WIDTH==320?5:0), 0, 0)];
    [self.formatBtn setImage:[UIImage imageNamed:@"filterbutton.png"] forState:UIControlStateNormal];
    
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(2, PHONE_WIDTH/4.0-20+(PHONE_WIDTH==320?2:0), 0, 0)];
    [self.moreBtn setImage:[UIImage imageNamed:@"filterbutton.png"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
}

-(void)RefreshView:(UIRefreshControl*)refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"更新数据中..."];
    
    self.firCondition = @"" ;
    self.secCondition = @"" ;
    self.thiCondition = @"" ;
    self.fourCondition = @"" ;
    
    [self getFilterInfo];
    [self getStoreListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    
    CampgainStoreCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"CampgainStoreCustomCell" owner:self options:nil];
        
        for (UIView *view in nibAry) {
            
            if ([view isKindOfClass:[CampgainStoreCustomCell class]]) {
                cell = (CampgainStoreCustomCell *)view ;
                break ;
            }
        }
    }
    
    @try {
        NSDictionary *dic = [self.dataListArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[dic valueForKey:@"StoreCode"],[dic valueForKey:@"StoreName"],[dic valueForKey:@"StoreFormat"]];
        cell.subTitleLabel.text = [NSString stringWithFormat:@"物料总数/已上传物料：%@",[dic valueForKey:@"CampaignInfo"]];
        
        @try {
            NSString *oldString = [NSString stringWithFormat:@"物料总数/已上传物料：%@",[dic valueForKey:@"CampaignInfo"]];
            NSString *normalString = [NSString stringWithFormat:@"物料总数/已上传物料：%@/",[[[dic valueForKey:@"CampaignInfo"] componentsSeparatedByString:@"/"] firstObject]];
            NSMutableAttributedString *statusLabel = [[NSMutableAttributedString alloc] initWithString:oldString];
            NSRange r1 = NSMakeRange([normalString length], [oldString length]- [normalString length]) ;
            [statusLabel addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:r1];
            [statusLabel addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:r1];
            cell.subTitleLabel.attributedText = statusLabel ;
        } @catch (NSException *exception) {
        }
        
        cell.rightStatusImageView.hidden = YES ;
        cell.finishStatusImageView.hidden = YES ;
        
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"CampaignStatus"]] isEqualToString:@"3"]) {
            cell.finishStatusImageView.hidden = NO ;
            cell.rightStatusImageView.hidden = NO ;
            cell.rightStatusImageView.image = [UIImage imageNamed:@"reviewedall.png"];
        }
        
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"CampaignStatus"]] isEqualToString:@"2"]) {
            cell.rightStatusImageView.hidden = NO ;
            cell.rightStatusImageView.image = [UIImage imageNamed:@"reviewed.png"];
        }
        
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"CampaignStatus"]] isEqualToString:@"1"]) {
            cell.rightStatusImageView.hidden = NO ;
            cell.rightStatusImageView.image = [UIImage imageNamed:@"unreview.png"];
        }
        
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"CampaignStatus"]] isEqualToString:@"0"]) {
            cell.rightStatusImageView.hidden = NO ;
            cell.rightStatusImageView.image = [UIImage imageNamed:@"review_unupload.png"];
        }
        
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"CampaignStatus"]] isEqualToString:@"-1"]) {
            cell.rightStatusImageView.hidden = NO ;
            cell.rightStatusImageView.image = [UIImage imageNamed:@"review_timeouted.png"];
        }
    } @catch (NSException *exception) {
    }
    
    return cell ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataListArray count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        NSDictionary *dic = [self.dataListArray objectAtIndex:indexPath.row];
        NSString *titlestr = [NSString stringWithFormat:@"%@ %@ %@",[dic valueForKey:@"StoreCode"],[dic valueForKey:@"StoreName"],[dic valueForKey:@"StoreFormat"]];
        float height = [self getLabelHeightWithText:titlestr width:PHONE_WIDTH-10 font:15];
        if (height > 24) return height+36.5;
    } @catch (NSException *exception) {
    }
    return 60 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReviewDetailViewController *vc = [[ReviewDetailViewController alloc] initWithNibName:@"ReviewDetailViewController" bundle:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    vc.selectedDic = [self.dataListArray objectAtIndex:indexPath.row] ;
    vc.delegate = self ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refershList {
    self.loadingIndicator.hidden = NO ;
    [self getStoreListData];
}

- (void)getFilterInfo {
    
    NSDictionary *dic = @{@"UserAccount":[CacheManagement instance].currentDBUser.userName};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@Action=CampaignMaster",kWebDataString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        if (responseObject&&[responseObject isKindOfClass:[NSArray class]]) {
            self.filterArray = [NSArray arrayWithArray:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}

- (void)getStoreListData {
    
    NSDictionary *dic = @{@"Month":self.firCondition,@"Campaign":self.secCondition,@"StoreFormat":self.thiCondition,@"keyWord":self.fourCondition,@"UserAccount":[CacheManagement instance].currentDBUser.userName};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@Action=CampaignInfo",kWebDataString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loadingIndicator.hidden = YES ;
        [self.refreshcontrol endRefreshing];
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        if (responseObject&&[responseObject isKindOfClass:[NSArray class]]) {
            self.dataListArray = [NSArray arrayWithArray:responseObject];
            [self.storeTableView reloadData] ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loadingIndicator.hidden = YES ;
        [self.refreshcontrol endRefreshing];
    }];
}

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}


- (void)dealloc {
    [_monthBtn release];
    [_campaignBtn release];
    [_formatBtn release];
    [_moreBtn release];
    [_loadingIndicator release];
    [super dealloc];
}

- (IBAction)filterAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender ;
    [self changeFilterWithTag:(int)btn.tag];
    ReviewFilterViewController *rfvc = [[ReviewFilterViewController alloc] initWithNibName:@"ReviewFilterViewController" bundle:nil];
    rfvc.pageTye = (int)btn.tag;
    rfvc.delegate = self;
    rfvc.originFilterData = self.filterArray;
    rfvc.firCondition = self.firCondition;
    rfvc.secCondition = self.secCondition;
    rfvc.thiCondition = self.thiCondition;
    rfvc.fourCondition = self.fourCondition;
    rfvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[CacheManagement instance].leveyTabbarController presentViewController:rfvc animated:NO completion:nil];
}


- (void)changeFilterWithTag:(int)tag {
    
    if (tag == 10) {
        
        [self.monthBtn setTitleColor:[CommonUtil colorWithHexString:@"#1881f6"] forState:UIControlStateNormal] ;
        [self.campaignBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.formatBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    if (tag == 20) {
        
        [self.campaignBtn setTitleColor:[CommonUtil colorWithHexString:@"#1881f6"] forState:UIControlStateNormal] ;
        [self.monthBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.formatBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    if (tag == 30) {
        
        [self.formatBtn setTitleColor:[CommonUtil colorWithHexString:@"#1881f6"] forState:UIControlStateNormal] ;
        [self.campaignBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.monthBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    if (tag == 40) {
        
        [self.moreBtn setTitleColor:[CommonUtil colorWithHexString:@"#1881f6"] forState:UIControlStateNormal] ;
        [self.campaignBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.formatBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.monthBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}

- (void)confirmFilterAction:(NSString *)fir :(NSString *)sec :(NSString *)thi :(NSString *)fou pageType:(int)tpe {
    
    self.firCondition = fir ;
    self.secCondition = sec ;
    self.thiCondition = thi ;
    self.fourCondition = fou ;
    self.loadingIndicator.hidden = NO ;
    [self getStoreListData];
}

- (void)removeColor {
    
    [self.monthBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal] ;
    [self.campaignBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.formatBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

@end











