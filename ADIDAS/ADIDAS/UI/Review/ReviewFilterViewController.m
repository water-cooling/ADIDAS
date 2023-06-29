//
//  ReviewFilterViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/6/12.
//

#import "ReviewFilterViewController.h"
#import "CommonDefine.h"
#import "CommonUtil.h"

@interface ReviewFilterViewController ()

@end

@implementation ReviewFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.confirmBtn.layer.cornerRadius = 4 ;
    self.confirmBtn.layer.masksToBounds = YES ;
    
    self.filterTableView.dataSource = self ;
    self.filterTableView.delegate = self ;
    self.keywordTextField.text = self.fourCondition ;
    self.keywordTextField.delegate = self ;
    
    if (self.pageTye != 40) {
        self.filterTableView.hidden = NO ;
        self.keywordTextField.hidden = YES ;
        self.bgLineImage.hidden = NO;
        self.cancelBtn.hidden = NO ;
        self.confirmBtn.hidden = NO ;
        [self getSourceData];
        
        if ([self.dataSourceArray count] >= 5) {
            CGRect aframe = self.filterBGView.frame ;
            aframe.size.height = 5*46+46 ;
            self.filterBGView.frame = aframe ;
        } else {
            CGRect aframe = self.filterBGView.frame ;
            aframe.size.height = [self.dataSourceArray count]*46+46 ;
            self.filterBGView.frame = aframe ;
        }
        
    } else {
        self.filterTableView.hidden = YES ;
        self.keywordTextField.hidden = NO ;
        self.bgLineImage.hidden = YES ;
        self.cancelBtn.hidden = YES ;
        self.confirmBtn.hidden = YES ;
        [self.keywordTextField becomeFirstResponder];
        CGRect aframe = self.filterBGView.frame ;
        aframe.size.height = 71 ;
        self.filterBGView.frame = aframe ;
    }
    
    if (SYSLanguage == 1) {
        [self.confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal] ;
        [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal] ;
    } else {
        self.keywordTextField.placeholder = @"输入活动名称" ;
    }
    
    self.keywordTextField.layer.cornerRadius = 4 ;
    self.keywordTextField.layer.borderColor = [[CommonUtil colorWithHexString:@"#e5e5e5"] CGColor];
    self.keywordTextField.layer.borderWidth = 1 ;
    self.keywordTextField.layer.masksToBounds = YES ;
    
    UIView *leftpendding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.keywordTextField.leftView = leftpendding ;
    self.keywordTextField.leftViewMode = UITextFieldViewModeAlways ;
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (self.pageTye != 40) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect aframe = self.filterBGView.frame ;
            float currentH = aframe.size.height ;
            aframe.origin.y = DEHEIGHT - currentH ;
            self.filterBGView.frame = aframe ;
        } completion:^(BOOL finished) {}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.fourCondition = textField.text ;
    [self.keywordTextField resignFirstResponder];
    [self dismissAllView:nil];
    [self.delegate confirmFilterAction:self.firCondition :self.secCondition :self.thiCondition :self.fourCondition pageType:self.pageTye];
    return true ;
}

- (IBAction)dismissView:(id)sender {
    
    [self.delegate removeColor];
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)dismissAllView:(id)sender {
    
    [self.delegate removeColor];
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)filterAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender ;
    
    if(btn.tag == self.pageTye) return ;
    
    [self.delegate changeFilterWithTag:(int)btn.tag] ;
    
    self.pageTye = (int)btn.tag ;

    if (self.pageTye != 40) {
        self.filterTableView.hidden = NO ;
        self.keywordTextField.hidden = YES ;
        self.bgLineImage.hidden = NO ;
        self.cancelBtn.hidden = NO ;
        self.confirmBtn.hidden = NO ;
        [self getSourceData];
        [self.keywordTextField resignFirstResponder];
        float currentH = 0 ;
        if ([self.dataSourceArray count] >= 5) {
            currentH = 5*46+46 ;
        } else {
            currentH = [self.dataSourceArray count]*46+46 ;
        }
        
        CGRect aframe = self.filterBGView.frame ;
        aframe.origin.y = DEHEIGHT - currentH ;
        aframe.size.height = currentH;
        self.filterBGView.frame = aframe ;
        
    } else {
        self.filterTableView.hidden = YES ;
        self.keywordTextField.hidden = NO ;
        self.bgLineImage.hidden = YES ;
        self.cancelBtn.hidden = YES ;
        self.confirmBtn.hidden = YES ;
        [self.keywordTextField becomeFirstResponder];
        CGRect aframe = self.filterBGView.frame ;
        aframe.size.height = 71 ;
        self.filterBGView.frame = aframe ;
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [_filterTableView release];
    [_filterBGView release];
    [_confirmBtn release];
    [_keywordTextField release];
    [_cancelBtn release];
    [_bgLineImage release];
    [super dealloc];
}


