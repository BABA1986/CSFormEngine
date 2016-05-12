//
//  CresFormPageView.m
//  Edumation
//
//  Created by Deepak on 02/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CresFormPageView.h"
#import "MBProgressHUD.h"
#import "CSFieldSizeCalculator.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kDefaultFieldHeight            44.0f
#define kProfileImageFieldHeight       100.0f
#define kSelectedRoleFieldHeight       100.0f
#define kSocialIconsFieldHeight        190.0f
#define kDefaultGapFieldHeight         20.0f
#define kLinkTextFieldHeight           60.0f
#define kDropDownFieldHeight           64.0f


@interface CresFormPageView (Private)

- (void)initInternalPageScroller; //Always Scroll Vertical
- (void)setUpPage;

- (void)updateCursor;
- (void)updateCursorY: (CGFloat)yOffset;
- (CGRect)getAvailableRect;
- (CGRect)getAvailableRectInHeight: (CGFloat)height;
- (void)resignAllKeyboards;

@end

@interface CresFormPageView ()

{
    CGPoint             mCursor;
    BOOL                pageViewMovesUp;//To check conflict occur between textfield view and keyboard
    CGFloat             heightPageMoveUp;//Shift y of scrollView contentOffset
}

@end

@implementation CresFormPageView

@synthesize pageData = mPageData;
@synthesize delegate = mDelegate;
@synthesize isOpenForEditExistingValue = mIsOpenForEditExistingValue;


- (void)awakeFromNib
{
    [super awakeFromNib];
    mIsOpenForEditExistingValue = FALSE;
    [self initInternalPageScroller];
    [self setUpPage];
}

