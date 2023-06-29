//
//  UseGuideViewController.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UseGuideViewController : UIViewController

@property (nonatomic,strong)dispatch_block_t sureBlock;
@property (nonatomic,strong)dispatch_block_t cancelBlock;


@end

NS_ASSUME_NONNULL_END
