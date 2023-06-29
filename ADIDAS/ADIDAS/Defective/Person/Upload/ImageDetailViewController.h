//
//  ImageDetailViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "BaseViewController.h"


@protocol DeleteSelectImageDelegate <NSObject>

- (void)DeleteSelectImageWith:(NSInteger)index ;

@end

@interface ImageDetailViewController : BaseViewController

@property (strong, nonatomic) NSDictionary *infoDic ;
@property (assign, nonatomic) id<DeleteSelectImageDelegate> DeleteDelegate ;
@property (strong, nonatomic) NSString *imageData ;
@property (strong, nonatomic) NSString *trainingPath ;
@property (assign, nonatomic) NSInteger index ;

@property (weak, nonatomic) IBOutlet UIImageView *DetailImage;
@property (weak, nonatomic) IBOutlet UIButton *DeleteButton;

- (IBAction)TapCloseView:(id)sender;
- (IBAction)DeleteAction:(id)sender;


@end