- (IBAction)confrimAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender ;
    if (btn.tag == 10) {
        self.fourCondition = self.keywordTextField.text ;
        [self.keywordTextField resignFirstResponder];
        [self dismissAllView:nil];
        [self.delegate confirmFilterAction:self.firCondition :self.secCondition :self.thiCondition :self.fourCondition pageType:self.pageTye];
    }
    if (btn.tag == 20) {
        [self dismissView:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArray count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    @try {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        if (self.pageTye == 20) {
            
            for (NSDictionary *dic in self.originFilterData) {
                
                if ([[self.dataSourceArray objectAtIndex:indexPath.row] isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"CAMPAIGN_ID"]]]) {
                    
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"CAMPAIGN_NAME"]];
                    break ;
                }
            }
        } else {
            
            cell.textLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row];
        }
        
        NSArray *targetStringAry = nil ;
        
        if (self.pageTye == 10) targetStringAry = [self.firCondition componentsSeparatedByString:@","] ;
        
        if (self.pageTye == 20) targetStringAry = [self.secCondition componentsSeparatedByString:@","];
        
        if (self.pageTye == 30) targetStringAry = [self.thiCondition componentsSeparatedByString:@","];
        
        if ([targetStringAry containsObject:[self.dataSourceArray objectAtIndex:indexPath.row]]) {
            cell.textLabel.textColor = [CommonUtil colorWithHexString:@"#1881f6"];
            cell.accessoryType = UITableViewCellAccessoryCheckmark ;
        } else {
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } @catch (NSException *exception) {
    }
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *targetString = [self.dataSourceArray objectAtIndex:indexPath.row] ;
    
    if (self.pageTye == 10) {
        if([self.firCondition isEqualToString:targetString]) self.firCondition = @"" ;
        else self.firCondition = targetString;
//        if ([self.firCondition isEqualToString:@""]) self.firCondition = targetString;
//        else if ([self.firCondition containsString:[NSString stringWithFormat:@",%@",targetString]])
//            self.firCondition = [self.firCondition stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@",targetString] withString:@""];
//        else if ([self.firCondition containsString:[NSString stringWithFormat:@"%@,",targetString]])
//            self.firCondition = [self.firCondition stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",targetString] withString:@""];
//        else if ([self.firCondition containsString:targetString])
//            self.firCondition = [self.firCondition stringByReplacingOccurrencesOfString:targetString withString:@""];
//        else self.firCondition = [NSString stringWithFormat:@"%@,%@",self.firCondition,targetString];
    }
    
    if (self.pageTye == 20) {
        if([self.secCondition isEqualToString:targetString]) self.secCondition = @"" ;
        else self.secCondition = targetString;
//        if ([self.secCondition isEqualToString:@""]) self.secCondition = targetString;
//        else if ([self.secCondition containsString:[NSString stringWithFormat:@",%@",targetString]])
//            self.secCondition = [self.secCondition stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@",targetString] withString:@""];
//        else if ([self.secCondition containsString:[NSString stringWithFormat:@"%@,",targetString]])
//            self.secCondition = [self.secCondition stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",targetString] withString:@""];
//        else if ([self.secCondition containsString:targetString])
//            self.secCondition = [self.secCondition stringByReplacingOccurrencesOfString:targetString withString:@""];
//        else self.secCondition = [NSString stringWithFormat:@"%@,%@",self.secCondition,targetString];
    }
    
    if (self.pageTye == 30) {
        
        if ([self.thiCondition isEqualToString:@""]) self.thiCondition = targetString;
        else if ([[self.thiCondition componentsSeparatedByString:@","] containsObject:targetString]) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:[self.thiCondition componentsSeparatedByString:@","]];
            [temp removeObject:targetString] ;
            self.thiCondition = ([temp count] == 0 ? @"":[temp componentsJoinedByString:@","]) ;
            temp = nil ;
        } else self.thiCondition = [NSString stringWithFormat:@"%@,%@",self.thiCondition,targetString];
    }
    
    [self.filterTableView reloadData];
}

