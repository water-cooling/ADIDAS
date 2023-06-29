//
//  NewsViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "BaseViewController.h"

@interface NewsViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataArray ;

@property (retain, nonatomic) IBOutlet UITableView *newsTableView;

@end
