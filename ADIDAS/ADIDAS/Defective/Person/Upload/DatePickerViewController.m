//
//  DatePickerViewController.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/26.
//
//

#import "DatePickerViewController.h"
#import "CommonUtil.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    @try {
        
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        self.datePicker.dataSource = self ;
        self.datePicker.delegate = self ;
        
        NSMutableArray *dataAry = [NSMutableArray array];
        
        
        int year = [[[[CommonUtil NSDateToNSString:[NSDate date]] componentsSeparatedByString:@"-"] firstObject] intValue] - 7 ;
        
        for (int i = 0 ; i < 8 ; i++) {
            
            [dataAry addObject:[NSString stringWithFormat:@"%d年",year+i]] ;
        }
        
        self.yearArray = [NSArray arrayWithArray:dataAry];
        
        int month = [[[[CommonUtil NSDateNoTimeToNSString:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
        
        [dataAry removeAllObjects];
        
        for (int i = 1 ; i <= month ; i++) {
            
            [dataAry addObject:[NSString stringWithFormat:@"%d月",i]] ;
        }
        
        self.monthArray = [NSArray arrayWithArray:dataAry];
        
        [dataAry removeAllObjects];
        
        if (!dataAry) dataAry = [NSMutableArray array] ;
        
        [dataAry addObject:@"-"] ;
        
        int maxDay = 31 ;
        
        if (month == 1) maxDay = [[[[CommonUtil NSDateNoTimeToNSString:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue];
        
        for (int i = 0 ; i < maxDay ; i++) {
            
            [dataAry addObject:[NSString stringWithFormat:@"%d日",1+i]] ;
        }
        
        self.dayArray = [NSArray arrayWithArray:dataAry];
        
        [self.datePicker selectRow:[self.yearArray count]-1 inComponent:0 animated:YES];
    } @catch (NSException *exception) {
    }
}



- (void)viewDidAppear:(BOOL)animated {

    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.datePickView.frame ;
        frame.origin.y = PHONE_HEIGHT - 208 ;
        self.datePickView.frame = frame ;
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3 ;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0)  return [self.yearArray count] ;
    
    if (component == 1)  return [self.monthArray count] ;
    
    if (component == 2)  return [self.dayArray count] ;
    
    return 0 ;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 0) return 100 ;
    
    return 80 ;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    @try {
        int currentYear ;
        int currentMonth ;
        
        if (component == 0) {
            
            currentYear = [[[[self.yearArray objectAtIndex:row] componentsSeparatedByString:@"年"] firstObject] intValue];
            
            int maxYear = [[[[CommonUtil NSDateNoTimeToNSString:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
            
            NSMutableArray *dataAry = [NSMutableArray array];
            
            if (currentYear == maxYear) {
                
                int month = [[[[CommonUtil NSDateNoTimeToNSString:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
                
                for (int i = 1 ; i <= month ; i++) {
                    
                    [dataAry addObject:[NSString stringWithFormat:@"%d月",i]] ;
                }
                
                self.monthArray = [NSArray arrayWithArray:dataAry];
                
            } else self.monthArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
            
            @try {
                [pickerView reloadComponent:1];
                if ([self.monthArray count] > [pickerView selectedRowInComponent:1]) {
                    currentMonth = [[[[self.monthArray objectAtIndex:[pickerView selectedRowInComponent:1]] componentsSeparatedByString:@"月"] firstObject] intValue];
                } else {
                    currentMonth = 1;
                    [pickerView selectRow:0 inComponent:1 animated:YES];
                }
            } @catch (NSException *exception) {}
        }
        
        if (component == 1) {
            
            currentMonth = [[[[self.monthArray objectAtIndex:row] componentsSeparatedByString:@"月"] firstObject] intValue];
            
            currentYear = [[[[self.yearArray objectAtIndex:[pickerView selectedRowInComponent:0]] componentsSeparatedByString:@"年"] firstObject] intValue];
        }
        
        if (component != 2 && currentYear != 0 && currentMonth != 0) {
            
            int totalCount = 30 ;
            
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12) {
                
                totalCount = 31 ;
            }
            
            if (currentMonth == 2) totalCount = 28 ;
            
            if (currentMonth == 2 && currentYear%4 == 0) {
                
                totalCount = 29 ;
                
                if ((currentYear % 100 == 0 && currentYear % 400 != 0) || currentYear % 3200 == 0) totalCount = 28 ;
            }
            
            NSMutableArray *dataAry = [NSMutableArray array] ;
            
            [dataAry addObject:@"-"] ;
            
            int month = [[[[CommonUtil NSDateNoTimeToNSString:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
            
            int year = [[[[CommonUtil NSDateNoTimeToNSString:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
            
            if (month == currentMonth&&currentYear == year) totalCount = [[[[CommonUtil NSDateNoTimeToNSString:[NSDate date]] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue];
            
            for (int i = 0 ; i < totalCount ; i++) {
                
                [dataAry addObject:[NSString stringWithFormat:@"%d日",1+i]] ;
            }
            
            self.dayArray = [NSArray arrayWithArray:dataAry] ;
            
            [pickerView reloadComponent:2];
        }
        
    } @catch (NSException *exception) {
    }
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) return [self.yearArray objectAtIndex:row];
    
    if (component == 1) return [self.monthArray objectAtIndex:row];
    
    if (component == 2) return [self.dayArray objectAtIndex:row];
    
    return @"" ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)operateAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender ;
    
    if (btn.tag == 20) {
        
        NSString *year = [[[self.yearArray objectAtIndex:[self.datePicker selectedRowInComponent:0]] componentsSeparatedByString:@"年"] firstObject];
        
        
        NSString *month = [[[self.monthArray objectAtIndex:[self.datePicker selectedRowInComponent:1]] componentsSeparatedByString:@"月"] firstObject];
        
        if ([month length] == 1) month = [NSString stringWithFormat:@"0%@",month] ;
        
        
        NSString *day = [[[self.dayArray objectAtIndex:[self.datePicker selectedRowInComponent:2]] componentsSeparatedByString:@"日"] firstObject];
        
        if ([day isEqualToString:@"-"]) day = @"" ;
        
        else if ([day length] == 1) day = [NSString stringWithFormat:@"-0%@",day] ;
            
        else day = [NSString stringWithFormat:@"-%@",day] ;
        
        [self.delegate currentDate:[NSString stringWithFormat:@"%@-%@%@",year,month,day]] ;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.datePickView.frame ;
        frame.origin.y = PHONE_HEIGHT ;
        self.datePickView.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
    }];
}


- (IBAction)tabBGView:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.datePickView.frame ;
        frame.origin.y = PHONE_HEIGHT ;
        self.datePickView.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
    }];
}

@end








