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
    self.textView.delegate = self ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHodleLab.hidden = ![textView.text isEqualToString:@""] ;
    if (self.textBlock) {
        self.textBlock(textView.text);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder] ;
        
        return NO ;
    }
    
    NSString *str1 = @"&" ;
    NSString *str2 = @"<" ;
    NSString *str3 = @"/>";
    NSString *str4 = @"'" ;
    NSString *str5 = @"\"";
    NSString *str6 = @">" ;
    
    return !([text isEqualToString:str1]||[text isEqualToString:str2]||[text isEqualToString:str3]||
            [text isEqualToString:str4]||[text isEqualToString:str5]||[text isEqualToString:str6]) ;
}


- (void)dealloc {
    [_textView release];
    [_placeHodleLab release];
    [_titleLab release];
    [super dealloc];
}
@end
