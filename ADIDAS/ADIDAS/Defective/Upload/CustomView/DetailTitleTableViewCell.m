//
//  DetailTitleTableViewCell.m
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/4.
//

#import "DetailTitleTableViewCell.h"

@implementation DetailTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    if (dict) {
            if ([self.creatTableModel.key isEqualToString:@"ShippingNo"]) {
                NSString * temple = @"";
                if (dict[@"listEhCaseShippingNo"] && [dict[@"listEhCaseShippingNo"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary * shipDic in dict[@"listEhCaseShippingNo"]) {
                        temple = [temple stringByAppendingPathComponent:shipDic[@"ShippingNo"]];
                    }
                    self.DesTitleLab.text = temple;

                }else{
                    self.DesTitleLab.text = @"";
                }
                
            }else{
                self.DesTitleLab.text = dict[self.creatTableModel.key] ?:@"";
            }
        }else{
            self.DesTitleLab.text = @"";
        }
   
}

-(void)setCreatTableModel:(CreatTableModel *)creatTableModel{
    _creatTableModel = creatTableModel;
    self.titleLab.text = creatTableModel.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_titleLab release];
    [_DesTitleLab release];
    [super dealloc];
}
@end
