//
//  ScoreCustomCell.h
//  MobileApp
//
//  Created by 桂康 on 2021/4/14.
//

#import <UIKit/UIKit.h>

@protocol ScoreTableDelegate <NSObject>

- (void)selectTableWith:(NSUInteger)index withResult:(nonnull NSString *)result;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ScoreCustomCell : UITableViewCell

@property (assign, nonatomic) id<ScoreTableDelegate>delegate;
@property (assign, nonatomic) NSUInteger idx;
@property (retain, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *yesBtn;
@property (retain, nonatomic) IBOutlet UIButton *noBtn;
@property (retain, nonatomic) IBOutlet UIButton *NABtn;


@property (retain, nonatomic) IBOutlet UIView *naView;
@property (retain, nonatomic) IBOutlet UIView *normalView;
@property (retain, nonatomic) IBOutlet UILabel *NALabel;



- (IBAction)naAction:(id)sender;
- (IBAction)yesAction:(id)sender;
- (IBAction)noAction:(id)sender;



@end

NS_ASSUME_NONNULL_END
