//
//  CresFieldBaseView.m
//  Edumation
//
//  Created by Deepak on 11/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CresFieldBaseView.h"
#import "CresDatePickerField.h"
#import "SelectedRoleView.h"
#import "CSSocialLoginView.h"
#import "CresSeperatorView.h"
#import "AddFieldView.h"
#import "CresIconCellField.h"
#import "UIImageView+WebCache.h"

@interface CresFieldBaseView (Private)
- (void)reframeField;
- (CGRect)availableFieldRect;
- (void)addFieldView;
- (void)addEmailField;
- (void)addPasswordField;
- (void)addNumericField;
- (void)addTextField;
- (void)addDatePickerField;
- (void)addProfileImageField;
- (void)addRoleIconField;
- (void)addTCField;
- (void)addSocialField;
- (void)addSepeartorField;
- (void)addFieldOfTypeAddField;
- (void)addFieldOfTypeIconCell;
- (void)addListHeader;
- (void)addDropDownSelector;
- (void)addObjectiveQuestion;
- (void)addPlainTextField;
- (void)removeDateSpinnerIfExist;
@end

@implementation CresFieldBaseView

@synthesize fieldData = mFieldData;
@synthesize delegate = mDelegate;

- (id)initWithFrame:(CGRect)frame
       andFieldData: (CresFormFieldData*)cresFormFieldData
        andDelegate: (id<CresFieldBaseViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        mDelegate = delegate;
        self.fieldData = cresFormFieldData;
        self.backgroundColor = [UIColor clearColor];
        
        if (!cresFormFieldData.editable)
            self.userInteractionEnabled = FALSE;
        
        CGRect lRect = self.bounds;
        lRect.size.height *= 0.25;
        lRect.origin.y = CGRectGetHeight(frame) - CGRectGetHeight(lRect);
        lRect.origin.x += 10.0; lRect.size.width -= 20.0;
        lRect.size.height -= 2.0;
        mMessageLbl = [[UILabel alloc] initWithFrame: lRect];
        mMessageLbl.textColor = [UIColor redColor];
        mMessageLbl.backgroundColor = [UIColor clearColor];
        mMessageLbl.numberOfLines = 0;
        mMessageLbl.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:10];
        [self addSubview: mMessageLbl];
        
        lRect = self.bounds;
        mFieldBaseView = [[UIView alloc] initWithFrame: lRect];
        mFieldBaseView.backgroundColor = [UIColor whiteColor];
        [self addSubview: mFieldBaseView];
        
        [self addFieldView];
        
        [self addIndicator];
        
        if (cresFormFieldData.canDelete && cresFormFieldData.editable)
        {
            UIButton* lDeleteBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            [lDeleteBtn setImage: [UIImage imageNamed: @"delete.png"] forState: UIControlStateNormal];
            CGRect lDeleteBtnRect = self.bounds;
            lDeleteBtn.frame = CGRectMake(CGRectGetMaxX(lDeleteBtnRect) - 35.0, (CGRectGetHeight(lDeleteBtnRect) - 30.0)/2, 30.0, 30.0);
            [lDeleteBtn addTarget: self action:@selector(deleteField:) forControlEvents: UIControlEventTouchUpInside];
            [self addSubview: lDeleteBtn];
        }
    }
    
    return self;
}

- (void)reframeField
{
    CGRect lRect = self.bounds;
    lRect.size.height *= 0.25;
    lRect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(lRect);
    lRect.origin.x += 10.0; lRect.size.width -= 20.0;
    lRect.size.height -= 2.0;

    mMessageLbl.frame = lRect;
    
    lRect = self.bounds;
    mFieldBaseView.frame = lRect;
}

//If Validation Required On Server
- (void)addIndicator
{
    CGRect lIndicatorRect = self.bounds;
    lIndicatorRect = CGRectMake(CGRectGetMaxX(lIndicatorRect) - 35.0, (CGRectGetHeight(lIndicatorRect) - 30.0)/2, 30.0, 30.0);
    
    mIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    mIndicator.frame = lIndicatorRect;
    [mIndicator hidesWhenStopped];
    
    [self addSubview: mIndicator];
}

- (void)startIndicator
{
    if (!mIndicator)
        return;
    
    [mIndicator startAnimating];
}

