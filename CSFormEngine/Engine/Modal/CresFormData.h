//
//  CresFormData.h
//  Edumation
//
//  Created by Deepak on 02/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    EFieldVerificationNeeded = 0,
    EPageNotAvailable,
} CresNextPageMoveChallenge;

typedef enum : NSUInteger
{
    ECSPageNavigationNone = 0,
    ECSPageNavigationDefault,
    ECSPageNavigationNextPrevious,
    ECSPageNavigationPaginationDot, //Dots
    ECSPageNavigationPaginationDotNumeric, //Dots hacing page numbers
    ECSPageNavigationPaginationCustomDot //can have image instead of dot
} CSPageNavigationType;


typedef enum : NSUInteger
{
    ECresFieldTypeEmail = 0,
    ECresFieldTypePassword = 1,
    ECresFieldTypeNumeric = 2,
    ECresFieldTypeText = 3,
    ECresFieldTypeDatePicker = 5,
    ECresFieldTypeProfileImage = 6,
    ECresFieldTypeRoleIcon = 7,
    ECresFieldTypeTermsCondition = 8,
    ECresFieldTypeSocialIcons = 9,
    ECresFieldTypeSeperator = 10,
    ECresFieldTypeDefaultGap = 11,
    ECresFieldTypeAddField = 12,
    ECresFieldTypeLink = 13,
    ECresFieldTypeIconCell = 14,
    ECresFieldTypeListHeader = 15,
    ECresFieldTypeListSingleSelectDropDown = 16,
    ECresFieldTypeListMultiSelectDropDown = 17,
    ECresFieldTypeObjectiveSingleChoice = 18,
    ECresFieldTypeObjectiveMultiChoice = 19,
    ECresFieldTypePlainText = 20,
    ECresFieldTypeUnknown = 100 //Not Supported in this form library
} CresFieldType;

typedef enum : NSUInteger
{
    ESelectionTypeBtn = 0,
    ESelectionTypeIndicator,
    ESelectionTypeNone
} NextPageSelectorType;

typedef enum : NSUInteger
{
    EScrollTypeHorizontal = 0,
    EScrollTypeVertical = 0,
} ScrollType;

typedef enum : NSUInteger
{
    EBindTypeAddField = 0,
    EBindTypeSearchAndAddField,
    EBindTypeNone
} BindType;

typedef enum : NSUInteger
{
    EVisibilityInDefaultMode = 0,
    EVisibilityInModeEdit,
    EVisibilityInBothMode,
    EVisibilityNone
} VisibilityInMode;

typedef enum : NSUInteger {
    EObjectiveQuestionIndexDefault,
    EObjectiveQuestionIndexNum,
    EObjectiveQuestionIndexAlphabet,
    EObjectiveQuestionIndexImage,
} ObjectiveQuestionIndexType;

@class CresFormFieldData;
@interface DataBinder : NSObject
{
    BindType            mBindType;
    NSString*           mSourceUrl; //If Required
    NSString*           mFieldTemplate;
    
    //For Picker control
    //Only valid for fields created by binder field;
    __weak CresFormFieldData*       mAssociatedBinderField;
    //Only valid for Binder fields responsible for creating new fields;
    NSMutableArray*                 mGeneratedFields;
    NSMutableArray*                 mSelectedItems;
}

@property(nonatomic, assign)BindType                    bindType;
@property(nonatomic, copy)NSString*                     sourceUrl;
@property(nonatomic, copy)NSString*                     fieldTemplate;
@property(nonatomic, strong)NSMutableArray*             selectedItems;
@property(nonatomic, weak)CresFormFieldData*            associatedBinderField;
@property(nonatomic, strong)NSMutableArray*             generatedFields;

- (id)initWithDict: (NSDictionary*)dataBinderInfo;

@end

@interface Condition : NSObject
{
    NSString*                   mConditionType;
    NSString*                   mMessage;
    NSString*                   mDataValue;
}

@property(nonatomic, copy)NSString*             conditionType;
@property(nonatomic, copy)NSString*             message;
@property(nonatomic, copy)NSString*             dataValue;

- (id)initWithDict: (NSDictionary*)conditionDict;

@end

@interface CSSubItem : NSObject
{
    NSString*           mSubItemId;
    NSString*           mSubItemTitle;
    NSString*           mItemIconSrc;
    BOOL                mIsSelected;
}

@property(nonatomic, copy)NSString*             subItemId;
@property(nonatomic, copy)NSString*             subItemTitle;
@property(nonatomic, copy)NSString*             itemIconSrc;
@property(nonatomic, assign)BOOL                isSelected;

- (id)initWithDict: (NSDictionary*)subItemDict;

@end

@interface CSSubItemsInfo : NSObject
{
    NSDictionary*               mSubItemLayoutInfo;
    NSArray*                    mSubItems;
}

@property(nonatomic, strong)NSDictionary*               subItemLayoutInfo;
@property(nonatomic, strong)NSArray*                    subItems;

- (id)initWithDict: (NSDictionary*)subItemsInfoDict;

@end

