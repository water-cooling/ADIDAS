//
//  OrderDetailView.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "OrderDetailView.h"
#import "UploadPicCustomCell.h"
#import "DefectiveCustomCell.h"
#import "FeedBackCustomCell.h"
#import "CommonUtil.h"
#import "AppDelegate.h"
#import "CaseTitleViewController.h"

@implementation OrderDetailView

- (void)layoutSubviews {

}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
}

- (void)setDataDic:(NSDictionary *)dataDic {

    self.contentTableView.dataSource = self ;
    self.contentTableView.delegate = self ;
    
    _dataDic = dataDic ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    int count = 3 ;
    
    if (!self.isEdited) count = 6 ;
    
    if (section == count - 1) return 0 ;
    
    return 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 5 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        if ([[CacheManagement instance].showSpecial isEqualToString:@"1"]) {
            if ([[NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"IsSpecial"]] isEqualToString:@"1"]) return 12 + 1 ;
            return 11 + 1 ;
        } else {
            return 9 + 1 ;
        }
    }
    
    if (section == 1 ) return 1 ;
    
    if (section == 2) return 2 ;
    
    BOOL isShow = [[NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"ShowStoreTrackingNo"]] isEqualToString:@"Y"] ;
    
    if (section == 3 && isShow) {
        
        NSMutableArray *ary = [NSMutableArray array];
        [ary addObject:@{@"name":@"快递单号(店铺→客服部)",@"value":[NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"MatterReturnTrackingNo"]]}] ;
        
        @try {
            NSString *MatterStoreTrackingNo = [self.dataDic valueForKey:@"MatterStoreTrackingNo"];
            if (MatterStoreTrackingNo&&![MatterStoreTrackingNo isEqual:[NSNull null]]&&![MatterStoreTrackingNo isEqualToString:@""]&&![MatterStoreTrackingNo containsString:@"null"]) {
                [ary addObject:@{@"name":@"快递单号(客服部→店铺)",@"value":[NSString stringWithFormat:@"%@",MatterStoreTrackingNo]}] ;
            }
            NSString *ReturnType = [self.dataDic valueForKey:@"ReturnType"];
            if (ReturnType&&![ReturnType isEqual:[NSNull null]]&&![ReturnType isEqualToString:@""]&&![ReturnType containsString:@"null"]) {
                [ary addObject:@{@"name":@"接受退货类型",@"value":[NSString stringWithFormat:@"%@",ReturnType]}] ;
            }
            NSString *DefectiveCode = [self.dataDic valueForKey:@"DefectiveCode"];
            if (DefectiveCode&&![DefectiveCode isEqual:[NSNull null]]&&![DefectiveCode isEqualToString:@""]&&![DefectiveCode containsString:@"null"]) {
                [ary addObject:@{@"name":@"残次代码/残次子代码",@"value":[NSString stringWithFormat:@"%@",DefectiveCode]}] ;
            }
            
        } @catch (NSException *exception) {}
        self.expressAry = [NSArray arrayWithArray:ary];
        return [self.expressAry count] ;
    }
    
    int index = 3 ; if (isShow) index = 4 ;
    
    if (section == index || section == index + 1) return 1 ;
    
    return 0 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (!self.isEdited) {
        
        if ([[NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"ShowStoreTrackingNo"]] isEqualToString:@"Y"]) return 6 ;
        
        return 5 ;
    }
    
    return 3 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) return 44 ;
    
    if (indexPath.section == 1) return 150 ;
    
    if (indexPath.section == 2) {
    
        if (indexPath.row == 0) return 44 ;
        if (indexPath.row == 1) return 124 ;
    }
    
    BOOL isShow = [[NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"ShowStoreTrackingNo"]] isEqualToString:@"Y"] ;
    
    if (indexPath.section == 3 && isShow) return 44 ;
    
    int index = 3 ; if (isShow) index = 4 ;
    
    if (indexPath.section == index) return 111 ;
    
    if (indexPath.section == index + 1) return 131 ;
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    @try {
        
        if (indexPath.section == 1) {
            
            static NSString *CellIdentifier1 = @"cell1" ;
            
            UploadPicCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell == nil) {
                
                NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"UploadPicCustomCell" owner:self options:nil];
                
                for (UIView *view in nibAry) {
                    
                    if ([view isKindOfClass:[UploadPicCustomCell class]]) {
                        
                        cell = (UploadPicCustomCell *)view ;
                        break ;
                    }
                }
            }
            cell.vc = self.vc ;
            if ([self.dataDic valueForKey:@"CasePicture"] && ![[self.dataDic valueForKey:@"CasePicture"] isEqual:[NSNull null]] &&
                [[self.dataDic valueForKey:@"CasePicture"] count]) {
                
                cell.webUrlArray = [self.dataDic valueForKey:@"CasePicture"] ;
            }
            cell.foldName = self.folderName ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
        
        if (indexPath.section == 2 && indexPath.row == 1) {
            
            static NSString *CellIdentifier2 = @"cell2" ;
            
            DefectiveCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            
            if (cell == nil) {
                
                NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"DefectiveCustomCell" owner:self options:nil];
                
                for (UIView *view in nibAry) {
                    
                    if ([view isKindOfClass:[DefectiveCustomCell class]]) {
                        
                        cell = (DefectiveCustomCell *)view ;
                        break ;
                    }
                }
            }
            cell.defectiveTextView.text = [[self.dataDic valueForKey:@"CaseComment"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"CaseComment"] ;
            cell.placeHoladLabel.hidden = ![[self.dataDic valueForKey:@"CaseComment"] isEqual:[NSNull null]]&&[self.dataDic valueForKey:@"CaseComment"]&&![[self.dataDic valueForKey:@"CaseComment"] isEqualToString:@""] ;
            cell.defectiveTextView.editable = self.isEdited ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
        
        BOOL isShow = [[NSString stringWithFormat:@"%@",[self.dataDic valueForKey:@"ShowStoreTrackingNo"]] isEqualToString:@"Y"] ;
        
        if (indexPath.section == 3 && isShow) {
            
            static NSString *CellIdentifier4 = @"cell6" ;
            
            EditTableViewCell *originCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
            
            if (originCell == nil) {
                
                NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"EditTableViewCell" owner:self options:nil];
                
                for (UIView *view in nibAry) {
                    
                    if ([view isKindOfClass:[EditTableViewCell class]]) {
                        
                        originCell = (EditTableViewCell *)view ;
                        break ;
                    }
                }
            }
            
            originCell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            @try {
                originCell.delegate = self;
                NSDictionary *expressDic = [self.expressAry objectAtIndex:indexPath.row];
                originCell.valueType = [NSString stringWithFormat:@"%@",[expressDic valueForKey:@"name"]] ;
                originCell.rightLabel.text = [NSString stringWithFormat:@"%@",[expressDic valueForKey:@"value"]] ;
            } @catch (NSException *exception) {}
            
            
            originCell.selectWitch.hidden = YES ;
            originCell.reginView.hidden = YES ;
            originCell.rightTextField.hidden = YES ;
            
            originCell.rightTextField.enabled = NO ;
            originCell.selectWitch.enabled = NO ;
            originCell.regionTextField.enabled = NO ;
            originCell.phoneTextField.enabled = NO ;
            originCell.rightLabel.hidden = NO ;

            return originCell ;
        }
        
        int showInd = 3 ; if (isShow) showInd = 4 ;
        
        if (indexPath.section == showInd || indexPath.section == showInd + 1) {
            
            static NSString *CellIdentifier3 = @"cell3" ;
            
            FeedBackCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            
            if (cell == nil) {
                
                NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"FeedBackCustomCell" owner:self options:nil];
                
                for (UIView *view in nibAry) {
                    
                    if ([view isKindOfClass:[FeedBackCustomCell class]]) {
                        
                        cell = (FeedBackCustomCell *)view ;
                        break ;
                    }
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            if (indexPath.section == showInd) {
                
                cell.feedTypeLabel.text = @"回复结果" ;
                cell.infowebview.hidden = YES ;
                cell.feedContentTextView.hidden = NO ;
                cell.feedContentTextView.text = [[self.dataDic valueForKey:@"ApproveTitle"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"ApproveTitle"] ;
            }
            
            if (indexPath.section == showInd + 1) {
                
                cell.feedTypeLabel.text = @"反馈意见" ;
                cell.infowebview.hidden = NO ;
                cell.feedContentTextView.hidden = YES ;
                
                [cell.infowebview loadHTMLString:[[self.dataDic valueForKey:@"ApproveComment"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"ApproveComment"] baseURL:nil] ;
            }
            
            return cell ;
        }
        
        if (indexPath.section == 0) {
            
            static NSString *CellIdentifier4 = @"cell4" ;
            
            EditTableViewCell *originCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
            
            if (originCell == nil) {
                
                NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"EditTableViewCell" owner:self options:nil];
                
                for (UIView *view in nibAry) {
                    
                    if ([view isKindOfClass:[EditTableViewCell class]]) {
                        
                        originCell = (EditTableViewCell *)view ;
                        break ;
                    }
                }
            }
            originCell.rightTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            originCell.rightLabel.hidden = YES ;
            originCell.rightLabel.text = @"" ;
            if (indexPath.row ==10 || indexPath.row == 11) {
                
                originCell.selectWitch.hidden = NO ;
                originCell.rightTextField.hidden = YES ;
                if (indexPath.row == 10&&self.isEdited) {
                    [originCell.selectWitch addTarget:self action:@selector(selectSwithch:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            else {
                
                originCell.selectWitch.hidden = YES ;
                originCell.rightTextField.hidden = NO ;
            }
            
            if (indexPath.row == 5) {
                
                originCell.reginView.hidden = NO ;
                originCell.selectWitch.hidden = YES ;
                originCell.rightTextField.hidden = YES ;
            }
            else {
                
                originCell.reginView.hidden = YES ;
            }
            
            if (indexPath.row == 0) {
                
                originCell.valueType = @"货号" ;
                originCell.rightTextField.text = [[self.dataDic valueForKey:@"ArtilceNo"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"ArtilceNo"] ;
                originCell.rightTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            }
            
            if (indexPath.row == 1) {
                
                originCell.valueType = @"尺码" ;
                originCell.rightTextField.text = [[self.dataDic valueForKey:@"ArtilceSize"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"ArtilceSize"] ;
            }
            
            if (indexPath.row == 2) {
                
                originCell.valueType = @"数量" ;
                originCell.rightTextField.text = [[self.dataDic valueForKey:@"ArtilceQuantity"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"ArtilceQuantity"] ;
            }
            
            if (indexPath.row == 3) {
                
                originCell.valueType = @"购买日期" ;
                originCell.rightTextField.text = [[self.dataDic valueForKey:@"SalesDate"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"SalesDate"];
            }
            
            if (indexPath.row == 4) {
                
                originCell.valueType = @"工单号" ;
                originCell.rightTextField.text = [[self.dataDic valueForKey:@"WorkerNumber"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"WorkerNumber"];
            }
            
            if (indexPath.row == 5) {
                
                originCell.valueType = @"门店电话" ;
                
                if (self.dataDic && [self.dataDic valueForKey:@"StorePhone"] && ![[self.dataDic valueForKey:@"StorePhone"] isEqual:[NSNull null]] && ![[self.dataDic valueForKey:@"StorePhone"] isEqualToString:@""]) {
                    
                    if ([[self.dataDic valueForKey:@"StorePhone"] containsString:@"-"]) {
                        originCell.regionTextField.text = [[[self.dataDic valueForKey:@"StorePhone"] componentsSeparatedByString:@"-"] firstObject] ;
                        originCell.phoneTextField.text = [[[self.dataDic valueForKey:@"StorePhone"] componentsSeparatedByString:@"-"] lastObject] ;
                    } else {
                        originCell.regionTextField.text = @"" ;
                        originCell.phoneTextField.text = [[[self.dataDic valueForKey:@"StorePhone"] componentsSeparatedByString:@"-"] lastObject] ;
                    }
                }
                else if ([self.vc GetLoginUser].StorePhone && ![[self.vc GetLoginUser].StorePhone isEqual:[NSNull null]] && ![[self.vc GetLoginUser].StorePhone isEqualToString:@""]&&[[self.dataDic allKeys] containsObject:@"StorePhone"]) {
                    
                    if ([[self.vc GetLoginUser].StorePhone containsString:@"-"]) {
                        originCell.regionTextField.text = [[[self.vc GetLoginUser].StorePhone componentsSeparatedByString:@"-"] firstObject] ;
                        originCell.phoneTextField.text = [[[self.vc GetLoginUser].StorePhone componentsSeparatedByString:@"-"] lastObject] ;
                    } else {
                        originCell.regionTextField.text = @"" ;
                        originCell.phoneTextField.text = [[[self.vc GetLoginUser].StorePhone componentsSeparatedByString:@"-"] lastObject] ;
                    }
                }
                else {
                    originCell.regionTextField.text = @"" ;
                    originCell.phoneTextField.text = @"" ;
                }
            }
            
            if (indexPath.row == 6) {
                
                originCell.valueType = @"门店负责人手机号" ;
                
                if (self.dataDic && [self.dataDic valueForKey:@"StoreManagePhone"] && ![[self.dataDic valueForKey:@"StoreManagePhone"] isEqualToString:@""]) {
                    
                    originCell.rightTextField.text = [[self.dataDic valueForKey:@"StoreManagePhone"] isEqual:[NSNull null]] ? [self.vc GetLoginUser].StoreManagePhone : [self.dataDic valueForKey:@"StoreManagePhone"] ;
                }
                else if ([self.vc GetLoginUser].StoreManagePhone && ![[self.vc GetLoginUser].StoreManagePhone isEqual:[NSNull null]] && ![[self.vc GetLoginUser].StoreManagePhone isEqualToString:@""]&&[[self.dataDic allKeys] containsObject:@"StoreManagePhone"]) {
                    originCell.rightTextField.text = [self.vc GetLoginUser].StoreManagePhone ;
                }
                else originCell.rightTextField.text = @"" ;
            }
            
            if (indexPath.row == 7) {
                
                originCell.valueType = @"门店邮箱" ;
                
                if (self.dataDic && [self.dataDic valueForKey:@"StoreMail"] && ![[self.dataDic valueForKey:@"StoreMail"] isEqualToString:@""]) {
                    
                    originCell.rightTextField.text = [[self.dataDic valueForKey:@"StoreMail"] isEqual:[NSNull null]] ? [self.vc GetLoginUser].StoreEmail : [self.dataDic valueForKey:@"StoreMail"];
                }
                else originCell.rightTextField.text = [self.vc GetLoginUser].StoreEmail ;
            }
            
            if (indexPath.row == 8) {
                
                originCell.valueType = @"寄件地址" ;
                
                if (self.dataDic && [self.dataDic valueForKey:@"PostAddress"] && ![[self.dataDic valueForKey:@"PostAddress"] isEqualToString:@""]) {
                    
                    originCell.rightTextField.text = [[self.dataDic valueForKey:@"PostAddress"] isEqual:[NSNull null]] ? [self.vc GetLoginUser].PostAddress : [self.dataDic valueForKey:@"PostAddress"];
                }
                else originCell.rightTextField.text = [self.vc GetLoginUser].PostAddress ;
            }
            
            if (indexPath.row == 9) {
                
                originCell.valueType = @"申请人" ;
                
                if (self.dataDic && [self.dataDic valueForKey:@"Requestor"] && ![[self.dataDic valueForKey:@"Requestor"] isEqualToString:@""]) {
                    
                    originCell.rightTextField.text = [[self.dataDic valueForKey:@"Requestor"] isEqual:[NSNull null]] ? [self.vc GetLoginUser].Requestor : [self.dataDic valueForKey:@"Requestor"];
                }
                else originCell.rightTextField.text = [self.vc GetLoginUser].Requestor ;
            }
            
            if (indexPath.row == 10) {
                
                originCell.valueType = @"是否定制鞋" ;
                
                if (self.dataDic && [self.dataDic valueForKey:@"IsSpecial"] && ![[self.dataDic valueForKey:@"IsSpecial"] isEqualToString:@""]) {
                    
                    [originCell.selectWitch setOn:[[self.dataDic valueForKey:@"IsSpecial"] isEqualToString:@"1"]] ;
                }
                else [originCell.selectWitch setOn:NO];
            }
            
            if (indexPath.row == 11) {
                
                originCell.valueType = @"是否Reebok" ;
                
                if (self.dataDic && [self.dataDic valueForKey:@"IsRBK"] && ![[self.dataDic valueForKey:@"IsRBK"] isEqualToString:@""]) {
                    
                    [originCell.selectWitch setOn:[[self.dataDic valueForKey:@"IsRBK"] isEqualToString:@"1"]] ;
                }
                else [originCell.selectWitch setOn:[[CacheManagement instance].ShowRBK isEqualToString:@"1"]];
            }
            
            if (indexPath.row == 12) {
                
                originCell.valueType = @"mi订单编号" ;
                originCell.rightTextField.text = [[self.dataDic valueForKey:@"MiOrderNumber"] isEqual:[NSNull null]] ? @"" : [self.dataDic valueForKey:@"MiOrderNumber"];
            }
            
            if (indexPath.row != 3 || !self.isEdited) {
                
                originCell.selectionStyle = UITableViewCellSelectionStyleNone ;
                originCell.rightTextField.enabled = self.isEdited ;
                originCell.selectWitch.enabled = self.isEdited ;
                originCell.regionTextField.enabled = self.isEdited ;
                originCell.phoneTextField.enabled = self.isEdited ;
            }
            else originCell.selectionStyle = UITableViewCellSelectionStyleGray ;
            
            if (indexPath.row == 9 && self.isEdited) {
                originCell.rightTextField.enabled = !(![[self.vc GetLoginUser].Requestor isEqual:[NSNull null]]&&![[self.vc GetLoginUser].Requestor isEqualToString:@""]) ;
            }
            
            if (indexPath.row == 2) {
                originCell.rightTextField.enabled = NO ;
                originCell.rightTextField.text = @"1" ;
            }
            
            return originCell ;
        }
        
        static NSString *CellIdentifier = @"cell" ;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"残次类型:" ;
        
        if (self.dataDic && [self.dataDic valueForKey:@"CaseTitle"] && ![[self.dataDic valueForKey:@"CaseTitle"] isEqualToString:@""]&& ![[self.dataDic valueForKey:@"CaseTitle"] isEqualToString:@"请选择残次类型"]) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",[self.dataDic valueForKey:@"CaseTitleType"],[self.dataDic valueForKey:@"CaseTitle"]];
        }
        else cell.detailTextLabel.text = @"请选择残次类型" ;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        
        if (self.isEdited) cell.selectionStyle = UITableViewCellSelectionStyleGray ;
        else cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell ;
        
    } @catch (NSException *exception) {
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 0 && self.isEdited) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CaseTitleViewController *controller = [[CaseTitleViewController alloc] initWithNibName:@"CaseTitleViewController" bundle:nil];
        controller.delegate = self ;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.vc.navigationItem.backBarButtonItem = item ;
        [self.vc.navigationController pushViewController:controller animated:YES] ;
    }
    
    if (indexPath.section == 0 && indexPath.row == 3 && self.isEdited) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        DatePickerViewController *recommandVC = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil] ;
        recommandVC.delegate = self ;
        recommandVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [kAppDelegate.window.rootViewController presentViewController:recommandVC animated:NO completion:^{}];
    }
    
    if(self.isEdited) [self clearKeyBoard];
}

- (void)currentDate:(NSString *)date {

    EditTableViewCell *cell4 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];//购买日期
    cell4.rightTextField.text = date ;
}

- (void)clearData {
    
    self.folderName = @"" ;
    [self.contentTableView reloadData];
}


- (void)finishWith:(NSString *)result {

    UITableViewCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.detailTextLabel.text = result ;
}


- (void)clearKeyBoard {

    @try {
        EditTableViewCell *cell1 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];//货号
        EditTableViewCell *cell2 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];//尺码
        EditTableViewCell *cell3 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];//数量
        EditTableViewCell *cell4 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];//购买日期
        EditTableViewCell *cell5 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];//工单号
        EditTableViewCell *cell6 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];//门店电话
        EditTableViewCell *cell7 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];//门店人负责人手机号
        EditTableViewCell *cell8 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];//门店邮箱
        EditTableViewCell *cell11 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];//寄件地址
        EditTableViewCell *cell9 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];//申请人
        DefectiveCustomCell *cell10 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];//残次描述
        EditTableViewCell *cell12 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];//mi订单编号
        
        [cell1.rightTextField resignFirstResponder] ;
        [cell2.rightTextField resignFirstResponder] ;
        [cell3.rightTextField resignFirstResponder] ;
        [cell4.rightTextField resignFirstResponder] ;
        [cell5.rightTextField resignFirstResponder] ;
        [cell6.regionTextField resignFirstResponder] ;
        [cell6.phoneTextField resignFirstResponder] ;
        [cell7.rightTextField resignFirstResponder] ;
        [cell8.rightTextField resignFirstResponder] ;
        [cell9.rightTextField resignFirstResponder] ;
        [cell10.defectiveTextView resignFirstResponder] ;
        [cell12.rightTextField resignFirstResponder] ;
        [cell11.rightTextField resignFirstResponder] ;
    } @catch (NSException *exception) {
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyText:));
}


