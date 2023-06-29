//
//  DropDownView.h
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueProductEntity.h"

@class ProductView;

@protocol ProductViewDelegate <NSObject>
@optional

-(void)myProductViewSubmit:(ProductView*)alertView 
                selectEntity:(IssueProductEntity *)selValue 
                  deleEntity:(IssueProductEntity *) deleEntity
                  isDelected:(BOOL)isDelected ;

@end

@interface ProductView : UIView<UITextFieldDelegate>
{
    id<ProductViewDelegate>m_delegate;
    IssueProductEntity* _currProduct;
    
    UITextField *txtProdCode;
    UITextField *txtProdSize;
    UITextField *txtProdName;
}

-(ProductView *)initProductView:(id)delegate title:(NSString*)title 
                   currSelValue:(IssueProductEntity*)currSelValue;

-(void)dismissMyAlertView;
@end