//
//  DropDownView.h
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItemEntity.h"

@class DropDownView;

@protocol DropDownViewDelegate <NSObject>
@optional

-(void)myDropDownSelectIndex:(DropDownView*)alertView selectEntity:(ListItemEntity *)selValue deleIndex:(NSInteger) deleIndex ;

@end

@interface DropDownView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    id<DropDownViewDelegate>m_delegate;
    NSMutableArray *popDatasource;
    UITableView *popTableView;
    NSInteger _deleIndex;
    ListItemEntity* _currSelValue;
}

-(DropDownView *)initDropView:(id)delegate title:(NSString*)title listArray:(NSMutableArray*)listArray 
                 currSelValue:(ListItemEntity*)currSelValue deleIndex:(NSInteger) deleIndex ;

@property (nonatomic, assign) id<DropDownViewDelegate>m_delegate;
@property(nonatomic,retain) UITableView *popTableView;
@property(nonatomic,retain) NSArray *popDatasource;



-(void)dismissMyAlertView;
@end