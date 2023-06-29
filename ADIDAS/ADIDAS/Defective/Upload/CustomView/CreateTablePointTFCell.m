//
//  CreateTablePoinTFCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import "CreateTablePointTFCell.h"
#import "CommonUtil.h"
@implementation CreateTablePointTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputTextfield.layer.cornerRadius = 5;
    self.inputTextfield.layer.borderColor = [[CommonUtil colorWithHexString:@"#F5F5F5"] CGColor];
    self.inputTextfield.layer.borderWidth =1;
    self.inputTextfield.rightViewMode =  UITextFieldViewModeAlways;
    // Initialization code
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:self.inputTextfield];
    
}
-(void)setDict:(NSMutableDictionary *)dict{
    _dict = dict;
    if (dict[self.creatTableModel.key]) {
        self.inputTextfield.text = dict[self.creatTableModel.key];
    }else{
        self.inputTextfield.text = @"";
    }
}


-(void)setCreatTableModel:(CreatTableModel *)creatTableModel{
    _creatTableModel = creatTableModel;
    if (creatTableModel) {
        self.titleLab.text = creatTableModel.title;
        self.inputTextfield.placeholder = creatTableModel.placeholder;
    }
}

//将输入的内容保存到formDict里面
- (void)textFieldValueChanged:(NSNotification *)note{
    if (self.textBlock) {
        self.textBlock(self.inputTextfield.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)pointAction:(id)sender {
    if (self.pointBlock) {
        self.pointBlock();
    }
}

@end
