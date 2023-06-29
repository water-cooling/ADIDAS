//
//  WaittingUploadViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/26.
//
//

#import "BaseViewController.h"

@interface WaittingUploadViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *recordTableView;
@property (strong, nonatomic) NSArray *dataArray ;
@property (assign, nonatomic) int currentIndex ;


@end
