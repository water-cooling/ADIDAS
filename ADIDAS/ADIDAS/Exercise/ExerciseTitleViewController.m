//
//  ExerciseTitleViewController.m
//  MobileApp
//
//  Created by 桂康 on 2021/4/27.
//

#import "ExerciseTitleViewController.h"

@interface ExerciseTitleViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ExerciseTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self ;
    CGRect frame = self.filterView.frame ;
    frame.size.height = [self.dataSourceAry count]*50 + 48 ;
    if (frame.size.height > PHONE_HEIGHT) {
        frame.size.height = PHONE_HEIGHT - 100 ;
    }
    self.filterView.frame = frame ;
    resultArray = [NSMutableArray array];
    if (self.oldString) {
        for (NSString *old in [self.oldString componentsSeparatedByString:@","]) {
            if ([self.dataSourceAry containsObject:old]) {
                [resultArray addObject:old];
            }
        }
    }
}


- (void)viewDidAppear:(BOOL)animated {

    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.filterView.frame ;
        frame.origin.y = PHONE_HEIGHT - frame.size.height ;
        self.filterView.frame = frame ;
    }];
}


- (IBAction)cancelAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.filterView.frame ;
        frame.origin.y = PHONE_HEIGHT ;
        self.filterView.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
    }];
}

- (IBAction)sureAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.filterView.frame ;
        frame.origin.y = PHONE_HEIGHT ;
        self.filterView.frame = frame ;
        
    } completion:^(BOOL finished) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(currentTitle:withIndex:)]) {
            [self.delegate currentTitle:[resultArray componentsJoinedByString:@","] withIndex:self.index];
        }
        [self dismissViewControllerAnimated:NO completion:nil] ;
    }];
}

- (IBAction)dismissView:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.filterView.frame ;
        frame.origin.y = PHONE_HEIGHT ;
        self.filterView.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil] ;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.dataSourceAry objectAtIndex:indexPath.row];
    if ([resultArray containsObject:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *current = [self.dataSourceAry objectAtIndex:indexPath.row];
    
    if ([current isEqualToString:@"Other"]||[current isEqualToString:@"其它"]) {
        [resultArray removeAllObjects];
        [resultArray addObject:current];
        [tableView reloadData];
        return;
    }
    
    if ([current isEqualToString:@"12课题"]||[current isEqualToString:@"12 topics"]) {
        [resultArray removeAllObjects];
        [resultArray addObject:current];
        [tableView reloadData];
        return;
    }
    
    if ([resultArray containsObject:@"Other"])[resultArray removeObject:@"Other"];
    if ([resultArray containsObject:@"其它"])[resultArray removeObject:@"其它"];
    if ([resultArray containsObject:@"12课题"])[resultArray removeObject:@"12课题"];
    if ([resultArray containsObject:@"12 topics"])[resultArray removeObject:@"12 topics"];
    
    if ([resultArray containsObject:current]) {
        [resultArray removeObject:current];
    } else {
        [resultArray addObject:current];
    }
    [tableView reloadData];
}


@end
