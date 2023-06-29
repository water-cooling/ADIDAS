//
//  CustomSheetAlerView.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/2.
//

#import "CustomSheetAlerView.h"

 
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
 
#define JoopicActionSheetItemHeight 49
 
@interface CustomSheetAlerView ()<UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate>
 
@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , strong) NSArray *listData;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) UIView *customerView;
 
@end
 
@implementation CustomSheetAlerView
 
-(id)initWithList:(NSArray *)list title:(NSString *)title{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        CGFloat height = ScreenHeight*0.5 > JoopicActionSheetItemHeight * [list count] ?JoopicActionSheetItemHeight * [list count]: ScreenHeight*0.5;
        //table
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, height) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.scrollEnabled = YES;
        _tableview.layer.cornerRadius = 15;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        //取消按钮
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10,CGRectGetHeight(_tableview.frame)+8, ScreenWidth-20, JoopicActionSheetItemHeight)];
        cancelButton.layer.cornerRadius =15;
        cancelButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        cancelButton.userInteractionEnabled = YES;
        [cancelButton addGestureRecognizer:tapRecognizer];
        
 
        _customerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth,CGRectGetHeight(_tableview.frame)+ JoopicActionSheetItemHeight + 18)];
        _customerView.backgroundColor = [UIColor clearColor];
        [_customerView addSubview:_tableview];
        [_customerView addSubview:cancelButton];
        
        UIColor *lineColor = RGBACOLOR(0, 0, 0, 0.3);
        for(int i = 1 ;i<list.count;i++){
            UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(10,JoopicActionSheetItemHeight*i, ScreenWidth-20,0.5)];
            separateLine.backgroundColor = lineColor;
            [_customerView addSubview:separateLine];
        }
        
        
        [self addSubview:_customerView];
        
        
        _listData = list;
        _title = title;
        
    }
    return self;
}
 
//如果tableview处于uiview上面，uiview整个背景有点击事件，但是我们需要如果我们点击tableview的时候，处理tableview的点击事件，而不是uiview的事件。在这里，我们需要判断我们点击事件是否在uiview上还是在uitableview上。
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}
 
-(void)animeData{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        CGRect originRect = _customerView.frame;
        originRect.origin.y = ScreenHeight - CGRectGetHeight(_customerView.frame);
        _customerView.frame = originRect;
    } completion:^(BOOL finished) {
        
    }];
}
 
-(void) tappedCancel{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
        CGRect originRect = _customerView.frame;
        originRect.origin.y = ScreenHeight;
        _customerView.frame = originRect;
    } completion:^(BOOL finished) {
        if (finished) {
            for (UIView *v in _customerView.subviews) {
                [v removeFromSuperview];
            }
            [_customerView removeFromSuperview];
        }
    }];
}
 
- (void)showInView:(UIViewController *)controller{
    if (controller) {
        [controller.view addSubview:self];
    }else{
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }
    [self animeData];
}
 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JoopicActionSheetItemHeight;
}
 
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellIdentifier = @"TitleCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = _title;
        cell.textLabel.text = [_listData objectAtIndex:indexPath.row] ;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
 
        return cell;
}
 
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tappedCancel];
    if (self.block) {
        self.block(indexPath.row);
        return;
    }
}
 
@end
