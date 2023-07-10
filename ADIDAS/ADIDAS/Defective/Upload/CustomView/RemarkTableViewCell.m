//
//  RemarkTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import "RemarkTableViewCell.h"

@implementation RemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldValueChanged:(NSNotification *)note{
    if (self.textBlock) {
        self.textBlock(self.textView.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder] ;
        
        return NO ;
    }
    
    NSString *str1 = @"&" ;
    NSString *str2 = @"<" ;
    NSString *str3 = @"/>";
    NSString *str4 = @"'" ;
    NSString *str5 = @"\"";
    NSString *str6 = @">" ;
    
    return !([string isEqualToString:str1]||[string isEqualToString:str2]||[string isEqualToString:str3]||
            [string isEqualToString:str4]||[string isEqualToString:str5]||[string isEqualToString:str6]) ;
}


- (void)dealloc {
    [_textView release];
    [_titleLab release];
    [super dealloc];
}
@end
