//
//  ExamTestAlerView.m
//  BankRecruitment
//
//  Created by yltx on 2022/12/16.
//

#import "AlerPointPickView.h"
#import "UIImage+Additions.h"
#import "UIImageView+YYWebImage.h"
#import "CommonDefine.h"
#import "CommonUtil.h"
@interface AlerPointPickView ()
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)UIImageView *teaImg;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *desTitleLab;
@property (nonatomic,strong)UIButton *cancelBtn;
@end

@implementation AlerPointPickView

-(instancetype)initAlerPointPickView{
    self = [super init];
    if (self) {
    self.frame = [UIScreen mainScreen].bounds;
    self.alertView = [[UIView alloc] init];
    [self addSubview:self.alertView];
    self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 16;
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(PHONE_WIDTH-64, 200));
        }];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.font =  [UIFont systemFontOfSize:16];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = [CommonUtil colorWithHexString:@"#333333"];
        [self.alertView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.alertView);
            make.top.equalTo(self.alertView).offset(20);
        }];
        
        self.desTitleLab = [[UILabel alloc] init];
        self.desTitleLab.font =  [UIFont systemFontOfSize:14];
        self.desTitleLab.textAlignment = NSTextAlignmentCenter;
        self.desTitleLab.textColor = [CommonUtil colorWithHexString:@"#2355E6"];
        [self.alertView addSubview:self.desTitleLab];
        [self.desTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.alertView);
            make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        }];
        
        self.teaImg = [[UIImageView alloc]init];
        [self.alertView addSubview:self.teaImg];
        [self.teaImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.alertView);
                    make.top.equalTo(self.desTitleLab).offset(21);
                    make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
      
        
        [self.alertView addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView).offset(10);
            make.right.right.equalTo(self.alertView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        
    }
    return self;
}

-(void)goExam{
    if(self.block){
        self.block();
        [self dismissAlertView];
    }
}

-(void)configTitle:(NSString *)title destitlte:(NSString *)desTitle pic:(NSString *)picStr{
    
    self.titleLab.text = title;
    self.desTitleLab.text = desTitle;
    
    [self.teaImg yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,picStr  ]] placeholder:nil] ;
    [self show];

}

-(void)show{
    
    self.alertView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertView.backgroundColor = [UIColor whiteColor];

        self.alertView.transform = transform;
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}


        
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
        [_cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
        }
        return _cancelBtn;
}


@end
