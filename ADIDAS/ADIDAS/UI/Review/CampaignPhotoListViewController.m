//
//  CampaignPhotoListViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/7/11.
//

#import "CampaignPhotoListViewController.h"
#import "CampaignListCustomCell.h"
#import "Utilities.h"
#import "CommonUtil.h"
#import "AppDelegate.h"
#import "CommonDefine.h"
#import "UIImageView+YYWebImage.h"
#import "ReviewDetailImageViewController.h"
#import "HttpAPIClient.h"
#import "JSON.h"

@interface CampaignPhotoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CampaignPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    self.view.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44) ];
    label.text = [self.dataDic valueForKey:@"POPName"];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = SYS_YELLOW;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.loadingIndicator stopAnimating];
    self.dataSource = [self.dataDic valueForKey:@"listPhoto"] ;
    self.photoTableView.delegate = self ;
    self.photoTableView.dataSource = self ;
    self.photoTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    self.sampleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WID - 45, 5, 35, 35)];
    [self.sampleImageView yy_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[self.dataDic valueForKey:@"POPPictureUrl"]] stringByReplacingOccurrencesOfString:@"~" withString:@""]] placeholder:[UIImage imageNamed:@"defaultadidas.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
    
    if ([[NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"POPApprove"]] isEqualToString:@"1"]) {
        CGRect aframe = self.statusImageView.frame ;
        aframe.origin.x = DEVICE_WID - 89 - 39 - 50 ;
        aframe.origin.y = 35;
        self.statusImageView.frame = aframe ;
        [self.photoTableView addSubview:self.statusImageView] ;
    } else {
        self.statusImageView.hidden = YES ;
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Approve":@"通过" style:UIBarButtonItemStylePlain target:self action:@selector(Approve)];
        self.navigationItem.rightBarButtonItem = right ;
    }
}

- (void) Approve {

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:SYSLanguage?@"Is it approved?":@"是否通过审批?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel":@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Submit":@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dic = @{@"CampaignInstallId":self.CampaignInstallId,
                              @"UserAccount":[CacheManagement instance].currentDBUser.userName,
                              @"POPId":[self.dataDic valueForKey:@"POPId"]};
        [self.loadingIndicator startAnimating];
        [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@Action=CampaignDetailApprove",kWebDataString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.loadingIndicator stopAnimating];
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (![responseStr JSONValue]) {
                NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                responseObject = [aesString JSONValue] ;
            }else {
                responseObject = [responseStr JSONValue] ;
            }
            if (responseObject&&[responseObject isKindOfClass:[NSDictionary class]]&&[[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Code"]] isEqualToString:@"200"]) {
                
                [Utilities alertMessage:SYSLanguage?@"Approved Successfully!":@"审批成功!"];
                [self.delegate refreshListData];
                [self back];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.loadingIndicator stopAnimating];
        }];
    }];
    [ac addAction:ac1];
    [ac addAction:ac2];
    [self presentViewController:ac animated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) return 5 ;
    return [self.dataSource count] ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return  @"物料信息" ;
    }
    
    return @"物料照片列表" ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *cellIdentifier = @"cell1" ;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"活动名称:" ;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.campaignName];
        }
        
        if (indexPath.row == 1) {
            
            cell.textLabel.text = @"物料编号:" ;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"POPCode"]];
        }
        
        if (indexPath.row == 2) {
            
            cell.textLabel.text = @"最大照片数:" ;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"POPMaxCount"]];
        }
        
        if (indexPath.row == 3) {
            
            cell.textLabel.text = @"最小照片数:" ;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"POPMinCount"]];
        }
        
        if (indexPath.row == 4) {
            
            cell.textLabel.text = @"样例照片:" ;
            cell.detailTextLabel.text = @"";
            [cell.contentView addSubview:self.sampleImageView] ;
        }
        return cell ;
    }
    
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
        cell.leftButton.hidden = YES ;
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        cell.leftImageUrl = [NSString stringWithFormat:@"%@",[dic valueForKey:@"PhotoPath"]];
        [cell.leftImageView yy_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[dic valueForKey:@"PhotoPath"]] stringByReplacingOccurrencesOfString:@"~" withString:@""]] placeholder:[UIImage imageNamed:@"defaultadidas.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
        
        NSString *comment = [NSString stringWithFormat:@"%@",[dic valueForKey:@"PhotoComment"]];
        if([comment isEqualToString:@""]||[[comment lowercaseString] containsString:@"null"]) comment = @"(未添加)" ;
        cell.photoLabel.text = [NSString stringWithFormat:@"备注：%@",comment];
        
        cell.photoLabel.hidden = NO ;
        cell.statusImageView.hidden = YES ;
        cell.detailLabel.hidden = YES ;
        cell.codeLabel.hidden = YES ;
        cell.commentLabel.hidden = YES ;
        
    } @catch (NSException *exception) {
    }
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==0 && indexPath.row == 4) {
        NSString *type = [NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"POPPictureUrl"]] ;
        if (type&&![type isEqualToString:@""]) {
            ReviewDetailImageViewController *rdivc = [[ReviewDetailImageViewController alloc] initWithNibName:@"ReviewDetailImageViewController" bundle:nil];
            rdivc.imageUrl = type ;
            rdivc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:rdivc animated:NO completion:nil];
        }
    }
    if (indexPath.section == 1) {
        
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        NSString *type = [NSString stringWithFormat:@"%@",[dic valueForKey:@"PhotoPath"]];
        if (type&&![type isEqualToString:@""]) {
            ReviewDetailImageViewController *rdivc = [[ReviewDetailImageViewController alloc] initWithNibName:@"ReviewDetailImageViewController" bundle:nil];
            rdivc.imageUrl = type ;
            rdivc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:rdivc animated:NO completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) return 45 ;
    return 80 ;
}

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_photoTableView release];
    [_statusImageView release];
    [_loadingIndicator release];
    [super dealloc];
}
@end
