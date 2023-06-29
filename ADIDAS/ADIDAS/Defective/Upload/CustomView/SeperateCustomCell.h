//
//  SeperateCustomCell.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/20.
//
//

#import <UIKit/UIKit.h>

@protocol OperateDelegate <NSObject>

- (void)operateType:(int)type withIndex:(NSInteger)index;

@end

@interface SeperateCustomCell : UITableViewCell


@property (assign, nonatomic) id<OperateDelegate> delegate ;
@property (assign, nonatomic) NSInteger index ;


@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *bgLineLabel;
@property (retain, nonatomic) IBOutlet UIView *openBGView;
@property (retain, nonatomic) IBOutlet UIView *closeBGView;
@property (retain, nonatomic) IBOutlet UILabel *closeDateLabel;


- (IBAction)closeAction:(id)sender;
- (IBAction)openAction:(id)sender;



@end
