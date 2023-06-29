//
//  LargeImageView.h
//  ADIDAS
//
//  Created by wendy on 14-5-21.
//
//

#import <UIKit/UIKit.h>

#import "DACircularProgressView.h"

@protocol LargeImageViewDelegate <NSObject>

-(void)Hidden;

@end

@interface LargeImageView : UIView

@property (weak,nonatomic) IBOutlet UIImageView* imageview;
@property (weak,nonatomic) id<LargeImageViewDelegate> delegate;
@property (strong,nonatomic) DACircularProgressView* progressview;

-(void)updateProgress:(CGFloat)progress;


@end
