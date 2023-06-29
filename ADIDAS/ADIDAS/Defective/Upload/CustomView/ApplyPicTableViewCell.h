//
//  ApplyPicTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>
#import "CommonDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyPicTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *imageArray ;
@property (strong, nonatomic) NSArray *webUrlArray ;

@property (nonatomic,copy)dispatch_block_t pickBlock;

@property (nonatomic,copy)ImageBigBlock bigBlock;

@property (nonatomic,copy)ImageDeleteBlock deleteBlock;
@end

NS_ASSUME_NONNULL_END
