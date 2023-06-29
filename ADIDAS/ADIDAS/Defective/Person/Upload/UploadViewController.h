//
//  UploadViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "BaseViewController.h"

@interface UploadViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

{
    UIBarButtonItem *item ;
}

@property (strong, nonnull) NSArray *dataArray ;
@property (retain, nonatomic) IBOutlet UITableView *listTableView;


@end
