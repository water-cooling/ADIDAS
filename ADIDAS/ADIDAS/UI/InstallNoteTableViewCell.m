//
//  InstallNoteTableViewCell.m
//  ADIDAS
//
//  Created by wendy on 14-5-7.
//
//

#import "InstallNoteTableViewCell.h"
#import "CacheManagement.h"
#define PHONEWIDTH  [UIScreen mainScreen].bounds.size.width

@implementation InstallNoteTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.reasonholderlabel.text = SYSLanguage?@"Input the reason":@"输入原因";
    self.holderlabel.text = SYSLanguage?@"Input the remark":@"填写备注";
    self.textfield.placeholder = SYSLanguage?@"Please choose the reason":@"请选择原因";
    [self.commentview bringSubviewToFront:self.textview];
    self.commentview.frame = self.commentViewFrame;
    if (self.isDelay == NO)
    {
        self.selectReasonView.hidden = YES;
//        self.commentview.frame = CGRectMake(10, 10, 300, 68);
    }
    else if(self.isDelay == YES)
    {
        self.selectReasonView.hidden = NO;
//        self.commentview.frame = CGRectMake(10, 42, 300, 68);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)selectReason:(id)sender
{
    self.ac = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:nil otherButtonTitles:@"不可抗拒因素的物料迟到",@"商场审批拖延",@"物料晚发",@"其他，请说明原因", nil];
    [self.delegate showAc:self.ac];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 4)
    {
        return;
    }
    if (buttonIndex == 3)
    {
        self.reasonview.hidden = NO;
        self.commentview.frame = CGRectMake(10, 98, PHONEWIDTH-20, 68);
    }
    else
    {
        self.reasonview.hidden = YES;
        self.commentview.frame = CGRectMake(10, 42, PHONEWIDTH-20, 68);
        [CacheManagement instance].campReasonNote = nil;
    }
    self.textfield.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    [CacheManagement instance].campReason = [actionSheet buttonTitleAtIndex:buttonIndex];
    [self.delegate configCellHeightWithReason:buttonIndex];
    
//    [self.reasonBtn setTitle:nil forState:UIControlStateNormal];
//    self.reasonBtn.titleLabel.textColor = [UIColor blackColor];
//    self.reasonBtn.titleLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
//    self.reasonBtn.titleLabel.font = [UIFont systemFontOfSize:18];
}

#pragma mark - textview

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
//    if ([text isEqualToString:@"\x20"])
//    {
//        return NO;
//    }
    if (textView == self.textview)
    {
        [CacheManagement instance].campComment = textView.text;
    }
    else if (textView == self.reasontextview)
    {
        [CacheManagement instance].campReasonNote = textView.text;
    }
    return YES;
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView == self.textview)
    {
        [CacheManagement instance].campComment = textView.text;
    }
    else if (textView == self.reasontextview)
    {
        [CacheManagement instance].campReasonNote = textView.text;
    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == self.textview)
    {
        [CacheManagement instance].campComment = [textView.text getReplaceString];
    }
    else if (textView == self.reasontextview)
    {
        [CacheManagement instance].campReasonNote = [textView.text getReplaceString] ;
    }
}


-(void)textViewDidChange:(UITextView *)textView {
    if (textView == self.textview)
    {
        if ([textView.text length] == 0 )
        {
            self.holderlabel.hidden = NO;
        }
        else
        {
            self.holderlabel.hidden = YES;
        }
    }
    else if (textView == self.reasontextview)
    {
        if ([textView.text length] == 0 )
        {
            self.reasonholderlabel.hidden = NO;
        }
        else
        {
            self.reasonholderlabel.hidden = YES;
        }
    }
}






@end