//  复制时执行的方法
- (void)copyText:(id)sender {
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    pBoard.string = pastTitle ;
}

-(BOOL)canBecomeFirstResponder{

    return YES;
}

- (void)longPressTap:(NSString *)text withLeftTitle:(NSString *)left{
    int index = 0 ;
    @try {
        if ([left containsString:[[self.expressAry lastObject] valueForKey:@"name"]]) index = 1 ;
        if ([left containsString:[[self.expressAry objectAtIndex:2] valueForKey:@"name"]]) index = 2 ;
        if ([left containsString:[[self.expressAry objectAtIndex:1] valueForKey:@"name"]]) index = 3 ;
        if ([left containsString:[[self.expressAry objectAtIndex:0] valueForKey:@"name"]]) index = 4 ;
    } @catch (NSException *exception) {
    }
    pastTitle = text ;
    [self becomeFirstResponder];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:item]];
    [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(PHONE_WIDTH - 100, self.frame.size.height - 131 - 111 - 44*index , 100, 44) inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)selectSwithch:(UISwitch *)swi {
    @try {
        EditTableViewCell *cell12 = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
        BOOL showMI = cell12.selectWitch.isOn ;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
        [dic setValue:[NSString stringWithFormat:@"%d",showMI] forKey:@"IsSpecial"];
        self.dataDic = [NSDictionary dictionaryWithDictionary:dic];
        
        if (showMI) {
            [self.contentTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:12 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.contentTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:12 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.vc refreshDetailList];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description) ;
    }
}

@end



































