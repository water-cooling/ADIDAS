//
//  EditPicViewController.h
//  ADIDAS
//
//  Created by 桂康 on 15/11/18.
//
//

#import <UIKit/UIKit.h>
#import "ACEDrawingView.h"

@protocol selectPicDelegate <NSObject>

- (void)selectPicWith:(UIImage *)img ;

@end

@interface EditPicViewController : UIViewController<ACEDrawingViewDelegate,UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UIButton *clearButton;
@property (assign, nonatomic) BOOL isPushFrom ;
@property (assign, nonatomic) id<selectPicDelegate> delegate ;
@property (strong, nonatomic) UIImage *selectedImage ;
@property (retain, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (retain, nonatomic) IBOutlet ACEDrawingView *DrawImageView;
@property (retain, nonatomic) IBOutlet UIView *operateView;
@property (retain, nonatomic) IBOutlet UIButton *undoButton;
@property (retain, nonatomic) IBOutlet UIButton *redoButton;
@property (retain, nonatomic) IBOutlet UIButton *colorBtn;

- (IBAction)operationAction:(id)sender;

@end
