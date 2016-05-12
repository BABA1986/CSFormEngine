//
//  CresFormData.m
//  Edumation
//
//  Created by Deepak on 02/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CresFormData.h"


@implementation DataBinder

@synthesize bindType = mBindType;
@synthesize sourceUrl = mSourceUrl;
@synthesize fieldTemplate = mFieldTemplate;
@synthesize selectedItems = mSelectedItems;

@synthesize associatedBinderField = mAssociatedBinderField;
@synthesize generatedFields = mGeneratedFields;

- (id)initWithDict: (NSDictionary*)dataBinderInfo
{
    self = [super init];
    
    if (self)
    {
        NSString* lType = [dataBinderInfo objectForKey: @"Type"];
        self.bindType = (!lType || [lType isKindOfClass: [NSNull class]]) ? EBindTypeNone : [lType integerValue];
        
        NSString* lSource = [dataBinderInfo objectForKey: @"Source"];
        self.sourceUrl = (!lSource || [lSource isKindOfClass: [NSNull class]]) ? @"" : lSource;
        
        NSString* lFieldTemplate = [dataBinderInfo objectForKey: @"FieldTemplate"];
        self.fieldTemplate = (!lFieldTemplate || [lFieldTemplate isKindOfClass: [NSNull class]]) ? @"" : lFieldTemplate;
        
        self.selectedItems = [[NSMutableArray alloc] init];
        
        self.generatedFields = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DataBinder* lDataBinder = [[self class] allocWithZone: zone];
    lDataBinder.bindType = self.bindType;
    lDataBinder.sourceUrl = self.sourceUrl;
    lDataBinder.fieldTemplate = self.fieldTemplate;
    lDataBinder.selectedItems = [self.selectedItems copyWithZone: zone];
    lDataBinder.generatedFields = [self.generatedFields copyWithZone: zone];
    lDataBinder.associatedBinderField = self.associatedBinderField;
    return lDataBinder;
}

@end

@implementation Condition

@synthesize conditionType = mConditionType;
@synthesize message = mMessage;
@synthesize dataValue = mDataValue;

- (id)initWithDict: (NSDictionary*)conditionDict
{
    self = [super init];
    
    if (self)
    {
        NSString* lConditionType = [conditionDict objectForKey: @"type"];
        lConditionType  = (!lConditionType || [lConditionType isKindOfClass: [NSNull class]]) ? @"" : lConditionType;
        self.conditionType = lConditionType;
        
        NSString* lMessage = [conditionDict objectForKey: @"msg"];
        lMessage  = (!lMessage || [lMessage isKindOfClass: [NSNull class]]) ? @"" : lMessage;
        self.message = lMessage;
        
        NSString* lDataValue = [conditionDict objectForKey: @"data"];
        self.dataValue = (!lDataValue || [lDataValue isKindOfClass: [NSNull class]]) ? @"" : lDataValue;
    }
    
    return self;
}

@end

@implementation CSSubItem

@synthesize subItemId = mSubItemId;
@synthesize subItemTitle = mSubItemTitle;
@synthesize isSelected = mIsSelected;
@synthesize itemIconSrc = mItemIconSrc;

- (id)initWithDict: (NSDictionary*)subItemDict
{
    self = [super init];
    
    if (self)
    {
        NSString* lSubItemId = [subItemDict objectForKey: @"itemId"];
        assert(lSubItemId != nil || ![lSubItemId isKindOfClass: [NSNull class]]);
        self.subItemId = lSubItemId;
        
        NSString* lSubItemTitle = [subItemDict objectForKey: @"itemTitle"];
        self.subItemTitle = lSubItemTitle;
        
        NSString* lSubItemSrc = [subItemDict objectForKey: @"itemSrc"];
        self.itemIconSrc = lSubItemSrc;
        
        NSNumber* lIsSelectedVal = [subItemDict objectForKey: @"isSelected"];
        self.isSelected = [lIsSelectedVal boolValue];
    }
    
    return self;
}


@end

@implementation CSSubItemsInfo

@synthesize subItemLayoutInfo = mSubItemLayoutInfo;
@synthesize subItems = mSubItems;

- (id)initWithDict: (NSDictionary*)subItemsInfoDict
{
    self = [super init];
    
    if (self)
    {
        NSArray* lSubItems = [subItemsInfoDict objectForKey: @"Items"];
        NSMutableArray* lMSubItems = [[NSMutableArray alloc] init];
        for (NSDictionary* lSubItem in lSubItems)
        {
            CSSubItem* lCSSubItem = [[CSSubItem alloc] initWithDict: lSubItem];
            [lMSubItems addObject: lCSSubItem];
        }
        
        self.subItems = lMSubItems;
        self.subItemLayoutInfo = [subItemsInfoDict objectForKey: @"ItemLayoutParams"];
    }
    
    return self;
}

@end

@implementation CresFormFieldData

@synthesize fieldID = mFieldID;
@synthesize fieldType = mFieldType;
@synthesize fieldValue = mFieldValue;
@synthesize isRequired = mIsRequired;
@synthesize editable = mEditable;
@synthesize visibilityInMode = mVisibilityInMode;
@synthesize fieldTitle = mFieldTitle;
@synthesize fieldPlaceHolder = mFieldPlaceHolder;
@synthesize dataBinder = mDataBinder;
@synthesize fieldHint = mFieldHint;
@synthesize formKey = mFormKey;
@synthesize fieldIconSrc = mFieldIconSrc;
@synthesize canDelete = mCanDelete;
@synthesize generatedFromItemID = mGeneratedFromItemID;
@synthesize conditions = mConditions;
@synthesize subItemsInfo = mSubItemsInfo;

- (id)initWithDict: (NSDictionary*)fieldInfo
     andDataBinder: (DataBinder*)dataBinder
{
    self = [super init];
    if (self)
    {
        NSString* lFieldType = [fieldInfo objectForKey: @"Type"];
        lFieldType  = (!lFieldType || [lFieldType isKindOfClass: [NSNull class]]) ? @"" : lFieldType;
        self.fieldType = [self fieldTypeFromTypeString: lFieldType];

        NSString* lFieldId = [fieldInfo objectForKey: @"Id"];
        self.fieldID = lFieldId;
        
        NSString* lFieldvalue = [fieldInfo objectForKey: @"Value"];
        self.fieldValue = (!lFieldvalue || [lFieldvalue isKindOfClass: [NSNull class]]) ? @"" : lFieldvalue;
        
        BOOL lIsRequired = [[fieldInfo objectForKey: @"isRequired"]boolValue];
        self.isRequired = lIsRequired;

        NSString* lFieldTitle = [fieldInfo objectForKey: @"Label"];
        self.fieldTitle = (!lFieldTitle || [lFieldTitle isKindOfClass: [NSNull class]]) ? @"" : lFieldTitle;
        
        NSString* lFieldPlaceHolder = [fieldInfo objectForKey: @"PlaceholderMsg"];
        self.fieldPlaceHolder = (!lFieldPlaceHolder || [lFieldPlaceHolder isKindOfClass: [NSNull class]]) ? @"" : lFieldPlaceHolder;
        
        if (!dataBinder)
            dataBinder = [[DataBinder alloc] initWithDict: nil];
        self.dataBinder = dataBinder;
        
        NSString* lFieldHint = [fieldInfo objectForKey: @"Hint"];
        self.fieldHint = (!lFieldHint || [lFieldHint isKindOfClass: [NSNull class]]) ? @"" : lFieldHint;
        
        id lIconSource = [fieldInfo objectForKey: @"IconSource"];
        self.fieldIconSrc = (!lIconSource || [lIconSource isKindOfClass: [NSNull class]]) ? @"" : lIconSource;
        
        NSString* lFormKey = [fieldInfo objectForKey: @"FormKey"];
        self.formKey = (!lFormKey || [lFormKey isKindOfClass: [NSNull class]]) ? @"" : lFormKey;
        
        NSArray* lConditions = [fieldInfo objectForKey: @"Conditions"];
        NSMutableArray* lMConditions = [[NSMutableArray alloc] init];
        for (NSDictionary* lCondition in lConditions)
        {
            Condition* lFieldCondition = [[Condition alloc] initWithDict: lCondition];
            [lMConditions addObject: lFieldCondition];
            
            NSString* lVisibility = lFieldCondition.dataValue;
            NSString* lType = lFieldCondition.conditionType;
            
            if ([lType compare: @"Visibility" options: NSCaseInsensitiveSearch] == NSOrderedSame)
            {
                if (!lVisibility.length || [lVisibility isKindOfClass: [NSNull class]])
                {
                    self.visibilityInMode = EVisibilityInDefaultMode;
                }
                else if ([lVisibility isEqualToString: @"Both"])
                {
                    self.visibilityInMode = EVisibilityInBothMode;
                }
                else if ([lVisibility isEqualToString: @"EditModeOnly"])
                {
                    self.visibilityInMode = EVisibilityInModeEdit;
                }
            }
        }
        
        self.conditions = lMConditions;
        
        NSDictionary* lSubItemsInfo = [fieldInfo objectForKey: @"SubItemsInfo"];
        if (lSubItemsInfo)
            self.subItemsInfo = [[CSSubItemsInfo alloc] initWithDict: lSubItemsInfo];

        self.editable = TRUE;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CresFormFieldData* lCopedField = [[self class] allocWithZone: zone];
    lCopedField.fieldID = self.fieldID;
    lCopedField.fieldType = self.fieldType;
    lCopedField.fieldValue = self.fieldValue;
    lCopedField.isRequired = self.isRequired;
    lCopedField.editable = self.editable;
    lCopedField.visibilityInMode = self.visibilityInMode;
    lCopedField.fieldTitle = self.fieldTitle;
    lCopedField.fieldPlaceHolder = self.fieldPlaceHolder;
    lCopedField.dataBinder = [self.dataBinder copyWithZone: zone];
    lCopedField.fieldHint = self.fieldHint;
    lCopedField.formKey = self.formKey;
    lCopedField.fieldIconSrc = self.fieldIconSrc;
    lCopedField.canDelete = self.canDelete;
    lCopedField.generatedFromItemID = self.generatedFromItemID;
    lCopedField.conditions = self.conditions;
    
    return lCopedField;
}

- (CresFieldType)fieldTypeFromTypeString: (NSString*)fieldTypeStr
{
    if ([fieldTypeStr compare: @"BUNDLE-ICON" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeRoleIcon;
    }
    else if ([fieldTypeStr compare: @"VSPACE" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeDefaultGap;
    }
    else if ([fieldTypeStr compare: @"EMAIL" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeEmail;
    }
    else if ([fieldTypeStr compare: @"STRING" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeText;
    }
    else if ([fieldTypeStr compare: @"PASSWORD" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypePassword;
    }
    else if ([fieldTypeStr compare: @"SEPARATOR-WITH-LABEL-BELOW" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeSeperator;
    }
    else if ([fieldTypeStr compare: @"SOCIAL-LOGIN" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeSocialIcons;
    }
    else if ([fieldTypeStr compare: @"IMAGE-BLOB" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeProfileImage;
    }
    else if ([fieldTypeStr compare: @"HTML-LABEL" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeTermsCondition;
    }
    else if ([fieldTypeStr compare: @"BUTTON" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeAddField;
    }
    else if ([fieldTypeStr compare: @"DATE-M" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeDatePicker;
    }
    else if ([fieldTypeStr compare: @"DATE-M" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeDatePicker;
    }
    else if ([fieldTypeStr compare: @"CELL" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeIconCell;
    }
    else if ([fieldTypeStr compare: @"NUMERIC" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeNumeric;
    }
    else if ([fieldTypeStr compare: @"ListHeader" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeListHeader;
    }
    else if ([fieldTypeStr compare: @"DropDownSingleSelect" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeListSingleSelectDropDown;
    }
    else if ([fieldTypeStr compare: @"DropDownMultiSelect" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeListMultiSelectDropDown;
    }
    else if ([fieldTypeStr compare: @"ObjectiveQuestionSingleSelect" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeObjectiveSingleChoice;
    }
    else if ([fieldTypeStr compare: @"ObjectiveQuestionMultiSelect" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypeObjectiveMultiChoice;
    }
    else if ([fieldTypeStr compare: @"PlainText" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return ECresFieldTypePlainText;
    }

    return ECresFieldTypeUnknown;
}

- (void)associatedBinderField: (CresFormFieldData*)fieldData
{
    self.dataBinder.associatedBinderField = fieldData;
}

- (void)addNewGeneratedField: (CresFormFieldData*)fieldData
{
    if (!fieldData)
        return;
    
    [self.dataBinder.generatedFields addObject: fieldData];
}

@end

@interface CresFormPageData (Private)
- (DataBinder*)dataBinderForField: (NSDictionary*)lFormField
                           onPage: (NSDictionary*)formPageInfo;
@end

@implementation CSPageNavigator

@synthesize navigationType = mNavigationType;
@synthesize nextImageName = mNextImageName;
@synthesize previousImageName = mPreviousImageName;

- (id)initWithDict: (NSDictionary*)pageNavigationInfo
{
    self = [super init];
    if (self)
    {
        NSString* lNavigationTypeStr = [pageNavigationInfo objectForKey: @"navigationType"];
        self.navigationType = [self navigationTypeFrom: lNavigationTypeStr];
        
        NSString* lNextImageName = [pageNavigationInfo objectForKey: @"nextImage"];
        self.nextImageName = !lNextImageName.length ? @"next.png" : lNextImageName;
        NSString* lPreviousImageName = [pageNavigationInfo objectForKey: @"previousImage"];
        self.previousImageName = !lPreviousImageName.length ? @"previous.png" : lPreviousImageName;
    }
    
    return self;
}

- (CSPageNavigationType)navigationTypeFrom: (NSString*)navigationTypeStr
{
    CSPageNavigationType lCSPageNavigationType = ECSPageNavigationNone;
    if (!navigationTypeStr)
    {
        return ECSPageNavigationDefault;
    }
    
    if ([navigationTypeStr compare: @"PaginationNone" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        lCSPageNavigationType = ECSPageNavigationDefault;
    }
    if ([navigationTypeStr compare: @"PaginationDefault" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        lCSPageNavigationType = ECSPageNavigationDefault;
    }
    else if ([navigationTypeStr compare: @"PaginationNextPrevious" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        lCSPageNavigationType = ECSPageNavigationNextPrevious;
    }
    else if ([navigationTypeStr compare: @"PaginationDot" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        lCSPageNavigationType = ECSPageNavigationPaginationDot;
    }
    else if ([navigationTypeStr compare: @"PaginationDotNumber" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        lCSPageNavigationType = ECSPageNavigationPaginationDotNumeric;
    }
    else if ([navigationTypeStr compare: @"PaginationDotCustom" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        lCSPageNavigationType = ECSPageNavigationPaginationCustomDot;
    }
    
    return lCSPageNavigationType;
}

@end

@implementation CresFormPageData

@synthesize fields = mFields;
@synthesize pageIndex = mPageIndex;
@synthesize pageId = mPageID;
@synthesize nextPageSelectorTitle = mNextPageSelectorTitle;

-(id)initWithDict: (NSDictionary*)formPageInfo
     andPageIndex: (NSUInteger)pageIndex
{
    self = [super init];
    if (self)
    {
        NSArray* lFields = [formPageInfo objectForKey: @"Fields"];
        NSMutableArray* lCresFields = [[NSMutableArray alloc] init];
        for (NSDictionary* lFormField in lFields)
        {
            DataBinder* lDataBinder = [self dataBinderForField: lFormField onPage: formPageInfo];
            CresFormFieldData* lFieldData = [[CresFormFieldData alloc] initWithDict: lFormField andDataBinder: lDataBinder];
            [lCresFields addObject: lFieldData];
        }
        
        mPageIndex = pageIndex;
        mFields = [[NSArray alloc] initWithArray: lCresFields];
        self.pageId = [formPageInfo objectForKey: @"Id"];
        
        NSString* lNextSelectorTitle = [formPageInfo objectForKey: @"Button"];
        lNextSelectorTitle = (!lNextSelectorTitle || [lNextSelectorTitle isKindOfClass: [NSNull class]]) ? @"Next" : lNextSelectorTitle;
        self.nextPageSelectorTitle = lNextSelectorTitle;
        
        [self associateFieldsWithBinders];
    }
    
    return self;
}

- (DataBinder*)dataBinderForField: (NSDictionary*)lFormField
                           onPage: (NSDictionary*)formPageInfo
{
    NSArray* lFields = [formPageInfo objectForKey: @"Fields"];
    NSString* lAction = [lFormField objectForKey: @"Action"];
    if (!lAction || [lAction isKindOfClass: [NSNull class]])
        lAction = @"";
    
    BindType lBindype = EBindTypeNone;
    
    NSString* lFieldTemplate = @"";
    if ([lAction compare: @"OpenControl" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        lFieldTemplate = @"{\"Id\":\"TeacherID%@\",\"Type\":\"CELL\",\"Label\":\"\",\"PlaceholderMsg\":\"\",\"FormKey\":\"TeacherID\",\"Conditions\":[]}";
        lBindype = EBindTypeSearchAndAddField;
    }
    else if([lAction compare: @"Replicate" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        lBindype = EBindTypeAddField;
        for (NSDictionary* lField in lFields)
        {
            NSString* lTarget = [lFormField objectForKey: @"Target"];
            NSString* lFieldId = [lField objectForKey: @"Id"];
            
            if ([lTarget isEqualToString: lFieldId])
            {
                NSMutableDictionary* lFieldInfo = [[NSMutableDictionary alloc] initWithDictionary: lField];
                NSData* lTemplateData = [NSJSONSerialization dataWithJSONObject: lFieldInfo options: kNilOptions error: nil];
                lFieldTemplate = [[NSString alloc] initWithData: lTemplateData encoding: NSUTF8StringEncoding];
                break;
            }
        }
    }
    
    NSMutableDictionary* lBinderDict = [[NSMutableDictionary alloc] init];
    [lBinderDict setObject: [NSNumber numberWithInt: lBindype] forKey: @"Type"];
    [lBinderDict setObject: @"" forKey: @"Source"];
    [lBinderDict setObject: lFieldTemplate forKey: @"FieldTemplate"];
    
    DataBinder* lDataBinder = [[DataBinder alloc] initWithDict: lBinderDict];
    return lDataBinder;
}

//Applicable for Replicator Fields Only
- (void)associateFieldsWithBinders
{
    NSArray* lFields = self.fields;
    for(CresFormFieldData* lFieldData in lFields)
    {
        if(lFieldData.dataBinder.bindType == EBindTypeAddField)
        {
            CresFormFieldData* lBindedField = [self fieldFromTemplate: lFieldData.dataBinder.fieldTemplate];
            for(CresFormFieldData* lOtherFieldData in lFields)
            {
                if ([lOtherFieldData.fieldID isEqualToString: lBindedField.fieldID])
                {
                    [lFieldData.dataBinder.generatedFields addObject: lOtherFieldData];
                    break;
                }
            }
        }
    }
}

//In Case of field those are added from picker
- (void)fillDataBinderFieldTemplate: (CresFormFieldData*)fieldData
                           withInfo: (NSDictionary*)info
{
    fieldData.fieldIconSrc = [info objectForKey: @"URL"];
    fieldData.fieldValue = [info objectForKey: @"DisplayName"];
    fieldData.generatedFromItemID = [info objectForKey: @"ID"];
    fieldData.fieldID = [info objectForKey: @"ID"];
}

- (CresFormFieldData*)fieldFromTemplate: (NSString*)fieldTemplate
{
    NSData* lData = [fieldTemplate dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary* lFieldInfo = [NSJSONSerialization JSONObjectWithData:lData options:0 error:nil];
    CresFormFieldData* lTelplateFieldData = [[CresFormFieldData alloc] initWithDict: lFieldInfo andDataBinder: nil];
    lTelplateFieldData.canDelete = TRUE;
    
    return lTelplateFieldData;
}

- (void)addField: (CresFormFieldData*)fieldData atIndex: (NSInteger)index
{
    NSMutableArray* lFields = [NSMutableArray arrayWithArray: mFields];
    [lFields insertObject: fieldData atIndex: index];
    mFields = [[NSArray alloc] initWithArray: lFields];
}

- (void)deleteField: (CresFormFieldData*)fieldData
{
    if (!fieldData)
        return;

    CresFormFieldData* lAssociatedWithField = fieldData.dataBinder.associatedBinderField;
    [lAssociatedWithField.dataBinder.generatedFields removeObject: fieldData];
    
    NSMutableArray* lFields = [NSMutableArray arrayWithArray: mFields];
    [lFields removeObject: fieldData];
    mFields = [[NSArray alloc] initWithArray: lFields];
}

- (void)deleteNewAddedFileds
{
    NSMutableArray* lFields = [NSMutableArray array];
    for (CresFormFieldData* lField in mFields)
    {
        if (!lField.canDelete)
        {
            [lFields addObject: lField];
        }
    }
    
    mFields = [[NSArray alloc] initWithArray: lFields];
}

@end

@implementation CresFormData

@synthesize formPages = mFormPages;
@synthesize formName = mFormName;
@synthesize formDescription = mFormDescription;
@synthesize pageScrollType = mPageScrollType;
@synthesize nextPageSelectorType = mNextPageSelectorType;
@synthesize formId = mFormId;
@synthesize pageNavigator = mPageNavigator;

-(id)initWithDict: (NSDictionary*)formDataInfo
{
    self = [super init];
    if (self)
    {
        NSArray* lPages = [formDataInfo objectForKey: @"Stages"];
        NSInteger lPageIndex = 0;
        NSMutableArray* lCresFormPages = [[NSMutableArray alloc] init];
        for (NSDictionary* lFormPage in lPages)
        {
            CresFormPageData* lPageData = [[CresFormPageData alloc] initWithDict: lFormPage andPageIndex: lPageIndex];
            lPageIndex += 1;
            
            [lCresFormPages addObject: lPageData];
        }
        
        mFormPages = [[NSArray alloc] initWithArray: lCresFormPages];
        self.formName = [formDataInfo objectForKey: @"FormName"];
        self.formDescription = [formDataInfo objectForKey: @"FormDescription"];
        mPageScrollType = EScrollTypeHorizontal;
        mFormId = [[formDataInfo objectForKey: @"FormID"] integerValue];
        
        NSDictionary* lPageNavigatorInfo = [formDataInfo objectForKey: @"PageNavigation"];
        mPageNavigator = [[CSPageNavigator alloc] initWithDict: lPageNavigatorInfo];
    }
    
    return self;
}

@end