//
//  InstallCampaignPhotoViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/7/11.
//

#import "InstallCampaignPhotoViewController.h"
#import "CommonUtil.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "CommonDefine.h"
#import "InstallTableViewCell.h"
#import "UIImageView+YYWebImage.h"
#import "ReviewDetailImageViewController.h"
#import "EditViewController.h"

@interface InstallCampaignPhotoViewController ()<UITableViewDelegate,UITableViewDataSource,installcellDelegate,EditDelegate>

@end

@implementation InstallCampaignPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    self.view.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44) ];
    label.text =self.campData.pop_name;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = SYS_YELLOW;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
   
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    locationview.image = [UIImage imageNamed:@"locationBarbg.png"];
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEWIDTH-30, 40)];
    locationlabel.tag = 111;
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor = [UIColor clearColor];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.text = [CacheManagement instance].currentStore.StoreName;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];
    
    self.campaignPopTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEVICE_WID, DEVICE_HEIGHT-40 - 64) style:UITableViewStylePlain];
    self.campaignPopTable.showsVerticalScrollIndicator = NO;
    self.campaignPopTable.delegate = self;
    self.campaignPopTable.dataSource = self;
    self.campaignPopTable.tableFooterView = [[UIView alloc] init];
    self.campaignPopTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.campaignPopTable];
    
    NSArray *sourceArray = [NSArray array];
    NSString *savedStr = [NSString stringWithFormat:@"%@_%@_%@",[CacheManagement instance].currentUser.UserId,[CacheManagement instance].currentStore.StoreCode,self.campData.campaign_id] ;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:savedStr];
    if (dic&&[[dic allKeys] containsObject:self.campData.pop_id]) {
        sourceArray = [dic objectForKey:self.campData.pop_id];
    }
    if (!sourceArray||[sourceArray count]==0) {
        NSMutableArray *ary = [NSMutableArray array];
        for (int i = 0; i<[self.campData.MIN_PHOTO_COUNT intValue]; i++) {
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            [dataDic setValue:@"" forKey:@"comment"];
            [dataDic setValue:@"" forKey:@"path"];
            [ary addObject:dataDic];
            dataDic = nil ;
        }
        sourceArray = [NSMutableArray arrayWithArray:ary];
        ary = nil ;
    }
    self.popListData = [NSArray arrayWithArray:sourceArray];
    sourceArray = nil ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back {
    NSString *savedStr = [NSString stringWithFormat:@"%@_%@_%@",[CacheManagement instance].currentUser.UserId,[CacheManagement instance].currentStore.StoreCode,self.campData.campaign_id] ;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:savedStr];
    if (!dic) dic = [NSDictionary dictionary];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [muDic setObject:self.popListData forKey:self.campData.pop_id];
    [[NSUserDefaults standardUserDefaults] setObject:muDic forKey:savedStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier_2 = @"cell";

    InstallTableViewCell* cell_2 = [tableView dequeueReusableCellWithIdentifier:identifier_2];
    if (nil == cell_2)
    {
        cell_2 = [[[NSBundle mainBundle]loadNibNamed:@"InstallTableViewCell" owner:self options:nil]objectAtIndex:0];
        cell_2.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell_2.currentIndex = (int)indexPath.row ;
    cell_2.number_label.text = @"";
    cell_2.describeStr =  @"";
    cell_2.contentView.backgroundColor = [UIColor whiteColor];
    cell_2.pic_name =  self.campData.pic_serv_name;
    cell_2.pic_name_thumb = self.campData.pic_serv_thumbname;
    cell_2.pop_id = self.campData.pop_id;
    cell_2.delegate = self ;
    cell_2.rightImageView.hidden = NO ;
    cell_2.inputView.hidden = NO ;
    [cell_2.rightImageView yy_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,self.campData.pic_serv_thumbname] stringByReplacingOccurrencesOfString:@"~" withString:@""]] placeholder:[UIImage imageNamed:@"defaultadidas.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
    
    cell_2.picpath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@_%d.jpg",[Utilities SysDocumentPath],self.campData.campaign_id,[CacheManagement instance].currentStore.StoreCode,@"INSTALL",[CacheManagement instance].currentUser.UserId,self.campData.pop_id,(int)indexPath.row];
    NSDictionary *dic = [self.popListData objectAtIndex:indexPath.row];
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    BOOL exist = [fileMannager fileExistsAtPath:cell_2.picpath];
    if([dic valueForKey:@"path"]&&[[dic valueForKey:@"path"] length]>0&&exist) {
        cell_2.takephotoImage.image = [UIImage imageWithContentsOfFile:cell_2.picpath];
    } else {
        cell_2.takephotoImage.image = [UIImage imageNamed:@"Take-Pictures.png"];
    }
    if ([dic valueForKey:@"comment"]&&![[dic valueForKey:@"comment"] isEqualToString:@""]) {
        cell_2.infoLabel.hidden = YES ;
        cell_2.remarkTextView.text = [dic valueForKey:@"comment"] ;
    } else {
        cell_2.infoLabel.hidden = NO ;
        cell_2.remarkTextView.text = @"" ;
    }
    
    return cell_2;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.popListData count];
}

