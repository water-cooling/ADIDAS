//
//  TapLongPressImageView.h
//  ADIDAS
//
//  Created by wendy on 14-5-21.
//
//

#import <UIKit/UIKit.h>

@protocol TapLongPressImageViewDelegate <NSObject>

-(void)takePic:(id)sender;
-(void)deletePic:(id)sender;

@end

@interface TapLongPressImageView : UIImageView
@property (weak,nonatomic) id<TapLongPressImageViewDelegate> delegate;

@end
