//
//  DefectiveCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "DefectiveCustomCell.h"
#import "CommonUtil.h"

@implementation DefectiveCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.defectiveTextView.delegate = self ;
    self.placeHoladLabel.textColor = [CommonUtil colorWithHexString:@"#c7c7cd"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidChange:(UITextView *)textView {

    self.placeHoladLabel.hidden = ![textView.text isEqualToString:@""] ;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"SCROLLTOPTABLEVIEW" object:nil];
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

@end