- (instancetype)initWithFrame: (CGRect)frame
              andFormPageData: (CresFormPageData*)pageData
                  andDelegate: (id<CresFormPageViewDelegate>)delegate
        openForEditSavedValue: (BOOL)editSavedValue
{
    self = [super initWithFrame: frame];
    if (self)
    {
        mDelegate = delegate;
        mPageData = pageData;
        self.backgroundColor = [UIColor clearColor];
        mIsOpenForEditExistingValue = editSavedValue;
        
        [self setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        
        [self initInternalPageScroller];
        [self setUpPage];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    mScrollView.frame = CGRectInset(self.bounds, 0.0, 0.0);
}

- (void)reloadPage
{
    CGPoint lContentOffset = mScrollView.contentOffset;
    
    [mScrollView removeFromSuperview];
    mScrollView = nil;
    mCursor = CGPointZero;
    
    [self initInternalPageScroller];
    [self setUpPage];
    mScrollView.contentOffset = lContentOffset;
}

- (BOOL)areAllFieldsMeetsConditions
{
    BOOL lRetVal = TRUE;
    NSArray* lSubViews = mScrollView.subviews;
    for (UIView* lFieldView in lSubViews)
    {
        if ([lFieldView isKindOfClass: [CresFieldBaseView class]])
        {
            CresFieldBaseView* lCresFieldBaseView = (CresFieldBaseView*)lFieldView;
            if (![lCresFieldBaseView isFieldFullfillConditions])
            {
                lRetVal = FALSE;
                break;
            }
        }
    }
    return lRetVal;
}

/*Always Scroll Vertical.*/
- (void)initInternalPageScroller
{
    mScrollView = [[UIScrollView alloc] init];
    mScrollView.frame = self.bounds;
//    mScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    mScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview: mScrollView];
}

- (void)setUpPage
{
    if (!mPageData)
        return;
    
    NSArray* lFields = mPageData.fields;
    
    for (CresFormFieldData* lFieldData in lFields)
    {
        if (lFieldData.visibilityInMode == EVisibilityInModeEdit && !mIsOpenForEditExistingValue)
            continue;
        
        CresFieldType lFieldType = lFieldData.fieldType;
        CGRect lRect = CGRectZero;
        CGSize lFieldSize = CGSizeZero;
        switch (lFieldType)
        {
            case ECresFieldTypeProfileImage:
                lRect = [self getAvailableRectInHeight: kProfileImageFieldHeight];
                break;
            case ECresFieldTypeRoleIcon:
                lRect = [self getAvailableRectInHeight: kSelectedRoleFieldHeight];
                break;
            case ECresFieldTypeSocialIcons:
                lRect = [self getAvailableRectInHeight: kSocialIconsFieldHeight];
                break;
            case ECresFieldTypeDefaultGap:
                [self updateCursorY:kDefaultGapFieldHeight];
                break;
            case ECresFieldTypeTermsCondition:
                lRect = [self getAvailableRectInHeight: kLinkTextFieldHeight];
                break;
            case ECresFieldTypeListHeader:
                lRect = [self getAvailableRectInHeight: kLinkTextFieldHeight];
                break;
            case ECresFieldTypeListSingleSelectDropDown:
            case ECresFieldTypeListMultiSelectDropDown:
                lRect = [self getAvailableRectInHeight: kDropDownFieldHeight];
                break;
            case ECresFieldTypeObjectiveSingleChoice:
            case ECresFieldTypeObjectiveMultiChoice:
                lFieldSize = [CSFieldSizeCalculator sizeFitsForField: lFieldData constrainedToSize: CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
                lRect = [self getAvailableRectInHeight: lFieldSize.height];
                break;
            case ECresFieldTypePlainText:
            lFieldSize = [CSFieldSizeCalculator sizeFitsForField: lFieldData constrainedToSize: CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
            lRect = [self getAvailableRectInHeight: lFieldSize.height];
            break;

            case ECresFieldTypeUnknown:
                continue;
                break;
            default:
                lRect = [self getAvailableRect];
                break;
        }
        
        CresFieldBaseView* lCresFieldBaseView = [[CresFieldBaseView alloc] initWithFrame: lRect andFieldData: lFieldData andDelegate: self];
        [mScrollView addSubview: lCresFieldBaseView];
    }
}

- (void)updateCursor
{
    mCursor.y += kDefaultFieldHeight;
    
    CGSize lContentSize = CGSizeMake(0, mCursor.y);
    mScrollView.contentSize = lContentSize;
}

- (void)updateCursorY: (CGFloat)yOffset
{
    mCursor.y += yOffset;
    
    CGSize lContentSize = CGSizeMake(0, mCursor.y);
    mScrollView.contentSize = lContentSize;
}

- (CGRect)getAvailableRect
{
    CGRect lFieldRect = CGRectMake(mCursor.x, mCursor.y, CGRectGetWidth(mScrollView.bounds), kDefaultFieldHeight);
    [self updateCursor];
    return lFieldRect;
}

- (CGRect)getAvailableRectInHeight: (CGFloat)height
{
    CGRect lFieldRect = CGRectMake(mCursor.x, mCursor.y, CGRectGetWidth(mScrollView.bounds), height);
    [self updateCursorY: height];
    return lFieldRect;
}

- (void)resignAllKeyboards
{
    [self endEditing: TRUE];
}

#pragma mark-
#pragma mark- CresFieldBaseViewDelegate
#pragma mark-

#pragma mark- CresDatePickerField

- (void)presentPickerInView: (UIView**)view
                    andRect: (CGRect*)rect
       forCresFieldBaseView: (CresFieldBaseView*)cresFieldBaseView
{
    CGRect lRect = self.bounds;
    
    lRect.size.height *= 0.40;
    lRect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(lRect);

    lRect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(lRect);    
    *rect = lRect;
    *view = self;
}

#pragma mark- AddFieldView

- (void)cresFieldBaseView: (CresFieldBaseView*)cresFieldBaseView
           addItemsOnPage: (NSArray*)items
              addBindType: (BindType)bindType
{
    if (bindType == EBindTypeSearchAndAddField)
    {
        [mPageData deleteNewAddedFileds];
        CresFormFieldData* lFieldData = cresFieldBaseView.fieldData;
        [lFieldData.dataBinder.generatedFields removeAllObjects];
    }
    
    for (NSDictionary* lItemInfo in items)
    {
        NSArray* lFields = mPageData.fields;
        NSInteger lInsertAtIndex = [lFields indexOfObject: cresFieldBaseView.fieldData];
        CresFormFieldData* lNewField = [mPageData fieldFromTemplate: cresFieldBaseView.fieldData.dataBinder.fieldTemplate];
        [mPageData fillDataBinderFieldTemplate: lNewField withInfo: lItemInfo];
        [mPageData addField: lNewField atIndex: lInsertAtIndex];
        
        //Field that adds the new Field
        CresFormFieldData* lFieldData = cresFieldBaseView.fieldData;
        [lFieldData addNewGeneratedField: lNewField];
        
        //Field that associate or generated by Field (cresFieldBaseView)
        [lNewField associatedBinderField: lFieldData];
    }
    
    [self reloadPage];
}

- (void)deleteFieldOnPageForCresFieldBaseView: (CresFieldBaseView*)cresFieldBaseView
{
    NSArray* lFields = mPageData.fields;
    CresFormFieldData* lFieldData = nil;
    
    for(lFieldData in lFields)
    {
        if(lFieldData.fieldType == ECresFieldTypeAddField)
        {
            NSMutableArray* lGenFieldsNeedToDelete = [[NSMutableArray alloc] init];
            NSMutableArray* lSelectedFieldsNeedToDelete = [[NSMutableArray alloc] init];

            NSMutableArray* lGeneratedFields = lFieldData.dataBinder.generatedFields;
            for(CresFormFieldData* lGeneratedFieldData in lGeneratedFields)
            {
                NSString* lId = lGeneratedFieldData.fieldID;
                if(lFieldData.dataBinder.bindType == EBindTypeAddField)
                    lId = lGeneratedFieldData.generatedFromItemID;
                    
                if([lId isEqualToString: cresFieldBaseView.fieldData.generatedFromItemID])
                {
                    [lGenFieldsNeedToDelete addObject: lGeneratedFieldData];
                    
                    for(NSDictionary* lSelectedField in lFieldData.dataBinder.selectedItems)
                    {
                        if([lId isEqualToString: [lSelectedField objectForKey: @"ID"]])
                        {
                            [lSelectedFieldsNeedToDelete addObject: lSelectedField];
                            break;
                        }
                    }
                    
                    break;
                }
            }
        
            [lFieldData.dataBinder.generatedFields removeObjectsInArray:lGenFieldsNeedToDelete];
            [lFieldData.dataBinder.selectedItems removeObjectsInArray:lSelectedFieldsNeedToDelete];
        }
    }
    
    [mPageData deleteField: cresFieldBaseView.fieldData];
    
    [self reloadPage];
}

- (void)willPresentPickerOnPageForFieldBaseView: (CresFieldBaseView*)baseFieldView
{
    [self resignAllKeyboards];
}

#pragma mark- SocialFieldLogin

-(BOOL)willStartSigning:(CresFieldBaseView *)CresFieldBaseView
          withLoginType:(NSInteger ) type;
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    return true;
}

- (NSArray*)signUpTypesCresFieldBaseView:(CresFieldBaseView *)cresFieldBaseView
{
    if ([mDelegate respondsToSelector: @selector(socialSignupOptionsForFormPage:)])
    {
        return [mDelegate socialSignupOptionsForFormPage: self];
    }
    
    return nil;
}

-(void)socialLogin:(CSSocialLoginView *)loginView
 didSignInWithType:(NSString *)type
      WithResponse:(CSSocialLoginUser *)response
         withError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self animated:YES];
    
    if (!error)
    {
        if ([mDelegate respondsToSelector:@selector(socialLoginCompletedWithData:onCresFormPageView:WithError:)])
        {
            [mDelegate socialLoginCompletedWithData: response onCresFormPageView: self WithError:error];
        }

    }
    else
    {
        if ([mDelegate respondsToSelector: @selector(showBannerForPage:withErrorMesage:withImageName:)])
        {
            [mDelegate showBannerForPage: self withErrorMesage: [error localizedDescription] withImageName: @"loginerror.png"];
        }
    }
}

#pragma mark- VATextField(view scroll up when keyboard show and scroll down on keyboard hide)

//To find current screen height
-(CGRect)currentScreenBoundsDependOnOrientation
{
    CGRect lScreenBounds = [UIScreen mainScreen].bounds ;
    CGFloat lWidth = CGRectGetWidth(lScreenBounds)  ;
    CGFloat lHeight = CGRectGetHeight(lScreenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        lScreenBounds.size = CGSizeMake(lWidth, lHeight);
    }
    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        lScreenBounds.size = CGSizeMake(lHeight, lWidth);
    }
    return lScreenBounds;
}

