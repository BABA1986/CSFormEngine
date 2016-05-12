//
//  CresFieldBaseView.h
//  Edumation
//
//  Created by Deepak on 11/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CresFormData.h"
#import "AddFieldView.h"
#import "CSSocialLoginView.h"
#import "CresDatePickerField.h"
#import "ProfileImageAreaView.h"
#import "VATextField.h"
#import "LinkTextView.h"
#import "CPDropDownSelector.h"
#import "CSObjectiveQuestionView.h"

@class CresFieldBaseView;
@protocol CresFieldBaseViewDelegate <NSObject>

- (void)cresFieldBaseView: (CresFieldBaseView*)cresFieldBaseView
           addItemsOnPage: (NSArray*)items
              addBindType: (BindType)bindType;
- (void)willPresentPickerOnPageForFieldBaseView: (CresFieldBaseView*)baseFieldView;


- (void)deleteFieldOnPageForCresFieldBaseView: (CresFieldBaseView*)cresFieldBaseView;

- (void)presentPickerInView: (UIView**)view
                    andRect: (CGRect*)rect
       forCresFieldBaseView: (CresFieldBaseView*)cresFieldBaseView;

- (NSArray*)signUpTypesCresFieldBaseView:(CresFieldBaseView *)cresFieldBaseView;

- (void)showValidationError:(CresFieldBaseView *)cresFieldBaseView WithErrorMesage:(NSString *)msg WithImageName:(NSString *)imageName;

- (void) socialLogin:(CresFieldBaseView *)cresFieldBaseView
   didSignInWithType:(NSString *) type
        WithResponse:(CSSocialLoginUser*)response
           withError:(NSError *)error;

@optional

-(BOOL)willStartSigning:(CresFieldBaseView *)cresFieldBaseView
          withLoginType:(NSInteger ) type;

-(BOOL)textFieldBeginEditing:(CresFieldBaseView *)cresFieldBaseView;

-(BOOL)textFieldEndEditing:(CresFieldBaseView *)cresFieldBaseView;

-(BOOL)textFieldShouldReturn:(CresFieldBaseView *)cresFieldBaseView;

@end

@interface CresFieldBaseView : UIView <AddFieldViewDelegate, CSSocialLoginDelegate, CresDatePickerFieldDelegate,CSTextFieldDelegate, ProfileImageAreaViewDelegate,LinkTextViewDelegate,FormWebViewCtrDelegate, CPDropDownSelectorDataSource, CPDropDownSelectorDelegate>
{
    CresFormFieldData*                          mFieldData;
    
    UIView*                                     mFieldBaseView;
    UILabel*                                    mMessageLbl;
    __weak id<CresFieldBaseViewDelegate>        mDelegate;
    UIWindow*                                   mWindow;
    
    //For fields those requires validation on Server
    UIActivityIndicatorView*                    mIndicator;
}

@property(nonatomic, strong)CresFormFieldData*                              fieldData;
@property(nonatomic, weak, readonly)id<CresFieldBaseViewDelegate>           delegate;

- (id)initWithFrame:(CGRect)frame
       andFieldData: (CresFormFieldData*)cresFormFieldData
        andDelegate: (id<CresFieldBaseViewDelegate>)delegate;

- (void)validateOnServer:(void (^)(BOOL success, NSString* errorMsg))completionBlock;
- (BOOL)isFieldFullfillConditions;

- (void)startIndicator;
- (void)stopIndicator;


@end
