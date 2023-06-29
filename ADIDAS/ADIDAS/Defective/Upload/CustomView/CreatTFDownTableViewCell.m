//
//  CreatTFDownTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import "CreatTFDownTableViewCell.h"
#import "CommonUtil.h"
@implementation CreatTFDownTableViewCell

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
    self.inputTextView.rightViewMode =  UITextFieldViewModeAlways;
    // Initialization code
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:self.inputTextView];

// Initialization code
}

-(void)setDict:(NSMutableDictionary *)dict{
    _dict = dict;
    if (dict[self.creatTableModel.key]) {
        self.inputTextView.text = dict[self.creatTableModel.key];
    }
}

-(void)setCreatTableModel:(CreatTableModel *)creatTableModel{
    _creatTableModel = creatTableModel;
    if (creatTableModel) {
        self.leftLabel.text = creatTableModel.title;
        self.inputTextView.placeholder = creatTableModel.placeholder;
    }
}

//将输入的内容保存到formDict里面
- (void)textFieldValueChanged:(NSNotification *)note{
    if (self.textBlock) {
        self.textBlock(self.inputTextView.text);
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

@end
