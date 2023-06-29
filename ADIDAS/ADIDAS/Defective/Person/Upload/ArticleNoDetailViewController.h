//
//  ArticleNoDetailViewController.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/4.
//

#import <UIKit/UIKit.h>
#import "ApplyShoesViewController.h"
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArticleNoDetailViewController : BaseViewController

@property (nonatomic, assign) NewDetailType detailType;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
