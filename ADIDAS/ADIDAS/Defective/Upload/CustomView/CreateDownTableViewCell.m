//
//  CreateDownTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import "CreateDownTableViewCell.h"
#import "CommonUtil.h"

@implementation CreateDownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIButton * downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setImage:[UIImage imageNamed:@"productdetail_down.png"] forState:0];
    downBtn.frame = CGRectMake(0, 0, 30, 30);
    self.inputTextView.layer.cornerRadius = 5;
    [downBtn addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    self.inputTextView.layer.borderColor = [[CommonUtil colorWithHexString:@"#F5F5F5"] CGColor];
    self.inputTextView.layer.borderWidth =1;
    self.inputTextView.rightView = downBtn;
    self.inputTextView.delegate = self;
    self.inputTextView.rightViewMode =  UITextFieldViewModeAlways;
    // Initialization code
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.block) {
        self.block();
    }
    return NO;
}

-(void)touchAction{
    if (self.block) {
        self.block();
    }
}

-(void)setDict:(NSMutableDictionary *)dict{
    _dict = dict;
    if (dict[self.creatTableModel.key]) {
        self.inputTextView.text = dict[self.creatTableModel.key];
    }else{
        self.inputTextView.text = @"";
    }
}

-(void)setCreatTableModel:(CreatTableModel *)creatTableModel{
    _creatTableModel = creatTableModel;
    if (creatTableModel) {
        self.leftLabel.text = creatTableModel.title;
        self.inputTextView.placeholder = creatTableModel.placeholder;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
