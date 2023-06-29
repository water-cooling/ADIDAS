//
//  EditTableViewCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "EditTableViewCell.h"

@implementation EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rightTextField.delegate = self ;
    self.regionTextField.delegate = self ;
    self.phoneTextField.delegate = self ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueType:(NSString *)valueType {

    self.leftLabel.text = [NSString stringWithFormat:@"%@:",valueType] ;
    
    if ([valueType isEqualToString:@"货号"]) {
        
        [self.rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.rightTextField.keyboardType = UIKeyboardTypeASCIICapable;
        valueType = @"货号(请输入大写字母)" ;
    }
    
    if ([valueType isEqualToString:@"工单号"]) self.leftLabel.text = @"工单号 (选填):" ;
    
    if ([valueType isEqualToString:@"门店负责人手机号"]) valueType = @"负责人手机号" ;
    
    if ([valueType isEqualToString:@"负责人手机号"] || [valueType isEqualToString:@"门店电话"]) {
        
        self.rightTextField.keyboardType = UIKeyboardTypePhonePad ;
    }
    
    if ([valueType isEqualToString:@"数量"]) {
        
        self.rightTextField.keyboardType = UIKeyboardTypeNumberPad ;
        NSString *oldstr = [NSString stringWithFormat:@"%@:(一张申请单只可提交一件产品)",valueType] ;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:oldstr];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange([NSString stringWithFormat:@"%@:",valueType].length, @"(一张申请单只可提交一件产品)".length)];
        self.leftLabel.attributedText = text;
    }
    
    self.rightTextField.enabled = ![valueType isEqualToString:@"购买日期"] ;
    
    self.rightTextField.placeholder = [NSString stringWithFormat:@"请输入%@",valueType];
    
    if ([valueType isEqualToString:@"购买日期"]) self.rightTextField.placeholder = [NSString stringWithFormat:@"请选择购买日期"];
}

- (void)activeTextField {
    
    [self.phoneTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder] ;
    
    return NO ;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.regionTextField) {
        
        if (![string isEqualToString:@""]&&![@"0123456789" containsString:string]) return NO ;
        
        NSInteger strLength = textField.text.length - range.length + string.length;
        
        if (strLength >= 4) [self performSelector:@selector(activeTextField) withObject:nil afterDelay:0.1];
        
        return (strLength <= 4);
    }
    
    if (textField == self.phoneTextField) {
        
        if (![string isEqualToString:@""]&&![@"0123456789" containsString:string]) return NO ;
        
        NSInteger strLength = textField.text.length - range.length + string.length;
        
        return (strLength <= 9);
    }
    
    NSString *str1 = @"&" ;
    NSString *str2 = @"<" ;
    NSString *str3 = @"/>";
    NSString *str4 = @"'" ;
    NSString *str5 = @"\"";
    NSString *str6 = @">" ;
    
    if ([self.leftLabel.text isEqualToString:@"货号:"]&&![string isEqualToString:@""]&&![@"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" containsString:string]) return NO ;
    
    if ([self.leftLabel.text isEqualToString:@"尺码:"]&&![string isEqualToString:@""]&&![@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789./" containsString:string]) return NO ;
    
    if ([self.leftLabel.text isEqualToString:@"门店负责人手机号:"]) {
        
        if (![string isEqualToString:@""]&&![@"0123456789" containsString:string]) return NO ;
        
        NSInteger strLength = textField.text.length - range.length + string.length;
        
        return (strLength <= 11);
    }
    
    return !([string isEqualToString:str1]||[string isEqualToString:str2]||[string isEqualToString:str3]||
             [string isEqualToString:str4]||[string isEqualToString:str5]||[string isEqualToString:str6]) ;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if ([self.leftLabel.text isEqualToString:@"货号:"]) {
        
        if (textField.text.length > 6) {

            textField.text = [textField.text substringToIndex:6];
        }
    }
}


- (void)dealloc {
    [_reginView release];
    [_regionTextField release];
    [_phoneTextField release];
    [_rightLabel release];
    [super dealloc];
}


- (IBAction)longPressLabelAction:(UILongPressGestureRecognizer *)sender {
    
    [self.delegate longPressTap:self.rightLabel.text withLeftTitle:self.leftLabel.text];
}



@end















