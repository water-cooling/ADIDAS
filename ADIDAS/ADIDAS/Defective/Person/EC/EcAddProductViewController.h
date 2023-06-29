//
//  EcAddProductViewController.h
//  MobileApp
//
//  Created by Connor Gui on 2022/3/22.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EcAddProductViewController : BaseViewController

@property (retain, nonatomic) IBOutlet UITextField *transactionOrderTextField;
@property (retain, nonatomic) IBOutlet UITextField *typeTextField;

- (IBAction)ScanAction:(id)sender;
- (IBAction)selectTypeAction:(id)sender;
- (IBAction)clearAction:(id)sender;

@property (strong, nonatomic) NSMutableArray *videoArray;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSArray *webUrlArray;
@property (strong, nonatomic) NSArray *webVideoUrlArray;
@property (retain, nonatomic) IBOutlet UICollectionView *imageCollectView;
@property (strong, nonatomic) NSDictionary *dataDic;
@property (retain, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (retain, nonatomic) IBOutlet UICollectionView *videoCollectView;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
