//
//  CresDataPickerField.h
//  Edumation
//
//  Created by Deepak on 09/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTMonthYearPicker.h"

@class CresDatePickerField;
@protocol CresDatePickerFieldDelegate <NSObject>

- (void)presentPickerInView: (UIView**)view
                    andRect: (CGRect*)rect
     forCresDatePickerField: (CresDatePickerField*)datePickerField;

- (void)didSelectValueInPicker: (CresDatePickerField*)datePickerField;

@end

@interface CresDatePickerField : UIView
{
    UILabel*                                    mTitleLabel;
    UITextField*                                mDetailField;
    UIButton*                                   mHintIconBtn;

    //Will be add in rect and view that will be supply in above delegate method
    NTMonthYearPicker *mDatePicker;
    __weak id<CresDatePickerFieldDelegate>      mDelegate;
    
    NSString*                                   mHintText;
    NSString*                                   mSelectedDateStr;
}

@property(nonatomic, strong)UILabel*                        titleLabel;
@property(nonatomic, strong)UITextField*                    detailField;
@property(nonatomic, weak)id<CresDatePickerFieldDelegate>   delegate;
@property(nonatomic, copy)NSString*                         hintText;
@property(nonatomic, copy)NSString*                         selectedDateStr;

- (void)setPefilledDateValue: (NSString*)selectedDate;

@end
