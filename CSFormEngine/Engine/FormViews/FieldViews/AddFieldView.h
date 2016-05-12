//
//  AddFieldView.h
//  Edumation
//
//  Created by Deepak on 11/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CresFormData.h"
#import "SearchPickerCtr.h"

@class AddFieldView;
@protocol AddFieldViewDelegate <NSObject>

- (void)willPresentPickerOnPageForFieldView: (AddFieldView*)addFieldView;
- (void)addFieldOnPageForFieldView: (AddFieldView*)addFieldView
                          withItems: (NSArray*)items;

@end

@interface AddFieldView : UIView <SearchPickerCtrDelegate>
{
    UIButton*                               mAddBtn;
    UIWindow*                               mWindow;
    
    __weak id<AddFieldViewDelegate>         mDelegate;
    __weak DataBinder*                      mDataBinder;
    NSString*                               mPickerPlaceHolder;
    NSString*                               mPickerHeadingMsg;
}

@property(nonatomic, strong)UIButton*                       addButton;
@property(nonatomic, weak)DataBinder*                       dataBinder;
@property(nonatomic, weak)id<AddFieldViewDelegate>          delegate;
@property(nonatomic, copy)NSString*                         pickerPlaceHolder;
@property(nonatomic, copy)NSString*                         pickerHeadingMsg;

- (instancetype)initWithFrame:(CGRect)frame;

@end
