//
//  CaseTitleViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2017/2/6.
//
//

#import "BaseViewController.h"

@protocol CaseDelegate <NSObject>

- (void)finishWith:(NSString *)result ;

@end

@interface CaseTitleViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id<CaseDelegate> delegate ;
@property (retain, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSDictionary *dataDic ;
@property (strong, nonatomic) NSMutableArray *caseTypeArray ;

@end