@interface CresFormFieldData : NSObject
{
    NSString*           mFieldID;
    CresFieldType       mFieldType;
    NSString*           mFieldValue;
    BOOL                mIsRequired;
    NSString*           mFieldTitle;
    NSString*           mFieldPlaceHolder;
    NSString*           mFieldHint;
    NSString*           mFormKey;
    BOOL                mEditable;
    
    //Default is EVisibilityInDefaultMode i.e. visible if no visibilit condition available
    //Only visible whwn blank form is open to fill. once filled and open again for editing mode will change
    VisibilityInMode    mVisibilityInMode;
    
    //Field having Icon and Text(ECresFieldTypeIconCell)
    //Field having Icon and Text(ECresFieldTypeProfileImage)
    id                  mFieldIconSrc;
    
    
    DataBinder*         mDataBinder;    //In Case of Data binder
    BOOL                mCanDelete;    //In Case of Data binder
    NSString*           mGeneratedFromItemID; //Fields those are generated from picker binder
    
    NSArray*            mConditions;
    CSSubItemsInfo*     mSubItemsInfo;
}

@property(nonatomic, copy)NSString*                   fieldID;
@property(nonatomic)CresFieldType                     fieldType;
@property(nonatomic, copy)NSString*                   fieldValue;
@property(nonatomic, assign)BOOL                      editable;
@property(nonatomic, assign)BOOL                      isRequired;
@property(nonatomic, assign)VisibilityInMode          visibilityInMode;
@property(nonatomic, copy)NSString*                   fieldTitle;
@property(nonatomic, copy)NSString*                   fieldPlaceHolder;
@property(nonatomic, strong)DataBinder*               dataBinder;
@property(nonatomic, copy)NSString*                   fieldHint;
@property(nonatomic, copy)NSString*                   formKey;

@property(nonatomic, copy)id                          fieldIconSrc;
@property(nonatomic, assign)BOOL                      canDelete;
@property(nonatomic, copy)NSString*                   generatedFromItemID;
@property(nonatomic, strong)NSArray*                  conditions;
@property(nonatomic, strong)CSSubItemsInfo*           subItemsInfo;

- (id)initWithDict: (NSDictionary*)fieldInfo
     andDataBinder: (DataBinder*)dataBinder;
- (CresFieldType)fieldTypeFromTypeString: (NSString*)typeStr;

//For the field Generated by the binder field mention in below method's comm.
//Must Call this method to bind that with this field
- (void)associatedBinderField: (CresFormFieldData*)fieldData;

//For the field responsible for adding new fields.
//Must Call this method to bind them with this field
- (void)addNewGeneratedField: (CresFormFieldData*)fieldData;

@end

@interface CSPageNavigator : NSObject
{
    CSPageNavigationType        mNavigationType;
    NSString*                   mNextImageName;
    NSString*                   mPreviousImageName;
}

@property(nonatomic, assign)CSPageNavigationType        navigationType;
@property(nonatomic, strong)NSString*                   nextImageName;
@property(nonatomic, strong)NSString*                   previousImageName;

- (id)initWithDict: (NSDictionary*)pageNavigationInfo;
- (CSPageNavigationType)navigationTypeFrom: (NSString*)navigationTypeStr;

@end

@interface CresFormPageData : NSObject
{
    NSArray*                mFields;
    NSUInteger              mPageIndex;
    NSString*               mPageID;
    NSString*               mNextPageSelectorTitle;
}

@property(nonatomic, readwrite)NSArray*                 fields;
@property(nonatomic, readonly)NSUInteger                pageIndex;
@property(nonatomic, copy)NSString*                     pageId;
@property(nonatomic, copy)NSString*                     nextPageSelectorTitle;


- (id)initWithDict: (NSDictionary*)formPageInfo
     andPageIndex: (NSUInteger)pageIndex;
- (void)fillDataBinderFieldTemplate: (CresFormFieldData*)fieldData
                           withInfo: (NSDictionary*)info;
- (CresFormFieldData*)fieldFromTemplate: (NSString*)fieldTemplate;
- (void)addField: (CresFormFieldData*)fieldData atIndex: (NSInteger)index;
- (void)deleteField: (CresFormFieldData*)fieldData;
- (void)deleteNewAddedFileds;

@end

@interface CresFormData : NSObject
{
    NSInteger               mFormId;
    NSString*               mFormName;
    NSString*               mFormDescription;
    NSArray*                mFormPages;
    ScrollType              mPageScrollType;
    CSPageNavigator*        mPageNavigator;
}

-(id)initWithDict: (NSDictionary*)formDataInfo;

@property(nonatomic, readwrite)NSArray*                 formPages;
@property(nonatomic, copy)NSString*                     formName;
@property(nonatomic, copy)NSString*                     formDescription;
@property(nonatomic, readonly)ScrollType                pageScrollType;
@property(nonatomic, readonly)NextPageSelectorType      nextPageSelectorType;
@property(nonatomic, assign, readonly)NSInteger         formId;
@property(nonatomic, strong)CSPageNavigator*            pageNavigator;

@end