-(BOOL)textFieldBeginEditing:(CresFieldBaseView *)cresFieldBaseView
{
    //To change return key text to next if any textfield is there after selected field
    NSArray* viewSubview = self.subviews;
    UIScrollView* lScrollView = [viewSubview objectAtIndex:0];
    UITextField *presentTextValue, *nextTextValue ;
    for(int i = 0; i < [lScrollView.subviews count]; i++)
    {
        CresFieldBaseView* scrollSubView = [lScrollView.subviews objectAtIndex:i];
        if(scrollSubView == cresFieldBaseView)
        {
            for(int j = i + 1; j<[lScrollView.subviews count]; j++)
            {
                if([[lScrollView.subviews objectAtIndex:j]isKindOfClass:[CresFieldBaseView class]])
                {
                    UIView* fieldView = [[lScrollView.subviews objectAtIndex:j]valueForKey:@"mFieldBaseView"];
                    NSArray *lView = fieldView.subviews;
                    for(int i = 0; i < lView.count; i++)
                    {
                        if([[lView objectAtIndex:i]isKindOfClass:[VATextField class]])
                            nextTextValue = [[lView objectAtIndex:i]valueForKey:@"textField"];
                        if(nextTextValue)
                            break;
                    }
                }
                if(nextTextValue)
                    break;
            }
            break;
        }
    }
    UIView* fieldView = [cresFieldBaseView valueForKey:@"mFieldBaseView"];
    NSArray *lView = fieldView.subviews;
    for(int i = 0; i < lView.count; i++)
    {
        presentTextValue = [[lView objectAtIndex:i]valueForKey:@"textField"];
        if(presentTextValue)
            break;
    }
    
    if (nextTextValue)
        [presentTextValue setReturnKeyType:UIReturnKeyNext];
    else
        [presentTextValue setReturnKeyType:UIReturnKeyDefault];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.barTintColor=[UIColor lightGrayColor];
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignAllKeyboards)],
                           nil];
    [numberToolbar sizeToFit];
    presentTextValue.inputAccessoryView = numberToolbar;
    
    CGRect lFieldRect = cresFieldBaseView.frame;
    UIApplication* lApplication = [UIApplication sharedApplication];
    UIWindow* lWindow = lApplication.delegate.window;
    CGRect lFieldRectInWindow = [self convertRect: lFieldRect toView: lWindow.rootViewController.view];
    CGFloat lKeyBoardHeight = IS_IPAD ? 400.0 : 216.0;
    lKeyBoardHeight += 44.0;
    CGPoint lScrollOffset = mScrollView.contentOffset;
    CGSize lScrollContentSize = mScrollView.contentSize;
    CGRect lScreenRect = [self currentScreenBoundsDependOnOrientation];
    CGFloat lKeyboardOriginY = (CGRectGetHeight(lScreenRect) - lKeyBoardHeight);
    CGFloat lFieldMaxY = CGRectGetMaxY(lFieldRectInWindow);
    CGFloat lDeffY = (lKeyboardOriginY - (lFieldMaxY - lScrollOffset.y));
    
    if (lDeffY < 0)
    {
        lScrollOffset.y += ABS(lDeffY);
        pageViewMovesUp = TRUE;
    }
    
    lScrollContentSize.height += lKeyBoardHeight;
    heightPageMoveUp = ABS(lDeffY);
    [mScrollView setContentSize:lScrollContentSize];
    [mScrollView setContentOffset: lScrollOffset animated: TRUE];
    return true;
}

