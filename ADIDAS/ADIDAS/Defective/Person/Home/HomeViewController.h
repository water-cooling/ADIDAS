//
//  HomeViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/14.
//
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>

{
    NSInteger filterType ;
    
    NSArray *firstArray ;
    NSArray *secondArray ;
    NSArray *thirdArray ;
    NSArray *fourthArray ;
    NSArray *fifthArray ;
}

@property (assign, nonatomic) int currentIndex ;
@property (strong, nonatomic) NSTimer *timer ;

@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UIView *searchBGView;
@property (retain, nonatomic) IBOutlet UIScrollView *listScrollView;
@property (retain, nonatomic) IBOutlet UITableView *firTableView;
@property (retain, nonatomic) IBOutlet UITableView *secTableView;
@property (retain, nonatomic) IBOutlet UITableView *thiTableView;
@property (retain, nonatomic) IBOutlet UITableView *fouTableView;
@property (retain, nonatomic) IBOutlet UITableView *fifTableView;
@property (retain, nonatomic) IBOutlet UIView *PageMenusView;

- (IBAction)filterAction:(id)sender;
- (IBAction)searchAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *secondView;





@end
