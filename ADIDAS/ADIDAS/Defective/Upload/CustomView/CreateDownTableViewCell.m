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
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 18)];
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"productdetail_down.png"]];
    image.frame = CGRectMake(2, 2, 15, 15);
    [leftView addSubview:image];
    self.inputTextView.delegate = self;
    self.inputTextView.layer.cornerRadius = 5;
    self.inputTextView.layer.borderColor = [[CommonUtil colorWithHexString:@"#F5F5F5"] CGColor];
    self.inputTextView.layer.borderWidth =1;
    self.inputTextView.rightView = leftView;
    self.inputTextView.rightViewMode =  UITextFieldViewModeAlways;
    // Initialization code
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.block) {
        self.block();
    }
    return NO;
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
