//
//  NewApplyViewController.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    normalNoStickerShoesSZ,//普通鞋盒(不含贴纸苏州)
    normalNoStickerShoesTJ,//普通鞋盒(不含贴纸天津)
    specialNoStickerShoes,//特殊鞋盒(不含贴纸)
    normalStickerShoesSZ//普通鞋盒(含贴纸)
} ShoesType;

typedef void(^ResultBlock)(NSDictionary * dict);

@interface NewApplyViewController : BaseViewController
@property (nonatomic, assign) ShoesType type;
@property (nonatomic,copy)ResultBlock resultBlock;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic, strong) NSString* folderName;

@end

NS_ASSUME_NONNULL_END
