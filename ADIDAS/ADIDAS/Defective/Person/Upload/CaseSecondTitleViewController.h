//
//  CaseSecondTitleViewController.h
//  MobileApp
//
//  Created by 桂康 on 2019/5/29.
//

#import "BaseViewController.h"

@protocol CaseSecondDelegate <NSObject>

- (void)finishSecondWith:(NSString *)result ;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CaseSecondTitleViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id<CaseSecondDelegate> delegate ;

@property (strong, nonatomic) NSString *firstTitleString ;

@property (retain, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) NSArray *dataAry ;


@end

NS_ASSUME_NONNULL_END
