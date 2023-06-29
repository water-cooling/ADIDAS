//
//  ApplyDressViewController.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^InputReslutBlock)(NSDictionary * dict);

@interface ApplyDressViewController : BaseViewController
@property (nonatomic,copy)InputReslutBlock resultBlock;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic, strong) NSString* folderName;

@end

NS_ASSUME_NONNULL_END
