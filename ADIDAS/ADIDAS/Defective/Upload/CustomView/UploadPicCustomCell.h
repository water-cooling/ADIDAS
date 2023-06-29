//
//  UploadPicCustomCell.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import <UIKit/UIKit.h>
#import "ImageDetailViewController.h"

@interface UploadPicCustomCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DeleteSelectImageDelegate>

@property (strong, nonatomic) NSArray *webUrlArray ;
@property (strong, nonatomic) NSMutableArray *imageArray ;
@property (strong, nonatomic) NSString *foldName ;

@property (retain, nonatomic) IBOutlet UICollectionView *ImageCollectView;
@property (strong, nonatomic) BaseViewController *vc ;

@end
