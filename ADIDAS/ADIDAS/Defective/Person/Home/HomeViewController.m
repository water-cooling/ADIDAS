//
//  HomeViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "HomeViewController.h"
#import "GoodDetailCustomCell.h"
#import "NewAddProductViewController.h"
#import "EcAddProductViewController.h"
#import "AlertedViewController.h"
#import "ExpressInfoViewController.h"
#import "UIImageView+YYWebImage.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "SGQRCode.h"
#import "SPPageMenu.h"
#import "HomeOrderModel.h"
#import "ApplyDetailViewController.h"
#import "JSBadgeView.h"
@interface HomeViewController ()<SPPageMenuDelegate>
@property (nonatomic,strong) SPPageMenu* pageMuenu;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页" ;
    [self initTableView];
    self.searchBGView.layer.borderWidth = 1 ;
    self.searchBGView.layer.cornerRadius = 3 ;
    self.searchBGView.layer.borderColor = [[CommonUtil colorWithHexString:@"#e4e5e6"] CGColor] ;
    self.searchBGView.layer.masksToBounds = YES ;
    self.searchTextField.backgroundColor = [CommonUtil colorWithHexString:@"#f1f2f3"] ;
    filterType = 0;
    NSArray * dataArr = @[@"全部",@"已提交",@"处理中",@"已回复",@"已驳回"];
    // 传递数组，默认选中第2个
    [self.pageMuenu setItems:dataArr selectedItemIndex:0];
    self.searchTextField.delegate = self ;
    [self.PageMenusView addSubview:self.pageMuenu];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.searchTextField.leftView = paddingView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.listScrollView.contentSize = CGSizeMake(PHONE_WIDTH*7, 1) ;
    self.listScrollView.delegate = self ;
}

- (void)viewWillAppear:(BOOL)animated {
    [CacheManagement instance].toHomeFlag = NO;
    [self getData];
}

- (void)getData {
    [self.searchTextField resignFirstResponder] ;
    [self.listScrollView setContentOffset:CGPointMake(0, 0)];
    [self ShowSVProgressHUD];
    NSDictionary *dic = @{@"Filter":self.searchTextField.text,@"FilterType":@"",@"Token":[self GetLoginUser].Token};

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetCaseHeader",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        
        [self DismissSVProgressHUD];
     
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            NSDictionary * dict =  [[responseObject valueForKey:@"Msg"]JSONValue];
            if (dict) {
                firstArray = [dict valueForKey:@"0"];
                secondArray = [dict valueForKey:@"1"];
                thirdArray = [dict valueForKey:@"2"];
                fourthArray = [dict valueForKey:@"3"];
                fifthArray= [dict valueForKey:@"4"];

            }
                if (filterType == 0) {
                    [self.firTableView reloadData] ;
                }else if (filterType == 1) {
                    [self.secTableView reloadData] ;
                }else if(filterType == 2) {
                    [self.thiTableView reloadData] ;
                }else if (filterType == 3){
                    [self.fouTableView reloadData] ;
                }else{
                    [self.fifTableView reloadData] ;
                }
            [self.listScrollView setContentOffset: CGPointMake(PHONE_WIDTH*filterType, 0)];
        }else {
            
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];
            
            if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
            
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                [ud synchronize];
                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
            }
        }
        [self getNumberData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:error.localizedDescription];
        
    }];
}

