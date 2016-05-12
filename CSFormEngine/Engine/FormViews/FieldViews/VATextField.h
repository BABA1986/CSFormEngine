//
//  CSTextField.h
//  CSTextField
//
//  Created by Vidhi on 25/01/16.
//  Copyright © 2016 Vidhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UITextStyleDefault, //default style label with text field with an option of detailLabel and icon to display
    UITextStyleDetailed,//same as default
    UITextStyleTable,   //label,text,label one below the other with an option to display icon at right corner
    UITextStyleSystem,  //label below text with an option to display icon at right corner
    UITextStyleImageWithText//image with label in a row with a n option of icon to display at right corner
} CSTextFieldStyle;

typedef enum
{
    UITextFieldNormalButton,//cstextfieldstyle with normal button
    UITextFieldHintButton //cstextfieldstyle with hint button
}CSTextFieldButtonStyle;

@class VATextField;

@protocol CSTextFieldDelegate <NSObject>

@optional

- (void)didSelectedIconOn:(VATextField *)csTextField;//Method to know when button is click
- (BOOL)csTextFieldShouldBeginEditing:(VATextField *)csTextField;        // return NO to disallow editing.
- (void)csTextFieldDidBeginEditing:(VATextField *)csTextField;           // became first responder
- (BOOL)csTextFieldShouldEndEditing:(VATextField *)csTextField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)csTextFieldDidEndEditing:(VATextField *)csTextField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)csTextField:(VATextField *)csTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)csTextFieldShouldClear:(VATextField *)csTextField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)csTextFieldShouldReturn:(VATextField *)csTextField;              // called when 'return' key pressed. return NO to ignore.

@end

@interface VATextField : UIView<UITextFieldDelegate>
{
    UITextField*           textField;
    UILabel*               titleLabel;
    UILabel*               detailedtitleLabel;
    UIButton*              iconView;
    UIImageView*           mImg;
    UIView*                mBorderLineOnTop;
    UIView*                mBorderLineOnBottom;
    NSString*              mHintButtonText;
    CSTextFieldStyle       mCSTextFieldStyle;
    CSTextFieldButtonStyle mCSTextFieldButtonStyle;
    BOOL                   didIconViewToDispaly;
    BOOL                   didDetailLabelToDispaly;
}

@property (strong,nonatomic)UILabel*               titleLabelToDisplay;
@property (strong,nonatomic)UILabel*               detailedtitleLabelToDisplay;
@property (strong,nonatomic)UITextField*           textFieldToDisplay;
@property (strong,nonatomic)UIButton*              iconViewToDisplay;
@property (strong,nonatomic)UIView*                borderLineOnTop;
@property (strong,nonatomic)UIView*                borderLineOnBottom;
@property (strong,nonatomic)UIImageView*           img;
@property (strong,nonatomic)NSString*              hintButtonText;
@property (strong,nonatomic)id                     <CSTextFieldDelegate> delegate;
@property (assign, nonatomic)CSTextFieldStyle      cSTextFieldStyle;
@property (assign,nonatomic)CSTextFieldButtonStyle cSTextFieldButtonStyle;
@property (assign,nonatomic)BOOL                   didIconToDispaly;
@property (assign,nonatomic)BOOL                   didDetailTitleLabelToDisplay;

- (instancetype)initWithFrame:(CGRect)frame andStyle: (CSTextFieldStyle)cSTextFieldStyle;

@end