- (void)getSourceData {
    
    if (self.pageTye == 10) {
        
        NSMutableArray *monthAry = [NSMutableArray array];
        
        for (NSDictionary *dic in self.originFilterData) {
            
            if (![monthAry containsObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"REPORT_SUBMIT_DATE"]]]) {
                [monthAry addObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"REPORT_SUBMIT_DATE"]]] ;
            }
        }
        self.dataSourceArray = [NSArray arrayWithArray:monthAry];
    }
    
    if (self.pageTye == 20) {
        
        NSMutableArray *campaignAry = [NSMutableArray array];
        
        for (NSDictionary *dic in self.originFilterData) {
            
            if ((![self.firCondition isEqualToString:@""]&&[self.firCondition containsString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"REPORT_SUBMIT_DATE"]]])||[self.firCondition isEqualToString:@""]) {
                
                if (![campaignAry containsObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"CAMPAIGN_ID"]]]) {
                    [campaignAry addObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"CAMPAIGN_ID"]]] ;
                }
            }
        }
        self.dataSourceArray = [NSArray arrayWithArray:campaignAry];
        
        if (![self.secCondition isEqualToString:@""]) {

            if (![self.dataSourceArray containsObject:self.secCondition]) self.secCondition = @"" ;
//            NSMutableArray *sepertAry = [NSMutableArray array];
//            NSArray *tempAry = [self.secCondition componentsSeparatedByString:@","] ;
//            for (NSString *campaign in self.dataSourceArray) {
//                if ([tempAry containsObject:campaign]) {
//                    [sepertAry addObject:campaign] ;
//                }
//            }
//            self.secCondition = ([sepertAry count] == 0 ? @"" : [sepertAry componentsJoinedByString:@","]) ;
//            sepertAry = nil ;
//            tempAry = nil ;
        }
        campaignAry = nil ;
    }
    
    if (self.pageTye == 30) {
        
        NSMutableArray *formatAry = [NSMutableArray array];
        
        for (NSDictionary *dic in self.originFilterData) {
            
            if ((![self.firCondition isEqualToString:@""]&&[self.firCondition containsString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"REPORT_SUBMIT_DATE"]]])||[self.firCondition isEqualToString:@""]) {
                
                if ((![self.secCondition isEqualToString:@""]&&[self.secCondition containsString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"CAMPAIGN_ID"]]])||[self.secCondition isEqualToString:@""]) {
                    
                    if (![formatAry containsObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"STORE_FORMAT"]]]) {
                        [formatAry addObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"STORE_FORMAT"]]] ;
                    }
                }
            }
        }
        self.dataSourceArray = [NSArray arrayWithArray:formatAry];
        
        if (![self.thiCondition isEqualToString:@""]) {
            
            NSMutableArray *sepertAry = [NSMutableArray array];
            NSArray *tempAry = [self.thiCondition componentsSeparatedByString:@","] ;
            for (NSString *format in self.dataSourceArray) {
                if ([tempAry containsObject:format]) {
                    [sepertAry addObject:format] ;
                }
            }
            self.thiCondition = ([sepertAry count] == 0 ? @"" : [sepertAry componentsJoinedByString:@","]) ;
            sepertAry = nil ;
            tempAry = nil ;
        }
        formatAry = nil ;
    }
    
    [self.filterTableView reloadData] ;
}

- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGRect keyboardBounds =
    [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     CGRectValue];
    NSNumber *duration =
    [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve =
    [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0.0
                        options:[curve intValue]
                     animations:^{
                         CGRect aframe = self.filterBGView.frame ;
                         aframe.origin.y = DEHEIGHT - keyboardBounds.size.height - 71 ;
                         self.filterBGView.frame = aframe ;
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {

}

@end













