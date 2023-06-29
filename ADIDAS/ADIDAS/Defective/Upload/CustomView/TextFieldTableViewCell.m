//
//  TextFieldTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import "TextFieldTableViewCell.h"
#import "CommonUtil.h"

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputTextView.layer.cornerRadius = 5;
    self.inputTextView.layer.borderColor = [[CommonUtil colorWithHexString:@"#F5F5F5"] CGColor];
    self.inputTextView.layer.borderWidth =1;
    self.inputTextView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:self.inputTextView];

    // Initialization code
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self.creatTableModel.key isEqualToString:@"CartonNumber"]) {
        NSInteger strLength = textField.text.length - range.length + string.length;

        return (strLength <= 3);
    }
    return YES;
}

//将输入的内容保存到formDict里面
- (void)textFieldValueChanged:(NSNotification *)note{
    if (self.textBlock) {
        self.textBlock(self.inputTextView.text);
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
        if (creatTableModel.isNumerKeyBoard) {
            self.inputTextView.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            self.inputTextView.keyboardType = UIKeyboardTypeDefault;

            
        }
        self.leftLabel.text = creatTableModel.title;
        self.inputTextView.placeholder = creatTableModel.placeholder;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_leftLabel release];
    [_inputTextView release];
    [super dealloc];
}
@end
