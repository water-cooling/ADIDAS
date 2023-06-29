//
//  ReviewFilterViewController.h
//  MobileApp
//
//  Created by 桂康 on 2018/6/12.
//

#import <UIKit/UIKit.h>

@protocol ReviewFilterDelegate <NSObject>

@optional
- (void)changeFilterWithTag:(int)tag ;
- (void)confirmFilterAction:(NSString *)fir :(NSString *)sec :(NSString *)thi :(NSString *)fou pageType:(int)tpe ;
- (void)removeColor ;
@end

@interface ReviewFilterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (assign, nonatomic) int pageTye ;
@property (assign, nonatomic) id<ReviewFilterDelegate> delegate ;
@property (strong, nonatomic) NSArray *dataSourceArray ;

- (IBAction)dismissAllView:(id)sender;
- (IBAction)filterAction:(id)sender;
- (IBAction)dismissView:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *keywordTextField;
@property (retain, nonatomic) IBOutlet UITableView *filterTableView;
@property (retain, nonatomic) IBOutlet UIView *filterBGView;
- (IBAction)confrimAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIImageView *bgLineImage;

@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) NSArray *originFilterData ;
@property (strong, nonatomic) NSString *firCondition ;
@property (strong, nonatomic) NSString *secCondition ;
@property (strong, nonatomic) NSString *thiCondition ;
@property (strong, nonatomic) NSString *fourCondition ;

@end
