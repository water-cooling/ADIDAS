//
//  ReviewDetailViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/6/13.
//

#import "ReviewDetailViewController.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "HttpAPIClient.h"
#import "CommonDefine.h"
#import "JSON.h"
#import "CommonUtil.h"
#import "CampaignListCustomCell.h"
#import "UIImageView+YYWebImage.h"
#import "ReviewDetailImageViewController.h"
#import "StoreReviewViewController.h"
#import "CampaignPhotoListViewController.h"

@interface ReviewDetailViewController ()<SubmitDelegate,RefreshDelegate>

@end

@implementation ReviewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    self.view.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44) ];
    label.text = SYSLanguage?@"Campaign List":@"物料列表";
    if ([self.selectedDic valueForKey:@"CampaignName"]&&![[self.selectedDic valueForKey:@"CampaignName"] isEqual:[NSNull null]]) {
        label.text = [self.selectedDic valueForKey:@"CampaignName"] ;
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = SYS_YELLOW;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_WID, 40)];
    locationview.image = [UIImage imageNamed:@"locationBarbg.png"];
    
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEVICE_WID-30, 40)];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor = [UIColor clearColor];
    locationlabel.tag = 111;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];
    locationlabel.text =  [NSString stringWithFormat:@"%@",[self.selectedDic valueForKey:@"StoreName"]];
    
    self.loadingIndicator.hidden = NO ;
    [self getCampaignListData] ;
    self.campaginListTableView.tableFooterView = [[UIView alloc] init];
    self.campaginListTableView.dataSource = self ;
    self.campaginListTableView.delegate = self ;
    self.campaginListTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCampaignListData {
    
    NSDictionary *dic = @{@"StoreCode":[NSString stringWithFormat:@"%@",[self.selectedDic valueForKey:@"StoreCode"]],
                          @"Campaign":[NSString stringWithFormat:@"%@",[self.selectedDic valueForKey:@"CampaignId"]],
                          @"CampaignInstallId":[NSString stringWithFormat:@"%@",[self.selectedDic valueForKey:@"CampaignInstallId"]],
                          @"UserAccount":[CacheManagement instance].currentDBUser.userName};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@Action=CampaignDetail",kWebDataString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loadingIndicator.hidden = YES ;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        if (responseObject&&[responseObject isKindOfClass:[NSArray class]]) {
            self.dataSourceArray = [NSArray arrayWithArray:responseObject];
            [self.campaginListTableView reloadData] ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loadingIndicator.hidden = YES ;
    }];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_campaginListTableView release];
    [_loadingIndicator release];
    [super dealloc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    
    CampaignListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
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
        cell.photoLabel.hidden = YES ;
        cell.delegate = self ;
        NSDictionary *dic = [self.dataSourceArray objectAtIndex:indexPath.row];
        cell.leftImageUrl = [NSString stringWithFormat:@"%@",[dic valueForKey:@"POPSmallPictureUrl"]];
        [cell.leftImageView yy_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[dic valueForKey:@"POPPictureUrl"]] stringByReplacingOccurrencesOfString:@"~" withString:@""]] placeholder:[UIImage imageNamed:@"defaultadidas.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
        
        cell.detailLabel.text = [NSString stringWithFormat:@"物料名称：%@",[dic valueForKey:@"POPName"]];
        cell.codeLabel.text = [NSString stringWithFormat:@"物料编号：%@",[dic valueForKey:@"POPCode"]];
        NSString *comment = [NSString stringWithFormat:@"%@",[dic valueForKey:@"POPComment"]];
        if([comment isEqualToString:@""]||[[comment lowercaseString] containsString:@"null"]) comment = @"(未添加)" ;
        cell.commentLabel.text = [NSString stringWithFormat:@"物料备注：%@",comment];
        cell.statusImageView.hidden = YES ;
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"POPApprove"]] isEqualToString:@"1"]) {
            cell.statusImageView.hidden = NO ;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } @catch (NSException *exception) {
    }
    
    return cell ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArray count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *comment = [NSString stringWithFormat:@"%@",[dic valueForKey:@"POPComment"]];
    if([comment isEqualToString:@""]||[[comment lowercaseString] containsString:@"null"]) comment = @"(未添加)" ;
    NSString *commentstr = [NSString stringWithFormat:@"物料备注：%@",comment];
    float height = [self getLabelHeightWithText:commentstr width:PHONE_WIDTH-97-32 font:14];
    if (height > 21) {
        return 80 + height - 21  ;
    }
    return 80 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSArray *listPhoto = [dic valueForKey:@"listPhoto"] ;
    if (listPhoto&&![listPhoto isEqual:[NSNull null]]&&[listPhoto count]>0) {
        CampaignPhotoListViewController *list = [[CampaignPhotoListViewController alloc] initWithNibName:@"CampaignPhotoListViewController" bundle:nil];
        list.dataDic = dic ;
        list.campaignName = [NSString stringWithFormat:@"%@",[self.selectedDic valueForKey:@"CampaignName"]];
        list.CampaignInstallId = [NSString stringWithFormat:@"%@",[self.selectedDic valueForKey:@"CampaignInstallId"]];
        list.delegate = self ;
        [self.navigationController pushViewController:list animated:YES];
    } else {
        [Utilities alertMessage:SYSLanguage?@"Not Exist Campaign Info!":@"物料照片未上传,无法查看"];
    }
}

- (void)submitCompaign:(NSString *)CampaignInstallDetailId {
    
    
}

- (void)refreshListData {
    [self getCampaignListData];
    [self.delegate refershList];
}

- (void)openDetailImage:(NSString *)type {
    
    if (type&&![type isEqualToString:@""]) {
        
        ReviewDetailImageViewController *rdivc = [[ReviewDetailImageViewController alloc] initWithNibName:@"ReviewDetailImageViewController" bundle:nil];
        rdivc.imageUrl = type ;
        rdivc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:rdivc animated:NO completion:nil];
    }
}

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}

@end




















