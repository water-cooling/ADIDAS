//
//  ShoeOrderDetailViewController.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/7.
//

#import <UIKit/UIKit.h>
#import "NewApplyViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShoeOrderDetailViewController : UIViewController
@property (nonatomic, assign) ShoesType detailType;
@property (nonatomic,strong)NSDictionary *saveDic;
@end

NS_ASSUME_NONNULL_END