-(BOOL)textFieldEndEditing:(CresFieldBaseView *)cresFieldBaseView
{
    if(pageViewMovesUp)
    {
        CGPoint lScrollOffset = mScrollView.contentOffset;
        if(lScrollOffset.y < heightPageMoveUp)
        {
            pageViewMovesUp = FALSE;
        }
        else
        {
            lScrollOffset.y -= heightPageMoveUp;
            [mScrollView setContentOffset: lScrollOffset animated: TRUE];
            pageViewMovesUp = FALSE;
        }
    }
    
    CGFloat lKeyBoardHeight = IS_IPAD ? 400.0 : 216.0;
    lKeyBoardHeight += 44.0;
    CGSize lScrollContentSize = mScrollView.contentSize;
    lScrollContentSize.height -= lKeyBoardHeight;
    [mScrollView setContentSize:lScrollContentSize];
    
    return true;
}

-(BOOL)textFieldShouldReturn:(CresFieldBaseView *)cresFieldBaseView
{
    NSArray* viewSubview = self.subviews;
    UIScrollView* lScrollView = [viewSubview objectAtIndex:0];
    UITextField *presentTextValue, *nextTextValue ;
    for(int i = 0; i<[lScrollView.subviews count]; i++)
    {
        CresFieldBaseView* scrollSubView = [lScrollView.subviews objectAtIndex:i];
        if(scrollSubView == cresFieldBaseView)
        {
            for(int j = i + 1; j<[lScrollView.subviews count]; j++)
            {
                if([[lScrollView.subviews objectAtIndex:j]isKindOfClass:[CresFieldBaseView class]])
                {
                    UIView* fieldView = [[lScrollView.subviews objectAtIndex:j]valueForKey:@"mFieldBaseView"];
                    NSArray *lView = fieldView.subviews;
                    for(int i = 0; i < lView.count; i++)
                    {
                        if([[lView objectAtIndex:i]isKindOfClass:[VATextField class]])
                            nextTextValue = [[lView objectAtIndex:i]valueForKey:@"textField"];
                        
                        if(nextTextValue)
                            break;
                    }
                }
                if(nextTextValue)
                    break;
            }
            break;
        }
    }
    
    UIView* fieldView = [cresFieldBaseView valueForKey:@"mFieldBaseView"];
    NSArray *lView = fieldView.subviews;
    for(int i = 0; i < lView.count; i++)
    {
        presentTextValue = [[lView objectAtIndex:i]valueForKey:@"textField"];
        if(presentTextValue)
            break;
    }
    
    [presentTextValue resignFirstResponder];
    if (nextTextValue)
        [nextTextValue becomeFirstResponder];
    // Not found, so remove keyboard.
    
    return true;
}

-(void)showValidationError:(CresFieldBaseView *)cresFieldBaseView WithErrorMesage:(NSString *)msg WithImageName:(NSString *)imageName
{
    if ([mDelegate respondsToSelector: @selector(showBannerForPage:withErrorMesage:withImageName:)])
    {
        [mDelegate showBannerForPage: self withErrorMesage: msg withImageName: imageName];
    }
}

@end