-(void)openCamera:(UIImagePickerController *)picker
{
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)resetSourceData:(int)index {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@_%d.jpg",[Utilities SysDocumentPath],self.campData.campaign_id,[CacheManagement instance].currentStore.StoreCode,@"INSTALL",[CacheManagement instance].currentUser.UserId,self.campData.pop_id,index];
    NSMutableArray *ary = [NSMutableArray arrayWithArray:self.popListData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ary objectAtIndex:index]];
    [dic setValue:path forKey:@"path"];
    [ary replaceObjectAtIndex:index withObject:dic];
    self.popListData = [NSArray arrayWithArray:ary];
    [self.campaignPopTable reloadData];
    ary = nil ;
}

- (void)showLargePic:(NSString *)pic_name {
    
    if (pic_name&&![pic_name isEqualToString:@""]) {
        
        ReviewDetailImageViewController *rdivc = [[ReviewDetailImageViewController alloc] initWithNibName:@"ReviewDetailImageViewController" bundle:nil];
        rdivc.imageUrl = pic_name ;
        rdivc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:rdivc animated:NO completion:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([self.popListData count]>=[self.campData.MAX_PHOTO_COUNT integerValue]) {
        return 0 ;
    }
    return 40 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if ([self.popListData count]>=[self.campData.MAX_PHOTO_COUNT integerValue]) return nil;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WID, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEWIDTH, 40)];
    label.text = @"+ Add" ;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, DEVICE_WID, 40);
    [btn addTarget:self action:@selector(addMore) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view ;
}

- (void)addMore {
    
    BOOL isCanDo = YES ;
    for (NSDictionary *dic in self.popListData) {
        
        if ((![dic valueForKey:@"comment"]||[[dic valueForKey:@"comment"] isEqualToString:@""])&&
            (![dic valueForKey:@"path"]||[[dic valueForKey:@"path"] isEqualToString:@""])) {
            isCanDo = NO ;
            break ;
        }
    }
    
    if(!isCanDo) {
        
        [Utilities alertMessage:@"请完成现有项后再添加!"];
        return ;
    }
    
    NSMutableArray *ary = [NSMutableArray arrayWithArray:self.popListData];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setValue:@"" forKey:@"comment"];
    [dataDic setValue:@"" forKey:@"path"];
    [ary addObject:dataDic];
    dataDic = nil ;
    self.popListData = [NSArray arrayWithArray:ary];
    ary = nil;
    [self.campaignPopTable reloadData];
}


- (void)inputComment:(int)index {
    
    EditViewController *recommandVC = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil] ;
    recommandVC.delegate = self ;
    recommandVC.type = @"1" ;
    recommandVC.index = index;
    recommandVC.textVal = [[self.popListData objectAtIndex:index] valueForKey:@"comment"];
    recommandVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:recommandVC animated:NO completion:^{}];
}

- (void)FinishEditWith:(NSString *)text andIndex:(NSInteger)index {
    
    NSMutableArray *ary = [NSMutableArray arrayWithArray:self.popListData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ary objectAtIndex:index]];
    [dic setValue:text forKey:@"comment"];
    [ary replaceObjectAtIndex:index withObject:dic];
    self.popListData = [NSArray arrayWithArray:ary];
    [self.campaignPopTable reloadData];
    ary = nil ;
}

@end












