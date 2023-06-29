//
//  IssueTrackingView.h
//  MobileApp
//
//  Created by 桂康 on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TapImageDelegate <NSObject>

@optional
- (void)showDetailImageView:(NSString *)path;
- (void)inputNewRemarkWithIndex:(NSUInteger)index;

@end

@interface IssueTrackingView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataSourceArray;
}

@property (strong, nonatomic) NSString *trackingId ;
@property (assign, nonatomic) id<TapImageDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITableView *trackingTableView;
@property (assign, nonatomic) NSUInteger index ;

- (void)refreshView ;

@end

NS_ASSUME_NONNULL_END
