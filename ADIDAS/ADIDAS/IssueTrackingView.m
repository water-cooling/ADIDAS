//
//  IssueTrackingView.m
//  MobileApp
//
//  Created by 桂康 on 2020/12/2.
//

#import "IssueTrackingView.h"
#import "TrackingCustomCell.h"
#import "CommonUtil.h"
#import "Utilities.h"
#import "UIImageView+YYWebImage.h"
#import "CommonDefine.h"
#import "SqliteHelper.h"

@implementation IssueTrackingView 

- (void)awakeFromNib {
    [super awakeFromNib];
    self.trackingTableView.dataSource = self;
    self.trackingTableView.delegate = self ;
    self.trackingTableView.tableFooterView = [[UIView alloc] init];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        NSString *txt = [NSString stringWithFormat:@"%@",[[self getDataSource] valueForKey:@"COMMENT"]];
        float height = [self heightForString:txt fontSize:15 andWidth:PHONE_WIDTH - 32];
        return (height+15) + 48;
    }
    
    if (indexPath.row == 2) {
        NSString *txt = [NSString stringWithFormat:@"%@",[[self getDataSource] valueForKey:@"STATUS"]];
        float height = [self heightForString:txt fontSize:15 andWidth:PHONE_WIDTH - 32];
        return (height+15) + 48;
    }
    
    if (indexPath.row == 3) {
        NSString *txt  = [NSString stringWithFormat:@"%@",[[self getDataSource] valueForKey:@"TRACKING_COMMENT"]];
        float height = [self heightForString:txt fontSize:15 andWidth:PHONE_WIDTH - 32];
        return (height+15) + 48;
    }
    
    if (indexPath.row == 4) {
        return 48 + 115 + 10;
    }
    return 48 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    TrackingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibarray = [[NSBundle mainBundle] loadNibNamed:@"TrackingCustomCell" owner:self options:nil];
        for (UIView *view in nibarray) {
            if ([view isKindOfClass:[TrackingCustomCell class]]) {
                cell = (TrackingCustomCell *)view ;
                break ;
            }
        }
    }
    
    cell.rightShowImageView.hidden = YES ;
    cell.downDetailLabel.hidden = YES ;
    cell.descriptionTextView.hidden = YES ;
    cell.descriptionHintLabel.hidden = YES ;
    cell.issueSwitch.hidden = YES ;

    if (indexPath.row == 0) {
        cell.rightShowImageView.hidden = NO ;
        cell.leftTitleLabel.text = @"问题图片：" ;
        [cell.rightShowImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[[[self getDataSource] valueForKey:@"INITIAL_PHOTO_PATH"] stringByReplacingOccurrencesOfString:@"~" withString:@""]]] placeholder:nil] ;
    }
    
    if (indexPath.row == 1) {
        cell.downDetailLabel.hidden = NO ;
        cell.leftTitleLabel.text = @"问题描述：" ;
        cell.downDetailLabel.text = [NSString stringWithFormat:@"%@",[[self getDataSource] valueForKey:@"COMMENT"]];
    }
    
    if (indexPath.row == 2) {
        cell.downDetailLabel.hidden = NO ;
        cell.leftTitleLabel.text = @"跟踪状态：" ;
        cell.downDetailLabel.text = [NSString stringWithFormat:@"%@",[[self getDataSource] valueForKey:@"STATUS"]];
    }
    
    if (indexPath.row == 3) {
        cell.downDetailLabel.hidden = NO ;
        cell.leftTitleLabel.text = @"跟踪描述：" ;
        cell.downDetailLabel.text = [NSString stringWithFormat:@"%@",[[self getDataSource] valueForKey:@"TRACKING_COMMENT"]];
    }
    
    if (indexPath.row == 4) {
        cell.descriptionTextView.hidden = NO ;
        cell.leftTitleLabel.text = @"输入最新备注：" ;
        cell.descriptionTextView.text = [[self getDataSource] valueForKey:@"REMARK"]?[NSString stringWithFormat:@"%@",[[self getDataSource] valueForKey:@"REMARK"]]:@"";
        if ([cell.descriptionTextView.text isEqualToString:@""]) {
            cell.descriptionHintLabel.hidden = NO ;
        } else {
            cell.descriptionHintLabel.hidden = YES ;
        }
    }
    
    if (indexPath.row == 5) {
        cell.issueSwitch.hidden = NO ;
        cell.leftTitleLabel.text = @"是否完成：" ;
        cell.issueSwitch.on = [[NSString stringWithFormat:@"%@",[[self getDataSource] valueForKey:@"TRACKING_STATUS"]] isEqualToString:@"1"];
        [cell.issueSwitch addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    CGRect rect = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                      context:nil];
    float height = rect.size.height ;
    return height ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showDetailImageView:)]) {
            [self.delegate showDetailImageView:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[[[self getDataSource] valueForKey:@"INITIAL_PHOTO_PATH"] stringByReplacingOccurrencesOfString:@"~" withString:@""]]];
        }
    }
    if (indexPath.row == 4) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(inputNewRemarkWithIndex:)]) {
            [self.delegate inputNewRemarkWithIndex:self.index];
        }
    }
}

- (NSArray *) getInitialData {
    
    NSString *sql = [NSString stringWithFormat:@"select * from NVM_IST_ISSUE_TRACKING_ITEM_LIST where IST_ISSUE_TRACKING_LIST_ID ='%@'",self.trackingId];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    NSMutableArray *item_lists = [NSMutableArray array];
    while ([rs next])
    {
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"IST_ISSUE_TRACKING_LIST_ID"]] forKey:@"IST_ISSUE_TRACKING_LIST_ID"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"ISSUE_TRACKING_CHECK_ID"]] forKey:@"ISSUE_TRACKING_CHECK_ID"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"COMMENT"]] forKey:@"COMMENT"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"INITIAL_PHOTO_PATH"]] forKey:@"INITIAL_PHOTO_PATH"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"ISSUE_TYPE"]] forKey:@"ISSUE_TYPE"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"IST_ISSUE_PHOTO_LIST_ID"]] forKey:@"IST_ISSUE_PHOTO_LIST_ID"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"STATUS"]] forKey:@"STATUS"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRACKING_COMMENT"]] forKey:@"TRACKING_COMMENT"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRACKING_STATUS"]] forKey:@"TRACKING_STATUS"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRACKING_TIME"]] forKey:@"TRACKING_TIME"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"USER_NAME_CN"]] forKey:@"USER_NAME_CN"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"REMARK"]] forKey:@"REMARK"];
        [item_lists addObject:item];
    }
    return item_lists;
}

- (NSArray *) getDataSource {
    
    if (!dataSourceArray || dataSourceArray.count == 0) {
        dataSourceArray = [NSArray arrayWithArray:[self getInitialData]];
    }
    return [dataSourceArray firstObject];
}

- (void)refreshView {
    dataSourceArray = nil;
    [self.trackingTableView reloadData];
    self.titleLabel.text = [NSString stringWithFormat:@"%d、%@",(int)self.index+1,[[self getDataSource] valueForKey:@"ISSUE_TYPE"]];
}

- (void)changeStatus:(UISwitch *)currSwitch {
    
    NSString *sql = [NSString stringWithFormat:@"update NVM_IST_ISSUE_TRACKING_ITEM_LIST set TRACKING_STATUS = '%@' where IST_ISSUE_TRACKING_LIST_ID ='%@' ",currSwitch.on?@"1":@"0",self.trackingId];
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    [db executeUpdate:sql];
    dataSourceArray = nil;
}

@end