- (void)getNumberData {
    [self.searchTextField resignFirstResponder] ;
    [self ShowSVProgressHUD];
    NSDictionary *dic = @{@"Token":[self GetLoginUser].Token};

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetCaseRemind",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        [self DismissSVProgressHUD];
        
     
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            NSDictionary * dict = [responseObject[@"Msg"]JSONValue];
        NSArray *buttons = [self.pageMuenu valueForKey:@"_buttons"];
            for (int i =0 ; i<buttons.count; i++) {
                UIButton * button = buttons[i];
                JSBadgeView *badgeView0 = [[JSBadgeView alloc] initWithParentView:button.titleLabel alignment:JSBadgeViewAlignmentTopRight];
                if (dict[[NSString stringWithFormat:@"%d",i]]) {
                    badgeView0.badgePositionAdjustment = CGPointMake(10, 0);
                    badgeView0.badgeBackgroundColor = [UIColor redColor];
                    badgeView0.badgeOverlayColor = [UIColor clearColor];
                    badgeView0.badgeStrokeColor = [UIColor redColor];
                    badgeView0.badgeText = [NSString stringWithFormat:@"%@",dict[[NSString stringWithFormat:@"%d",i]]];
                }else{
                    badgeView0.badgePositionAdjustment = CGPointMake(10, 0);
                    badgeView0.badgeBackgroundColor = [UIColor whiteColor];
                    badgeView0.badgeOverlayColor = [UIColor clearColor];
                    badgeView0.badgeStrokeColor = [UIColor whiteColor];
                    badgeView0.badgeText = @"";
                    
                }
            }
    
        }else {
            if ([responseObject valueForKey:@"Msg"]) {
                [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];

            }
            
            if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 700) {
            
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:kDEFECTIVETOKEN] ;
                [ud synchronize];
                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self DismissSVProgressHUD];
        
        [self showAlertWithDispear:@"请求错误"];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
    if (tableView == self.firTableView) return [firstArray count] ;
    
    if (tableView == self.secTableView) return [secondArray count] ;
    
    if (tableView == self.thiTableView) return [thirdArray count] ;
    
    if (tableView == self.fouTableView) return [fourthArray count] ;
    
    if (tableView == self.fifTableView) return [fifthArray count] ;

    
    return 0 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 146 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodDetailCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailCustomCell"forIndexPath:indexPath] ;
    
    cell.backBtn.hidden = YES ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    NSDictionary *dic = nil ;
    
    if (tableView == self.firTableView) {
    
        dic = [firstArray objectAtIndex:indexPath.section];
    }
    
    if (tableView == self.secTableView) {
    
        dic = [secondArray objectAtIndex:indexPath.section];
    }
    
    if (tableView == self.thiTableView) {
    
        dic = [thirdArray objectAtIndex:indexPath.section];
    }
    
    if (tableView == self.fouTableView) {
    
        dic = [fourthArray objectAtIndex:indexPath.section];
    }
    
    if (tableView == self.fifTableView) {
    
        dic = [fifthArray objectAtIndex:indexPath.section];
    }
    
       
    if (dic&&![dic isEqual:[NSNull null]]) {
        
            cell.kindLabel.text = [NSString stringWithFormat:@"种类：%@",[dic valueForKey:@"CaseCategory"]];
            cell.submitLabel.text = [NSString stringWithFormat:@"提交时间：%@",[dic valueForKey:@"CaseDate"]];
            cell.orderLabel.text = [NSString stringWithFormat:@"单号：%@",[dic valueForKey:@"CaseNumber"]];
            cell.goodLabel.text = [NSString stringWithFormat:@"货号：%@",[dic valueForKey:@"ArticleList"]];
        
        if ([dic valueForKey:@"PictureUrl"]&&![[dic valueForKey:@"PictureUrl"] isEqual:[NSNull null]]&&![[dic valueForKey:@"PictureUrl"] isEqualToString:@""]) {
            
            [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[dic valueForKey:@"PictureUrl"] substringFromIndex:1]]] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}] ;
        }
        
        
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"IsNew"]] isEqualToString:@"1"]) {
            
            cell.kindLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.submitLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.orderLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.goodLabel.font =[UIFont boldSystemFontOfSize:14];
        }
        else {
            cell.kindLabel.font = [UIFont systemFontOfSize:14];
            cell.submitLabel.font = [UIFont systemFontOfSize:14];
            cell.orderLabel.font = [UIFont systemFontOfSize:14];
            cell.goodLabel.font =[UIFont systemFontOfSize:14];
            
        }
    } else {
        cell.kindLabel.font = [UIFont systemFontOfSize:14];
        cell.submitLabel.font = [UIFont systemFontOfSize:14];
        cell.orderLabel.font = [UIFont systemFontOfSize:14];
        cell.goodLabel.font =[UIFont systemFontOfSize:14];
    }
    
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NSDictionary *dic = nil ;
    
    if (tableView == self.firTableView) {
        
        dic = [firstArray objectAtIndex:indexPath.section];
    }
    
    if (tableView == self.secTableView) {
        
        dic = [secondArray objectAtIndex:indexPath.section];
    }
    
    if (tableView == self.thiTableView) {
        
        dic = [thirdArray objectAtIndex:indexPath.section];
    }
    
    if (tableView == self.fouTableView) {
        
        dic = [fourthArray objectAtIndex:indexPath.section];
    }
    
    if (tableView == self.fifTableView) {
        dic = [fifthArray objectAtIndex:indexPath.section];
    }
    if (dic) {
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"IsNew"]] isEqualToString:@"1"]) {
            [self updateRead:dic[@"CaseNumber"]];
        }else{
            ApplyDetailViewController * detailVc = [ApplyDetailViewController new];
            detailVc.hidesBottomBarWhenPushed = YES;
            detailVc.CaseNumber = dic[@"CaseNumber"];
            [self.navigationController pushViewController:detailVc animated:YES];
            
        }

    }
}

