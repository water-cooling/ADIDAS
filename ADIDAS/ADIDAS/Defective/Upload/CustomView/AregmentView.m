//
//  CourseSearchView.m
//  BankRecruitment
//
//  Created by yltx on 2022/12/11.
//

#import "AregmentView.h"
#import "CommonUtil.h"
@interface AregmentView ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *titLab;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic, assign) NSInteger lastIndex;


@end

@implementation AregmentView


-(instancetype)initAlerShoeView{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self initUI];
    }
    
    return self;
}

-(void)initUI{
    self.bgView = [UIView new];
    self.bgView.layer.cornerRadius = 20;
    [self addSubview:self.bgView];
    self.lastIndex =0;
    self.titLab = [[UILabel alloc]init];
    self.titLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];

    NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:@"仅限于贵司新到货鞋盒吊牌问题反馈，是否继续登录？"];
    [titleAttributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(5, 3)];
    self.titLab.attributedText = titleAttributeString;
    self.titLab.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.titLab];
        
    CGFloat wdith = (PHONE_WIDTH-70)/2;
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancelBtn.layer.cornerRadius = 15;
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = [CommonUtil colorWithHexString:@"#DCDEE0"].CGColor;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:_cancelBtn];
    
    _sureBtn = [[UIButton alloc] init];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.layer.cornerRadius = 15;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _sureBtn.backgroundColor = [CommonUtil colorWithHexString:@"#2355E6"];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:_sureBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(PHONE_WIDTH-20, 140));
            
    }];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.bgView).offset(22);
            
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(15);
        make.bottom.equalTo(self.bgView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(wdith, 40));

    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.centerY.equalTo(self.cancelBtn);
        make.size.mas_equalTo(CGSizeMake(wdith, 40));
    }];
    
}


-(void)sureAction{
    if (self.sureBlock) {
        self.sureBlock();
    }
    [self dismissAlertView];
}
-(void)cancelAction{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissAlertView];
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    self.bgView.backgroundColor = [UIColor clearColor];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.transform = transform;
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}



@end
