//
//  NewUploadPicCustomCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/2.
//

#import <UIKit/UIKit.h>
#import "ImageDetailViewController.h"
#import "CommonDefine.h"
NS_ASSUME_NONNULL_BEGIN


@interface NewUploadPicCustomCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *webUrlArray ;
@property (strong, nonatomic) NSMutableArray *imageArray ;
@property (strong, nonatomic) NSString *foldName ;
@property (retain, nonatomic) IBOutlet UILabel *desTitle;

@property (retain, nonatomic) IBOutlet UICollectionView *ImageCollectView;

@property (nonatomic,copy)dispatch_block_t pickBlock;

@property (nonatomic,copy)ImageBigBlock bigBlock;

@property (nonatomic,copy)ImageDeleteBlock deleteBlock;

@end

NS_ASSUME_NONNULL_END
