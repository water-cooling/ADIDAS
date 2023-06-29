//
//  EditViewController.h
//  SuperviseClient
//
//  Created by 桂康 on 2017/3/2.
//  Copyright © 2017年 JoinOnesoft. All rights reserved.
//

#import "BaseViewController.h"

@protocol EditDelegate <NSObject>

@optional
- (void)FinishEditWith:(NSString *)text andIndex:(NSInteger)index;
- (void)FinishEditWith:(NSString *)text andIndex:(NSInteger)index andPosition:(int)position;

@end

@interface EditViewController : BaseViewController<UITextViewDelegate,UITextFieldDelegate>

@property (assign, nonatomic) NSInteger index ;
@property (strong, nonatomic) NSString *type ;
@property (weak, nonatomic) IBOutlet UIScrollView *BGScrollView;
@property (assign, nonatomic) id<EditDelegate> delegate ;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (assign, nonatomic) BOOL isShowdKeyBoard ;
@property (weak, nonatomic) IBOutlet UIView *wordView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextView *wordTextView;

@property (strong, nonatomic) NSString *textVal ;
@property (assign, nonatomic) int position ;



- (IBAction)numberAction:(id)sender;
- (IBAction)wordAction:(id)sender;
- (IBAction)tapBGAction:(id)sender;


@end