-(void)updateRead:(NSString *)orderId{
    [self ShowSVProgressHUD];
    NSDictionary *dic = @{@"CaseNumber":orderId,@"Token":[self GetLoginUser].Token};

    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@ReadCase",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:nil]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        
        [self DismissSVProgressHUD];
        
        
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            ApplyDetailViewController * detailVc = [ApplyDetailViewController new];
            detailVc.hidesBottomBarWhenPushed = YES;
            detailVc.CaseNumber = orderId;
            [self.navigationController pushViewController:detailVc animated:YES];
            
        }else{
            [self showAlertWithDispear:[responseObject valueForKey:@"Msg"]];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self DismissSVProgressHUD];
        [self showAlertWithDispear:error.localizedDescription];

    }];
}

// 完成申请单操作后刷新列表数据
- (void)refreshList {
    [self getData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    [self searchAction:nil];
    return NO ;
}

- (IBAction)searchAction:(id)sender {
    
    [self.searchTextField resignFirstResponder] ;
    [self getData] ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (scrollView == self.listScrollView) {
        int location = scrollView.contentOffset.x/PHONE_WIDTH ;
        filterType = location;
        [self.pageMuenu setSelectedItemIndex:location];
        NSString *newfilter = @"" ;
        if (firstArray == nil) {
            [self getData];
        }else{
            UIView * tableView = scrollView.subviews[location];
            if (tableView && [tableView isKindOfClass:[UITableView class]]) {
                [(UITableView *)tableView reloadData];
            }
        }
        
    }
}

-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index{
    if (filterType != index) {
        [self getData];
        filterType = index;
    }
}

- (void)initTableView {

    self.firTableView.dataSource = self ;
    self.firTableView.delegate = self ;
    [self.firTableView registerNib:[UINib nibWithNibName:@"GoodDetailCustomCell" bundle:nil] forCellReuseIdentifier:@"GoodDetailCustomCell"];

    self.secTableView.dataSource = self ;
    self.secTableView.delegate = self ;
    [self.secTableView registerNib:[UINib nibWithNibName:@"GoodDetailCustomCell" bundle:nil] forCellReuseIdentifier:@"GoodDetailCustomCell"];

    self.thiTableView.dataSource = self ;
    self.thiTableView.delegate = self ;
    [self.thiTableView registerNib:[UINib nibWithNibName:@"GoodDetailCustomCell" bundle:nil] forCellReuseIdentifier:@"GoodDetailCustomCell"];

    self.fouTableView.dataSource = self ;
    self.fouTableView.delegate = self ;
    [self.fouTableView registerNib:[UINib nibWithNibName:@"GoodDetailCustomCell" bundle:nil] forCellReuseIdentifier:@"GoodDetailCustomCell"];

    self.fifTableView.dataSource = self ;
    self.fifTableView.delegate = self ;
    [self.fifTableView registerNib:[UINib nibWithNibName:@"GoodDetailCustomCell" bundle:nil] forCellReuseIdentifier:@"GoodDetailCustomCell"];

    firstArray = [NSArray array] ;
    secondArray = [NSArray array] ;
    thirdArray = [NSArray array] ;
    fourthArray = [NSArray array] ;
    fifthArray = [NSArray array] ;
   
}





- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
- (void)dealloc {
 
}

-(SPPageMenu *)pageMuenu{
    if (!_pageMuenu) {
        _pageMuenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, SGQRCodeScreenWidth, 42)trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMuenu.backgroundColor = [UIColor whiteColor];
        // 传递数组，默认选中第2个
        // 设置代理
        _pageMuenu.dividingLineHeight = 0;
        _pageMuenu.delegate = self;
        _pageMuenu.itemTitleFont = [UIFont systemFontOfSize:14];
        _pageMuenu.dividingLineHeight = 0;
        _pageMuenu.selectedItemTitleColor = [CommonUtil colorWithHexString:@"#ed6c6f"];;
        _pageMuenu.unSelectedItemTitleColor = [CommonUtil colorWithHexString:@"#333333"];
        _pageMuenu.tracker.backgroundColor = [CommonUtil colorWithHexString:@"#ed6c6f"];
        _pageMuenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    }
    
    return _pageMuenu;
}

@end
















