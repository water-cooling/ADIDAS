//
//  AlerPointPicView.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlerPointPickView : UIView

-(void)show;
-(instancetype)initAlerPointPickView;
@property (nonatomic,copy)dispatch_block_t sureBlock;
-(void)configTitle:(NSString *)title destitlte:(NSString *)desTitle pic:(NSString * )picStr;
@property (nonatomic,copy)dispatch_block_t block;

@end

NS_ASSUME_NONNULL_END
