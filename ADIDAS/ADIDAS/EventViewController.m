//
//  EventViewController.m
//  VM
//
//  Created by leo.you on 14-7-28.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "EventViewController.h"
#import "PlanDetailViewController.h"
#import "CommonDefine.h"
#import "Utilities.h"
#import "NSString+SBJSON.h"

@interface EventViewController ()

@end

@implementation EventViewController



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.eventArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.eventArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    self.superViewController.eventlabel.text = cell.textLabel.text;
    self.superViewController.planentity.TaskName = cell.textLabel.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventArray = [NSMutableArray new];
//    NSArray* arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"event"];
//    NSLog(@"%@",arr);
    [self.eventArray addObjectsFromArray:[CacheManagement instance].eventArr];
//    for (id obj in arr) {
//        [self.eventArray addObject:obj];
//    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
