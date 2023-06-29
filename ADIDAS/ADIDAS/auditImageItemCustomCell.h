//
//  auditImageItemCustomCell.h
//  MobileApp
//
//  Created by 桂康 on 2021/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImageOperateDelegate <NSObject>

- (void)deleteImage:(NSUInteger) index;
- (void)detailImage:(NSUInteger) index;
- (void)commentImage:(NSUInteger) index;

@end

@interface auditImageItemCustomCell : UICollectionViewCell

@property (assign, nonatomic) NSUInteger index ;
@property (assign, nonatomic) id<ImageOperateDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIImageView *menuImageView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIView *topView;
@property (retain, nonatomic) IBOutlet UILabel *remindLabel;
@property (retain, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (retain, nonatomic) IBOutlet UIImageView *commentRemarkImageView;

- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;
- (IBAction)middleAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
