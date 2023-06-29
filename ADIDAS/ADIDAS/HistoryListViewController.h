//
//  HistoryListViewController.h
//  ADIDAS
//
//  Created by joinone on 15/1/26.
//
//

#import <UIKit/UIKit.h>

@interface HistoryListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *HistoryListTableView;
@property (strong, nonatomic) NSArray *ListArray ;

@end