- (void)stopIndicator
{
    if (!mIndicator)
        return;
    
    [mIndicator stopAnimating];
}

- (BOOL)isFieldFullfillConditions
{
    BOOL lRetValue = TRUE;
    
    [self reframeField];
 
    NSArray* lConditions = mFieldData.conditions;
    for (Condition* lCondition in lConditions)
    {
        if ([lCondition.conditionType compare: @"REQUIRED" options: NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if(mFieldData.dataBinder.bindType == EBindTypeSearchAndAddField)
            {
                NSArray* lGeneratedFields = mFieldData.dataBinder.generatedFields;
                if (!lGeneratedFields.count)
                {
                    lRetValue = FALSE;
                    if ([mDelegate respondsToSelector: @selector(showValidationError:WithErrorMesage:WithImageName:)])
                    {
                        [mDelegate showValidationError:self WithErrorMesage:lCondition.message WithImageName:@"loginerror.png"];
                    }
                }
            }
            else if (!mFieldData.fieldValue.length)
            {
                lRetValue = FALSE;
                if ([mDelegate respondsToSelector: @selector(showValidationError:WithErrorMesage:WithImageName:)])
                {
                    [mDelegate showValidationError:self WithErrorMesage:lCondition.message WithImageName:@"loginerror.png"];
                }
                
                break;
            }
        }
        else if ([lCondition.conditionType compare: @"UNIQUE" options: NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if(mFieldData.dataBinder.bindType == EBindTypeAddField)
            {
                NSArray* lGeneratedFields = mFieldData.dataBinder.generatedFields;
                NSMutableArray* lIds = [[NSMutableArray alloc] init];
                for (CresFormFieldData* lFieldData in lGeneratedFields)
                    [lIds addObject: lFieldData.fieldValue];
                
                NSCountedSet* lCountSet = [[NSCountedSet alloc] initWithArray: lIds];
                for(NSNumber* lCount in lCountSet)
                {
                    if([lCountSet countForObject: lCount] > 1)
                    {
                        lRetValue = FALSE;
                        if ([mDelegate respondsToSelector: @selector(showValidationError:WithErrorMesage:WithImageName:)])
                        {
                            [mDelegate showValidationError:self WithErrorMesage:lCondition.message WithImageName:@"loginerror.png"];
                        }
                    }
                }
            }
        }
        else if ([lCondition.conditionType isEqualToString: @"MIN"])
        {
            NSInteger lFieldLength = mFieldData.fieldValue.length;
            NSInteger lConditionData = [lCondition.dataValue integerValue];

            if (mFieldData.fieldType == ECresFieldTypeDatePicker)
            {
                NSDate *todayDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMyy"];
                NSDate *enteredDate = [dateFormatter dateFromString:mFieldData.fieldValue];
                NSTimeInterval distanceBetweenDates = [todayDate timeIntervalSinceDate:enteredDate];
                double YearInSecond = 3600*24*365;
                NSInteger yearDiff = distanceBetweenDates / YearInSecond;
                if (yearDiff<lConditionData) {
                    lRetValue = FALSE;
                    if ([mDelegate respondsToSelector: @selector(showValidationError:WithErrorMesage:WithImageName:)])
                    {
                        [mDelegate showValidationError:self WithErrorMesage:lCondition.message WithImageName:@"loginerror.png"];
                    }
                    break;
                }
                break;

            }
            NSArray* lConditionsInMin = mFieldData.conditions;
            BOOL isRequired=FALSE;
            for (Condition* lConditionInMin in lConditionsInMin)
            {
                if ([lConditionInMin.conditionType compare: @"REQUIRED" options: NSCaseInsensitiveSearch] == NSOrderedSame)
                {
                    isRequired=TRUE;
                }

            }
            if (isRequired && lFieldLength < lConditionData ) {
                lRetValue = FALSE;
                if ([mDelegate respondsToSelector: @selector(showValidationError:WithErrorMesage:WithImageName:)])
                {
                    [mDelegate showValidationError:self WithErrorMesage:lCondition.message WithImageName:@"loginerror.png"];
                }
                
                break;
 
            }
            if (!isRequired && lFieldLength != 0 && lFieldLength < lConditionData)
            {
                lRetValue = FALSE;
                if ([mDelegate respondsToSelector: @selector(showValidationError:WithErrorMesage:WithImageName:)])
                {
                    [mDelegate showValidationError:self WithErrorMesage:lCondition.message WithImageName:@"loginerror.png"];
                }
                
                break;
            }

        }
        else if ([lCondition.conditionType isEqualToString: @"MAX"])
        {
            NSInteger lFieldLength = mFieldData.fieldValue.length;
            NSInteger lConditionData = [lCondition.dataValue integerValue];
            
            if (mFieldData.fieldType == ECresFieldTypeDatePicker)
            {
                //                NSString* lFieldVal = mFieldData.fieldValue;
                //lFieldLength =
                break;
            }

            if (lFieldLength > lConditionData)
            {
                lRetValue = FALSE;
                if ([mDelegate respondsToSelector: @selector(showValidationError:WithErrorMesage:WithImageName:)])
                {
                    [mDelegate showValidationError:self WithErrorMesage:lCondition.message WithImageName:@"loginerror.png"];
                }
                
                break;
            }
        }
        // Validation Email & Student ID
        else if ([lCondition.conditionType isEqualToString: @"REGEX"])
        {
            NSString* lFieldValue = mFieldData.fieldValue;
            NSString* lConditionData = lCondition.dataValue;
            
            {
                NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lConditionData];
                BOOL isValidRegex= [regexTest evaluateWithObject:lFieldValue];
                if (!isValidRegex) {
                    lRetValue = FALSE;
                    if ([mDelegate respondsToSelector: @selector(showValidationError:WithErrorMesage:WithImageName:)])
                    {
                        [mDelegate showValidationError:self WithErrorMesage:lCondition.message WithImageName:@"loginerror.png"];
                    }

                    break;

                }
            }
        }
    }
    
    return lRetValue;
}

- (void)addFieldView
{
    CresFieldType lFieldType = self.fieldData.fieldType;
    switch (lFieldType)
    {
        case ECresFieldTypeEmail:
            [self addEmailField];
            break;
        case ECresFieldTypePassword:
            [self addPasswordField];
            break;
        case ECresFieldTypeNumeric:
            [self addNumericField];
            break;
        case ECresFieldTypeText:
            [self addTextField];
            break;
        case ECresFieldTypeDatePicker:
            [self addDatePickerField];
            break;
        case ECresFieldTypeProfileImage:
            [self addProfileImageField];
            break;
        case ECresFieldTypeRoleIcon:
            [self addRoleIconField];
            break;
        case ECresFieldTypeTermsCondition:
            [self addTCField];
            break;
        case ECresFieldTypeSocialIcons:
            [self addSocialField];
            break;
        case ECresFieldTypeSeperator:
            [self addSepeartorField];
            break;
        case ECresFieldTypeAddField:
            [self addFieldOfTypeAddField];
            break;
        case ECresFieldTypeIconCell:
            [self addFieldOfTypeIconCell];
            break;
        case ECresFieldTypeDefaultGap:
            break;
        case ECresFieldTypeListHeader:
            [self addListHeader];
            break;
        case ECresFieldTypeListSingleSelectDropDown:
        case ECresFieldTypeListMultiSelectDropDown:
            [self addDropDownSelector];
            break;
        case ECresFieldTypeObjectiveSingleChoice:
        case ECresFieldTypeObjectiveMultiChoice:
            [self addObjectiveQuestion];
            break;
        case ECresFieldTypePlainText:
            [self addPlainTextField];
            break;
        
        case ECresFieldTypeUnknown:
            NSLog(@"Field is not supported by Crescerance form rendering library, \n Field ID = %@, Field value = %@ encountered ", self.fieldData.fieldID, self.fieldData.fieldValue);
            break;
        default:
            break;
    }
}

- (CGRect)availableFieldRect
{
    CGRect lAvailableFieldRect = self.bounds;
    if (self.fieldData.canDelete)
    {
//        lAvailableFieldRect.size.width -= 35.0;
    }
    
    return lAvailableFieldRect;
}

- (void)addEmailField
{
    CGRect lRect = [self availableFieldRect];
    VATextField* lTextField = [[VATextField alloc] initWithFrame: lRect];
    lTextField.delegate = self;
    lTextField.titleLabelToDisplay.text = mFieldData.fieldTitle;
    lTextField.textFieldToDisplay.placeholder = mFieldData.fieldPlaceHolder;
    lTextField.textFieldToDisplay.text = mFieldData.fieldValue;
    lTextField.textFieldToDisplay.autocorrectionType = UITextAutocorrectionTypeNo;
    lTextField.textFieldToDisplay.autocapitalizationType = UITextAutocapitalizationTypeNone;
    lTextField.textFieldToDisplay.keyboardType = UIKeyboardTypeEmailAddress;
    [mFieldBaseView addSubview: lTextField];
    
    if (!mFieldData.editable)
    {
        UIColor* lColor = [UIColor colorWithRed: 144.0/255.0 green: 144.0/255.0 blue: 144.0/255.0 alpha: 1.0];
        lTextField.titleLabelToDisplay.textColor = lColor;
        lTextField.textFieldToDisplay.textColor = lColor;
    }
}

- (void)addPasswordField
{
    CGRect lRect = [self availableFieldRect];
    VATextField* lTextField = [[VATextField alloc] initWithFrame: lRect];
    lTextField.delegate = self;
    lTextField.titleLabelToDisplay.text = mFieldData.fieldTitle;
    lTextField.textFieldToDisplay.placeholder = mFieldData.fieldPlaceHolder;
    lTextField.textFieldToDisplay.text = mFieldData.fieldValue;
    lTextField.textFieldToDisplay.secureTextEntry = TRUE;
    lTextField.textFieldToDisplay.autocorrectionType = UITextAutocorrectionTypeNo;
    lTextField.textFieldToDisplay.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [mFieldBaseView addSubview: lTextField];
    
    if (!mFieldData.editable)
    {
        UIColor* lColor = [UIColor colorWithRed: 144.0/255.0 green: 144.0/255.0 blue: 144.0/255.0 alpha: 1.0];
        lTextField.titleLabelToDisplay.textColor = lColor;
        lTextField.textFieldToDisplay.textColor = lColor;
    }
}

- (void)addNumericField
{
    CGRect lRect = [self availableFieldRect];
    VATextField* lTextField = [[VATextField alloc] initWithFrame: lRect];
    lTextField.delegate = self;
    lTextField.titleLabelToDisplay.text = mFieldData.fieldTitle;
    lTextField.textFieldToDisplay.placeholder = mFieldData.fieldPlaceHolder;
    lTextField.textFieldToDisplay.text = mFieldData.fieldValue;
    lTextField.textFieldToDisplay.autocorrectionType = UITextAutocorrectionTypeNo;
    lTextField.textFieldToDisplay.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [mFieldBaseView addSubview: lTextField];
    
    if (!mFieldData.editable)
    {
        UIColor* lColor = [UIColor colorWithRed: 144.0/255.0 green: 144.0/255.0 blue: 144.0/255.0 alpha: 1.0];
        lTextField.titleLabelToDisplay.textColor = lColor;
        lTextField.textFieldToDisplay.textColor = lColor;
    }
}

- (void)addTextField
{
    CGRect lRect = [self availableFieldRect];
    VATextField* lTextField = [[VATextField alloc] initWithFrame: lRect];
    lTextField.delegate = self;
    lTextField.titleLabelToDisplay.text = mFieldData.fieldTitle;
    lTextField.textFieldToDisplay.placeholder = mFieldData.fieldPlaceHolder;
    lTextField.textFieldToDisplay.text = mFieldData.fieldValue;
    lTextField.textFieldToDisplay.keyboardType = UIKeyboardTypeDefault;
    lTextField.textFieldToDisplay.autocorrectionType = UITextAutocorrectionTypeNo;

    [mFieldBaseView addSubview: lTextField];
    
    if (!mFieldData.editable)
    {
        UIColor* lColor = [UIColor colorWithRed: 144.0/255.0 green: 144.0/255.0 blue: 144.0/255.0 alpha: 1.0];
        lTextField.titleLabelToDisplay.textColor = lColor;
        lTextField.textFieldToDisplay.textColor = lColor;
    }
}

- (void)addDatePickerField
{
    CGRect lRect = [self availableFieldRect];
    CresDatePickerField* lCresDatePickerField = [[CresDatePickerField alloc] initWithFrame: lRect];
    lCresDatePickerField.titleLabel.text = mFieldData.fieldTitle;
    lCresDatePickerField.detailField.placeholder = mFieldData.fieldPlaceHolder;
    lCresDatePickerField.hintText = mFieldData.fieldHint;
    [lCresDatePickerField setPefilledDateValue: mFieldData.fieldValue];
    lCresDatePickerField.delegate = self;
    [mFieldBaseView addSubview: lCresDatePickerField];
    
    if (!mFieldData.editable)
    {
        UIColor* lColor = [UIColor colorWithRed: 144.0/255.0 green: 144.0/255.0 blue: 144.0/255.0 alpha: 1.0];
        lCresDatePickerField.titleLabel.textColor = lColor;
        lCresDatePickerField.detailField.textColor = lColor;
    }
}

- (void)addProfileImageField
{
    CGRect lRect = [self availableFieldRect];
    ProfileImageAreaView* lPIView = [[ProfileImageAreaView alloc] initWithFrame: lRect];
    lPIView.delegate = self;
    if ([mFieldData.fieldIconSrc isKindOfClass: [UIImage class]])
        lPIView.profileImageView.image = mFieldData.fieldIconSrc;

    lPIView.textLabel.text = mFieldData.fieldPlaceHolder;
    mFieldBaseView.backgroundColor = [UIColor clearColor];
    [mFieldBaseView addSubview: lPIView];
}

- (void)addRoleIconField
{
    CGRect lRect = [self availableFieldRect];
    SelectedRoleView* lSelectedRoleView = [[SelectedRoleView alloc] initWithFrame: lRect];
    if ([mFieldData.fieldIconSrc isKindOfClass: [UIImage class]])
        lSelectedRoleView.selectedRoleimageView.image = mFieldData.fieldIconSrc;
    
    lSelectedRoleView.selectedRoleLbl.text = mFieldData.fieldValue;
    mFieldBaseView.backgroundColor = [UIColor clearColor];
    [mFieldBaseView addSubview: lSelectedRoleView];
}

- (void)addTCField
{
    CGRect lRect = [self availableFieldRect];
    LinkTextView* lLinkTextView = [[LinkTextView alloc] initWithHtmlText: mFieldData.fieldValue andFrame: lRect];
    lLinkTextView.delegate=self;
    mFieldBaseView.backgroundColor = [UIColor clearColor];
    [mFieldBaseView addSubview: lLinkTextView];
}

- (void)addSocialField
{
    CGRect lRect = [self availableFieldRect];
    CSSocialLoginView* loginView = [[CSSocialLoginView alloc] initWithFrame:lRect withSocialNetworkOptions: mFieldData.subItemsInfo.subItems];
    mFieldBaseView.backgroundColor = [UIColor clearColor];
    loginView.delegate = self;
    [mFieldBaseView addSubview:loginView];
}

- (void)addSepeartorField
{
    CGRect lRect = [self availableFieldRect];
    CresSeperatorView* lSeperatorView = [[CresSeperatorView alloc] initWithFrame: lRect];
    mFieldBaseView.backgroundColor = [UIColor clearColor];
    [mFieldBaseView addSubview: lSeperatorView];
}

- (void)addFieldOfTypeAddField
{
    CGRect lRect = [self availableFieldRect];
    AddFieldView* lAddFieldView = [[AddFieldView alloc] initWithFrame: lRect];
    lAddFieldView.dataBinder = mFieldData.dataBinder;
    [lAddFieldView.addButton setTitle: mFieldData.fieldValue forState: UIControlStateNormal];
    lAddFieldView.pickerPlaceHolder=mFieldData.fieldPlaceHolder;
    lAddFieldView.pickerHeadingMsg=mFieldData.fieldTitle;
    lAddFieldView.delegate = self;
    mFieldBaseView.backgroundColor = [UIColor clearColor];
    [mFieldBaseView addSubview: lAddFieldView];
    
    if (!mFieldData.editable)
        lAddFieldView.hidden = TRUE;
}

- (void)addFieldOfTypeIconCell
{
    CGRect lRect = [self availableFieldRect];
    CresIconCellField* lField = [[CresIconCellField alloc] initWithFrame: lRect];
    
    id lIconSrc = self.fieldData.fieldIconSrc;
    if (lIconSrc)
    {
        if ([lIconSrc isKindOfClass: [NSString class]])
            [lField setImageFromSource: (NSString*)lIconSrc];
        else
            lField.iconView.image = (UIImage*)lIconSrc;
    }
    lField.descLabel.text = self.fieldData.fieldValue;
    [mFieldBaseView addSubview: lField];
    
    if (!mFieldData.editable)
    {
        UIColor* lColor = [UIColor colorWithRed: 144.0/255.0 green: 144.0/255.0 blue: 144.0/255.0 alpha: 1.0];
        lField.descLabel.textColor = lColor;
    }
}

- (void)addListHeader
{
    CGRect lRect = [self availableFieldRect];
    lRect.origin.y += 1.0;
    lRect.size.height -= 1.0;
    lRect.origin.x += 10;
    lRect.size.width += 20;
    
    UILabel* lListHeader = [[UILabel alloc] initWithFrame: lRect];
    lListHeader.text = self.fieldData.fieldValue;
    lListHeader.font = [UIFont fontWithName:@"AGLettericaCondensed-Bold" size:17];
    lListHeader.textColor = [UIColor grayColor];
    mFieldBaseView.backgroundColor = [UIColor clearColor];
    [mFieldBaseView addSubview: lListHeader];
}

- (void)addDropDownSelector
{
    CGRect lRect = [self availableFieldRect];

    lRect.origin.x += 10.0f;
    lRect.size.width -= 20.0f;
    lRect.size.height = 20.0f;
    UILabel* lListHeader = [[UILabel alloc] initWithFrame: lRect];
    lListHeader.text = self.fieldData.fieldValue;
    lListHeader.font = [UIFont fontWithName:@"AGLettericaCondensed-Bold" size:17];
    lListHeader.textColor = [UIColor grayColor];
    mFieldBaseView.backgroundColor = [UIColor whiteColor];
    [mFieldBaseView addSubview: lListHeader];
    
    lRect.origin.x = 0.0f;
    lRect.size.width += 20.0f;
    lRect.origin.y = CGRectGetHeight(lRect);
    lRect.size.height = 44.0f;
    CPDropDownSelector* lCPDropDownSelector = [[CPDropDownSelector alloc] initWithFrame: lRect];
    lCPDropDownSelector.delegate = self;
    lCPDropDownSelector.dataSource = self;
    lCPDropDownSelector.shouldHideSelectLabel = TRUE;
    lCPDropDownSelector.allowMultiSelection = (self.fieldData.fieldType == ECresFieldTypeListSingleSelectDropDown || self.fieldData.fieldType ==ECresFieldTypeListSingleSelectDropDown) ? FALSE : TRUE;
    mFieldBaseView.backgroundColor = [UIColor whiteColor];
    [mFieldBaseView addSubview: lCPDropDownSelector];
}

- (void)addObjectiveQuestion
{
    CGRect lRect = [self availableFieldRect];
    CSObjectiveQuestionView* lCSObjectiveQuestionView = [[CSObjectiveQuestionView alloc] initWithFrame: lRect andFieldInfo: self.fieldData];
    [mFieldBaseView addSubview: lCSObjectiveQuestionView];
}

- (void)addPlainTextField
{
    CGRect lRect = [self availableFieldRect];
    lRect.origin.x = kXMarginQuestion;
    lRect.size.width -= 2*kXMarginQuestion;
    UILabel* lPlainTextLabel = [[UILabel alloc] initWithFrame: lRect];
    lPlainTextLabel.text = self.fieldData.fieldValue;
    lPlainTextLabel.numberOfLines = 0;
    lPlainTextLabel.font = kQuestionFont;
    lPlainTextLabel.backgroundColor = [UIColor clearColor];
    [mFieldBaseView addSubview: lPlainTextLabel];
}

- (void)deleteField: (id)sender
{
    if ([mDelegate respondsToSelector: @selector(deleteFieldOnPageForCresFieldBaseView:)])
    {
        [mDelegate deleteFieldOnPageForCresFieldBaseView: self];
    }
}

- (void)removeDateSpinnerIfExist
{
    NSArray* lSubViews = [[self.superview superview] subviews];
    for (UIView* lView in lSubViews)
    {
        if ([lView isKindOfClass: [NTMonthYearPicker class]])
        {
            NTMonthYearPicker* lNTMonthYearPicker = (NTMonthYearPicker*)lView;
            [lNTMonthYearPicker removeFromSuperview];
        }
    }
}

#pragma mark-
#pragma mark- CresDatePickerFieldDelegate
#pragma mark-

- (void)presentPickerInView: (UIView**)view
                    andRect: (CGRect*)rect
     forCresDatePickerField: (CresDatePickerField*)datePickerField
{
    if ([mDelegate respondsToSelector: @selector(presentPickerInView:andRect:forCresFieldBaseView:)])
    {
        [mDelegate presentPickerInView: view andRect: rect forCresFieldBaseView: self];
    }
}

- (void)didSelectValueInPicker: (CresDatePickerField*)datePickerField
{
    mFieldData.fieldValue = datePickerField.selectedDateStr;
    [self reframeField];
}

#pragma mark-
#pragma mark- AddFieldViewDelegate
#pragma mark-

- (void)addFieldOnPageForFieldView: (AddFieldView*)addFieldView
                         withItems: (NSArray*)items
{
    [self removeDateSpinnerIfExist];
    if ([mDelegate respondsToSelector: @selector(cresFieldBaseView:addItemsOnPage:addBindType:)])
    {
        [mDelegate cresFieldBaseView: self
                      addItemsOnPage: items
                         addBindType: addFieldView.dataBinder.bindType];
    }
}

- (void)willPresentPickerOnPageForFieldView: (AddFieldView*)addFieldView
{
    if ([mDelegate respondsToSelector: @selector(willPresentPickerOnPageForFieldBaseView:)])
    {
        [mDelegate willPresentPickerOnPageForFieldBaseView: self];
    }
}

#pragma mark-
#pragma mark- CSSocialLoginDelegate
#pragma mark-

-(BOOL)willStartSigning:(CSSocialLoginView *)loginView withLoginType:(NSInteger)type
{
    BOOL isLogin=false;
    if ([mDelegate respondsToSelector: @selector(willStartSigning:withLoginType:)])
    {
       isLogin= [mDelegate willStartSigning: self withLoginType: type];
    }
    return isLogin;
}

-(void)socialLogin:(CSSocialLoginView *)loginView
 didSignInWithType:(NSString *)type
      WithResponse:(CSSocialLoginUser *)response
         withError:(NSError *)error
{
    if ([mDelegate respondsToSelector: @selector(socialLogin:didSignInWithType:WithResponse:withError:)])
    {
        [mDelegate socialLogin: self didSignInWithType: type WithResponse: response withError: error];
    }
}


#pragma mark-
#pragma mark- CSTextFieldDelegate
#pragma mark-


-(BOOL)csTextFieldShouldBeginEditing:(VATextField *)csTextField
{
    [self removeDateSpinnerIfExist];
    if ([mDelegate respondsToSelector: @selector(textFieldBeginEditing:)])
    {
        [self reframeField];
        [mDelegate textFieldBeginEditing:self];
    }
    return true;
}

-(BOOL)csTextFieldShouldEndEditing:(VATextField *)csTextField
{
    if ([mDelegate respondsToSelector: @selector(textFieldEndEditing:)])
    {
        [mDelegate textFieldEndEditing:self];
        mFieldData.fieldValue = csTextField.textFieldToDisplay.text;
    }
    return true;
}

- (void)csTextFieldDidEndEditing:(VATextField *)csTextField
{
    mFieldData.fieldValue = csTextField.textFieldToDisplay.text;
}

-(BOOL)csTextFieldShouldReturn:(VATextField *)csTextField
{
    if([mDelegate respondsToSelector: @selector(textFieldShouldReturn:)])
    {
        [mDelegate textFieldShouldReturn:self];
    }
    return true;
}

#pragma mark-
#pragma mark- ProfileImageAreaViewDelegate
#pragma mark-

- (void)didSelectImageInProfileImageAreaView:(ProfileImageAreaView*)imageAreaView
{
    [self removeDateSpinnerIfExist];
    mFieldData.fieldIconSrc = imageAreaView.profileImageView.image;
}

// key board hide click on profile Image
- (void)willSelectImageInProfileImageAreaView:(ProfileImageAreaView*)imageAreaView
{
    if([mDelegate respondsToSelector: @selector(willPresentPickerOnPageForFieldBaseView:)])
    {
        [mDelegate willPresentPickerOnPageForFieldBaseView: self];
    }
}

#pragma mark-
#pragma mark- LinkTextViewDelegate
#pragma mark-

-(void)ClickOnLink:(LinkTextView *)LinkTextView WithUrlString:(NSString *)urlString andTitleStr:(NSString *)titleStr
{
    [self removeDateSpinnerIfExist];
    UIViewController* lRootCtr=[self rootController];
    FormWebViewCtr *lCtr=[[FormWebViewCtr alloc]initWithNibName:@"FormWebViewCtr" bundle:nil];
    lCtr.delegate=self;
    lCtr.urlString=urlString;
    lCtr.titleString = titleStr;
    [lRootCtr presentViewController:lCtr animated:YES completion:nil];
}

- (UIViewController*)rootController
{
    if (mWindow)
    {
        return mWindow.rootViewController;
    }
    
    mWindow = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    mWindow.backgroundColor = [UIColor colorWithWhite: 1.0 alpha: 0.5];
    mWindow.windowLevel = UIWindowLevelNormal;
    
    UIViewController* lCtr = [[UIViewController alloc] init];
    lCtr.view.frame = [[UIScreen mainScreen] bounds];
    [mWindow setRootViewController: lCtr];
    
    [mWindow makeKeyAndVisible];
    
    return lCtr;
}

#pragma mark-
#pragma mark- FormWebViewCtrDelegate
#pragma mark-

- (void)willDissmissFormWebview: (FormWebViewCtr*)searchPicker
{
    [mWindow resignKeyWindow];
    mWindow = nil;
}

#pragma mark-
#pragma mark- CPDropDownSelectorDelegate & DataSource
#pragma mark-

- (NSInteger)numberOfRowsInDropDownSelector:(CPDropDownSelector*)selector
{
    return mFieldData.subItemsInfo.subItems.count;
}

- (NSString*)dropDownSelector:(CPDropDownSelector*)selector textForRow:(NSInteger)row
{
    NSArray* lSubItems = mFieldData.subItemsInfo.subItems;
    CSSubItem* lSubItem = [lSubItems objectAtIndex: row];
    return lSubItem.subItemTitle;
}

- (CGFloat)dropDownSelector:(CPDropDownSelector*)selector heightForRow:(NSInteger)row
{
    return 44.0f;
}

- (void)dropDownSelector:(CPDropDownSelector*)selector didSelectedRow:(NSInteger)row
{
    NSArray* lSubItems = mFieldData.subItemsInfo.subItems;
    CSSubItem* lSubItem = [lSubItems objectAtIndex: row];
    [selector setText: lSubItem.subItemTitle];
}

- (void)dropDownSelector:(CPDropDownSelector*)selector didSelected:(BOOL)selected row:(NSInteger)row
{
    NSArray* lSubItems = mFieldData.subItemsInfo.subItems;
    CSSubItem* lSubItem = [lSubItems objectAtIndex: row];
    lSubItem.isSelected = selected;
    
    NSString* lGetText = [selector getText];
    if (lSubItem.isSelected)
    {
        lGetText = [lGetText stringByAppendingFormat: @",%@", lSubItem.subItemTitle];
    }
    else
    {
        lGetText = [lGetText stringByReplacingOccurrencesOfString: lSubItem.subItemTitle withString: @""];
        lGetText = [lGetText stringByReplacingOccurrencesOfString: @",," withString: @","];
    }
    
    if ([lGetText hasPrefix: @","])
        lGetText = [lGetText stringByReplacingCharactersInRange: NSMakeRange(0, 1)
                                                     withString: @""];
    if (!lGetText.length)
        lGetText = kSelectorTitle;
    
    [selector setText: lGetText];
}

- (BOOL)dropDownSelector:(CPDropDownSelector*)selector shouldShowSelectedRow:(NSInteger)row
{
    NSArray* lSubItems = mFieldData.subItemsInfo.subItems;
    CSSubItem* lSubItem = [lSubItems objectAtIndex: row];
    return lSubItem.isSelected;
}

@end
