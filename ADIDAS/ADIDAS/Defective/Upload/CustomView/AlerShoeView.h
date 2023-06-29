//
//  AlerShoeView.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlerShoeView : UIView

-(void)show;
-(instancetype)initAlerShoeView;

@property (nonatomic,copy)dispatch_block_t sureBlock;

@property (nonatomic,copy)dispatch_block_t cancelBlock;

@end

NS_ASSUME_NONNULL_END
