//
//  CreatTFPointDownTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import "CreatTFPointDownTableViewCell.h"
#import "CommonUtil.h"
@implementation CreatTFPointDownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIButton * downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setImage:[UIImage imageNamed:@"productdetail_down.png"] forState:0];
    downBtn.frame = CGRectMake(0, 0, 30, 30);
    self.inputTextfield.layer.cornerRadius = 5;
    [downBtn addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    self.inputTextfield.layer.borderColor = [[CommonUtil colorWithHexString:@"#F5F5F5"] CGColor];
    self.inputTextfield.layer.borderWidth =1;
    self.inputTextfield.rightView = downBtn;
    self.inputTextfield.rightViewMode =  UITextFieldViewModeAlways;
    // Initialization code
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:self.inputTextfield];
    // Initialization code
}
- (IBAction)pointAction:(id)sender {

    if (self.pointBlock) {
        self.pointBlock();
    }

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


-(void)touchAction{
    if (self.block) {
        self.block();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_titleLab release];
    [_inputTextfield release];
    [super dealloc];
}
@end
