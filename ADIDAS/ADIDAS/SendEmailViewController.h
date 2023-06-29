//
//  SendEmailViewController.h
//  StoreVisitPack
//
//  Created by 桂康 on 2020/3/23.
//  Copyright © 2020 joinone. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SendEmailDelegate <NSObject>

- (void)updateComment:(NSString *)comment withIndex:(NSUInteger)index;

@end

@interface SendEmailViewController : BaseViewController

@property (assign, nonatomic) NSUInteger *index;
@property (strong, nonatomic) NSString *commentInfo;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *targetView;
@property (assign, nonatomic) id<SendEmailDelegate> delegate ;
@property (retain, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)dismissAction:(id)sender;
- (IBAction)sendAction:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *confirmButton;
@property (retain, nonatomic) IBOutlet UILabel *holderLabel;
@property (strong, nonatomic) NSString *mustType ;
@property (retain, nonatomic) IBOutlet UIImageView *midLine;

@end

NS_ASSUME_NONNULL_END
