//
//  UploadViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "UploadViewController.h"
#import "AddProductViewController.h"
#import "EcAddProductViewController.h"
#import "GoodRecordCustomCell.h"
#import "UIImageView+YYWebImage.h"
#import "ApplyShoesViewController.h"
#import "NewApplyViewController.h"
#import "ComponentViewController.h"
#import "ApplyDressViewController.h"
#import "NewAddProductViewController.h"
#import "ComponentViewController.h"
@interface UploadViewController ()<UIAlertViewDelegate>

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"加载中" ;
    
    self.listTableView.dataSource = self ;
    self.listTableView.delegate = self ;
    self.listTableView.tableFooterView = [[UIView alloc] init];
    self.listTableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0) ;
}



- (void)viewWillAppear:(BOOL)animated {
    
    self.listTableView.hidden = YES ;
    
    NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],HISTORYDATA]]];
    
    if (!historyArray || [historyArray count] == 0) {
        
        ComponentViewController *vc = [[ComponentViewController alloc] init] ;
        vc.hidesBottomBarWhenPushed = YES ;
        [self.navigationController pushViewController:vc animated:NO] ;
   

        
        self.listTableView.hidden = YES ;
    }else {
    
        self.navigationItem.title = @"未提交申请单" ;
        self.navigationItem.rightBarButtonItem = item ;
        
        self.listTableView.hidden = NO ;
        
        self.dataArray = [NSArray arrayWithArray:historyArray] ;
        [self.listTableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES ;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete ;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {

    return @"删除" ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除这条记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil] ;
        alert.tag = indexPath.row ;
        [alert show];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray count] ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 71 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell" ;
    
    GoodRecordCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"GoodRecordCustomCell" owner:self options:nil];
        
        for (UIView *view in nibAry) {
            
            if ([view isKindOfClass:[GoodRecordCustomCell class]]) {
                
                cell = (GoodRecordCustomCell *)view ;
                break ;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    NSMutableArray *imageAry = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]] error:nil];
    
    for (NSString *file in fileList) {
        
        if ([[file componentsSeparatedByString:@"_"] count] == 2 &&
            [[[file componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"]) {
            
            [imageAry addObject:file] ;
            break ;
        }
    }
    
    if ([imageAry count]) {
    
        cell.goodImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject],[imageAry firstObject]]];
        cell.defaultImageView.hidden = YES ;
    }
    else if ([[[[dic allValues] firstObject] valueForKey:@"CasePicture"] count] &&
             ![[[[[[dic allValues] firstObject] valueForKey:@"CasePicture"] firstObject] valueForKey:@"SmallPictureUrl"] isEqualToString:@""]){
    
        [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[[[[dic allValues] firstObject] valueForKey:@"CasePicture"] firstObject] valueForKey:@"SmallPictureUrl"] substringFromIndex:1]]] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}] ;
        cell.defaultImageView.hidden = YES ;
    }
    else {
    
        cell.defaultImageView.hidden = NO ;
        cell.goodImageView.image = nil ;
    }
    
    NSDictionary *valueDic = [[dic allValues] firstObject] ;
    
    cell.createDateLabel.text = [NSString stringWithFormat:@"创建日期：%@",[valueDic valueForKey:@"CreateDate"] ];
    
    if ([[valueDic valueForKey:@"ArtilceNo"] isEqualToString:@""]) {
        
        cell.goodNumberLabel.text = [NSString stringWithFormat:@"货号：待填写"];
    }
    else cell.goodNumberLabel.text = [NSString stringWithFormat:@"货号：%@",[valueDic valueForKey:@"ArtilceNo"]];
    
    if ([[valueDic valueForKey:@"ArtilceSize"] isEqualToString:@""]) {
        
        cell.sizeLabel.text = [NSString stringWithFormat:@"尺码：待填写"];
    }
    else cell.sizeLabel.text = [NSString stringWithFormat:@"尺码：%@",[valueDic valueForKey:@"ArtilceSize"]];
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddProductViewController *vc = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    vc.caseNumber = [[[dic allValues] firstObject] valueForKey:@"CaseNumber"] ;
    vc.folderString = [[dic allKeys] firstObject] ;
    vc.totalOriginAry = [NSArray arrayWithObject:[[dic allValues] firstObject]];
    
   self.navigationItem.hidesBackButton = YES ;
    
    vc.hidesBottomBarWhenPushed = YES ;
    [self.navigationController pushViewController:vc animated:YES] ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        NSDictionary *dic = [self.dataArray objectAtIndex:alertView.tag];
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],HISTORYDATA]]];
        
        if (historyArray) {
            
            
            NSMutableArray *lastAry = [NSMutableArray array];
            
            for (NSDictionary *goodDic in historyArray) {
                
                if (![[[goodDic allKeys] firstObject] isEqualToString:[[dic allKeys] firstObject]]) {
                    
                    [lastAry addObject:goodDic] ;
                }
            }
            
            historyArray = [NSMutableArray arrayWithArray:lastAry];
            lastAry = nil ;
            
        
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            
            if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]]]) {
                
                [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[[dic allKeys] firstObject]] error:nil];
            }
        }
        else historyArray = [NSMutableArray array] ;
        
        self.dataArray = [NSArray arrayWithArray:historyArray];
        [historyArray writeToFile:[CommonUtil getPlistPath:[NSString stringWithFormat:@"%@_%@",[[self GetLoginUser].UserAccount uppercaseString],HISTORYDATA]] atomically:YES] ;
        [self.listTableView reloadData] ;
        
        if (!historyArray || [historyArray count] == 0) {
            
            AddProductViewController *vc = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil] ;
            
            vc.caseNumber = @"" ;
            vc.isShowBack = YES ;
            vc.hidesBottomBarWhenPushed = YES ;
            [self.navigationController pushViewController:vc animated:NO] ;
            
            self.listTableView.hidden = YES ;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end















