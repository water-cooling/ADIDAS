//
//  OrderDetailView.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DatePickerViewController.h"
#import "CaseTitleViewController.h"
#import "EditTableViewCell.h"

@interface OrderDetailView : UIView<UITableViewDataSource,UITableViewDelegate,DatePickerDelegate,CaseDelegate,LongPressDelegate>
{
    NSString *pastTitle ;
}
@property (strong, nonatomic) NSArray *expressAry ;
@property (strong, nonatomic) NSString *folderName ;
@property (strong, nonatomic) BaseViewController *vc ;
@property (strong, nonatomic) NSDictionary *dataDic ;
@property (assign, nonatomic) BOOL isEdited ;

@property (retain, nonatomic) IBOutlet UITableView *contentTableView;

- (void)clearData ;

- (void)clearKeyBoard ;



@end
