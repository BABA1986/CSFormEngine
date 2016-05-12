//
//  CresFormView.m
//  Edumation
//
//  Created by Deepak on 02/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CresFormView.h"
#define kNextSelectorHeight         44.0

@interface CresFormView (Private)

- (void)initPageScroller;
- (void)initPageSelector;
- (void)setUpFormPages;
- (void)unloadAllPages;
- (void)setOffsetToPageIndex: (NSUInteger)pageIndex animated: (bool)animated;
- (BOOL)canMoveToNextPage;
- (void)jumpToPage: (NSUInteger)toPageIndex fromPage: (NSUInteger)fromPageIndex;

@end

@implementation CresFormView

@synthesize cresFormData = mCresFormData;
@synthesize dataSource = mDataSource;
@synthesize delegate = mDelegate;
@synthesize currentPageIndex = mCurrentPageIndex;
@synthesize openForEditingSavedValue = mOpenForEditingSavedValue;
@synthesize shouldAutoValidate = mshouldAutoValidate;

- (void)awakeFromNib
{
    [super awakeFromNib];
    mOpenForEditingSavedValue = FALSE;
    mshouldAutoValidate = TRUE;
    if ([mDataSource respondsToSelector: @selector(formDataForCresFormView:)])
        self.cresFormData = [mDataSource formDataForCresFormView: self];
    
    [self initPageScroller];
    [self initPageSelector];
    [self setUpFormPages];
    [self activityIndicator];
}

- (id)initWithDataSource: (id<CresFormViewDataSource>)dataSource
             andDelegate: (id<CresFormViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        mOpenForEditingSavedValue = FALSE;
        mshouldAutoValidate = TRUE;
        [self setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        self.dataSource = dataSource;
        self.delegate = delegate;
        
        if ([mDataSource respondsToSelector: @selector(formDataForCresFormView:)])
            self.cresFormData = [mDataSource formDataForCresFormView: self];
        
        [self initPageScroller];
        [self initPageSelector];
        [self setUpFormPages];
        [self activityIndicator];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect lPageRect = self.bounds;
    lPageRect.size.height -= kNextSelectorHeight;
    mScrollView.frame = lPageRect;
    
    CGRect lNextBtnRect = self.bounds;
    lNextBtnRect.size.height = kNextSelectorHeight;
    lNextBtnRect.origin.y = CGRectGetHeight(self.bounds) - kNextSelectorHeight;
    mNextBtn.frame = lNextBtnRect;
    
    mActivityIndicator.frame = CGRectMake((lPageRect.size.width - CGRectGetWidth(mActivityIndicator.frame))/2, (lPageRect.size.height - CGRectGetHeight(mActivityIndicator.frame))/2 ,50,50);
    
    [self initPageSelector];
    [self setUpFormPages];
    [self refreshPageNavigators];
}

- (void)reloadFormView
{
    if ([mDataSource respondsToSelector: @selector(formDataForCresFormView:)])
        self.cresFormData = [mDataSource formDataForCresFormView: self];
    
    [self setUpFormPages];
}

- (void)reloadFormPageAtIndex: (NSInteger)pageIndex
{
    
}

- (void)initPageScroller
{
    mScrollView = [[UIScrollView alloc] init];
    mScrollView.frame = self.bounds;
    mScrollView.pagingEnabled = TRUE;
    mScrollView.backgroundColor = [UIColor clearColor];
    mScrollView.scrollEnabled = TRUE;
    mScrollView.delegate= self;
    [self addSubview: mScrollView];
}

- (void)initPageSelector
{
    UIView* lPageNavigatorBaseView = [self viewWithTag: 99];
    [lPageNavigatorBaseView removeFromSuperview];
    
    CGRect lPageNavigatorRect = self.bounds;
    lPageNavigatorRect.size.height = kNextSelectorHeight;
    lPageNavigatorRect.origin.y = CGRectGetHeight(self.bounds) - kNextSelectorHeight;
    
    lPageNavigatorBaseView = [[UIView alloc] initWithFrame: lPageNavigatorRect];
    lPageNavigatorBaseView.tag = 99;
    lPageNavigatorBaseView.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 0.2];
    [self addSubview: lPageNavigatorBaseView];
    
    lPageNavigatorRect.origin.y = 0.0f;
    mNextBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    mNextBtn.titleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:15];
    [mNextBtn addTarget: self action: @selector(goToNextPage:) forControlEvents: UIControlEventTouchUpInside];
    [lPageNavigatorBaseView addSubview: mNextBtn];
    mNextBtn.hidden = TRUE;
    mNextBtn.frame = lPageNavigatorRect;
    
    mPreviousBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    mPreviousBtn.titleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:15];
    [mPreviousBtn addTarget: self action: @selector(goToPreviousPage:) forControlEvents: UIControlEventTouchUpInside];
    [lPageNavigatorBaseView addSubview: mPreviousBtn];
    mPreviousBtn.hidden = TRUE;
    mPreviousBtn.frame = lPageNavigatorRect;
    
    if (mCresFormData.pageNavigator.navigationType == ECSPageNavigationDefault)
    {
        mNextBtn.hidden = FALSE;
        mPreviousBtn.hidden = TRUE;
        mNextBtn.frame = lPageNavigatorRect;
        [mNextBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [mNextBtn setBackgroundColor: [UIColor lightGrayColor]];
        [mNextBtn setTitle: @"Next" forState: UIControlStateNormal];
        [mNextBtn.titleLabel setFont: kFont(kHelveticaNeue, 20.0)];
    }
    else if (mCresFormData.pageNavigator.navigationType == ECSPageNavigationNextPrevious)
    {
        mNextBtn.hidden = FALSE;
        mPreviousBtn.hidden = FALSE;
        lPageNavigatorRect.origin.x += 10.0;
        lPageNavigatorRect.size.width = kNextSelectorHeight;
        mPreviousBtn.frame = lPageNavigatorRect;
        
        UIImage* lNextImage = [UIImage imageNamed: mCresFormData.pageNavigator.nextImageName];
        [mNextBtn setImage: lNextImage forState: UIControlStateNormal];
        
        
        lPageNavigatorRect.origin.x = CGRectGetMaxX(self.bounds) - (kNextSelectorHeight + 10.0);
        mNextBtn.frame = lPageNavigatorRect;
        
        UIImage* lPreviosImage = [UIImage imageNamed: mCresFormData.pageNavigator.previousImageName];
        [mPreviousBtn setImage: lPreviosImage forState: UIControlStateNormal];
    }
    else if(mCresFormData.pageNavigator.navigationType == ECSPageNavigationPaginationDotNumeric)
    {
        mPageControl = [[StyledPageControl alloc] initWithFrame: lPageNavigatorRect];
        mPageControl.pageControlStyle = PageControlStyleWithPageNumber;
        [mPageControl setNumberOfPages: mCresFormData.formPages.count];
        [lPageNavigatorBaseView addSubview: mPageControl];
    }
}

- (void)setCresFormData:(CresFormData *)cresFormData
{
    mCresFormData = cresFormData;
}

- (void)setUpFormPages
{
    if (!mCresFormData)
        return;
    
    [self unloadAllPages];
    
    ScrollType lScrollType = mCresFormData.pageScrollType;
    CGRect lPageRect = mScrollView.bounds;
    NSArray* lPages = [mCresFormData formPages];
    for (CresFormPageData* lFormPageData in lPages)
    {
        CresFormPageView* lPageView = [[CresFormPageView alloc] initWithFrame: lPageRect andFormPageData: lFormPageData andDelegate: self openForEditSavedValue: mOpenForEditingSavedValue];
        
        [mScrollView addSubview: lPageView];
        
        if (lScrollType == EScrollTypeHorizontal)
            lPageRect.origin.x += CGRectGetWidth(lPageRect);
        else
            lPageRect.origin.y += CGRectGetHeight(lPageRect);
    }
    
    CGSize lContentSize = CGSizeZero;
    if (lScrollType == EScrollTypeHorizontal)
        lContentSize.width = CGRectGetWidth(mScrollView.frame)*lPages.count;
    else
        lContentSize.height = CGRectGetHeight(mScrollView.frame)*lPages.count;
    
    mScrollView.contentSize = lContentSize;
    
    [self setOffsetToPageIndex: mCurrentPageIndex animated: FALSE];
    
//    if (mCresFormData.pageNavigator.navigationType == ECSPageNavigationDefault)
//    {
//        CresFormPageData* lPageData = [lPages objectAtIndex: mCurrentPageIndex];
//        [mNextBtn setTitle: lPageData.nextPageSelectorTitle forState: UIControlStateNormal];
//    }
}

- (void)unloadAllPages
{
    NSArray* lPageViews = [mScrollView subviews];
    for (id lPageView in lPageViews)
    {
        if ([lPageView isKindOfClass: [CresFormPageView class]])
        {
            CresFormPageView* lCresFormPageView = (CresFormPageView*)lPageView;
            [lCresFormPageView removeFromSuperview];
        }
    }
    
    mScrollView.contentSize = CGSizeZero;
}

- (void)setOffsetToPageIndex: (NSUInteger)pageIndex animated: (bool)animated
{
    ScrollType lScrollType = mCresFormData.pageScrollType;
    CGPoint lContentOffset = mScrollView.contentOffset;
    if (lScrollType == EScrollTypeHorizontal)
        lContentOffset.x = pageIndex*CGRectGetWidth(mScrollView.bounds);
    else
        lContentOffset.y = pageIndex*CGRectGetHeight(mScrollView.bounds);
    
    [mScrollView setContentOffset: lContentOffset animated: animated];
    
}

- (CresFormFieldData*)fieldHasServiceChallengeOnPage: (NSInteger)pageIndex
{
    CresFormFieldData* lRetFieldData = nil;
    
    NSArray* lFormPages = mCresFormData.formPages;
    if (pageIndex >= lFormPages.count)
        return lRetFieldData;
    
    CresFormPageData* lFormPage = [lFormPages objectAtIndex: pageIndex];
    NSArray* lFields = [lFormPage fields];
    
    for (CresFormFieldData* lFieldData in lFields)
    {
        NSArray* lConditions = lFieldData.conditions;
        if (lRetFieldData) break;
        for (Condition* lCondition in lConditions)
        {
            if ([lCondition.conditionType isEqualToString: @"SERVICE"])
            {
                lRetFieldData = lFieldData;
                break;
            }
        }
    }
    
    return lRetFieldData;
}

- (CresFormFieldData*)fieldHasServiceChallengeOnCurrentPage
{
    return [self fieldHasServiceChallengeOnPage: self.currentPageIndex];
}

- (NSString*)passwordOnCurrentPage
{
    NSString* lPasswordVal = @"";
    NSArray* lFormPages = mCresFormData.formPages;
    NSInteger lPageIdex = self.currentPageIndex;
    
    if (lPageIdex >= lFormPages.count)
        return lPasswordVal;
    
    CresFormPageData* lFormPage = [lFormPages objectAtIndex: lPageIdex];
    NSArray* lFields = [lFormPage fields];
    
    for (CresFormFieldData* lFieldData in lFields)
    {
        if ([lFieldData.formKey isEqualToString: @"Password"])
        {
            lPasswordVal = lFieldData.fieldValue;
            break;
        }
    }
    
    return lPasswordVal;
}

- (void)jumpToPage: (NSUInteger)toPageIndex
          fromPage: (NSUInteger)fromPageIndex
{
    if(toPageIndex == NSUIntegerMax || toPageIndex >= mCresFormData.formPages.count)
    {
        if ([mDelegate respondsToSelector:
             @selector(cresFormView:toMoveOnPage:findChallange:completionHandler:)])
        {
            [mDelegate cresFormView: self toMoveOnPage: toPageIndex findChallange: EPageNotAvailable completionHandler: nil];
        }
        
        return;
    }
    
    if ([mDelegate respondsToSelector:
         @selector(cresFormView:willMoveToPageIndex:fromPageIndex:)])
    {
        [mDelegate cresFormView: self
            willMoveToPageIndex: toPageIndex
                  fromPageIndex: fromPageIndex];
    }
    
    [self setOffsetToPageIndex: toPageIndex animated: TRUE];
    mCurrentPageIndex = toPageIndex;
    
    if ([mDelegate respondsToSelector:
         @selector(cresFormView:didMoveToPageIndex:fromPageIndex:)])
    {
        [mDelegate cresFormView: self
             didMoveToPageIndex: toPageIndex
                  fromPageIndex: fromPageIndex];
    }
}

- (void)refreshPageNavigators
{
    [mPageControl setCurrentPage: mCurrentPageIndex];
    if (mCresFormData.pageNavigator.navigationType != ECSPageNavigationNextPrevious)
    {
        return;
    }
    if (mCurrentPageIndex == 0)
    {
        mPreviousBtn.hidden = TRUE;
    }
    else if(mCurrentPageIndex >= mCresFormData.formPages.count - 1)
    {
        mNextBtn.hidden = TRUE;
    }
    else
    {
        mNextBtn.hidden = FALSE;
        mPreviousBtn.hidden = FALSE;
    }
}

- (BOOL)canMoveToNextPage
{
    BOOL lRetVal = TRUE;
    NSArray* lPageViews = [mScrollView subviews];
    for (UIView* lView in lPageViews)
    {
        if ([lView isKindOfClass: [CresFormPageView class]])
        {
            CresFormPageView* lPageView = (CresFormPageView*)lView;
            if (lPageView.pageData.pageIndex == mCurrentPageIndex)
            {
                if (![lPageView areAllFieldsMeetsConditions])
                {
                    lRetVal = FALSE;
                    break;
                }
            }
        }
    }
    return lRetVal;
}

#pragma mark-
#pragma mark- ButtonActions
#pragma mark-

- (void)forceMoveToNextPage
{
    NSInteger lPageIndex = mCurrentPageIndex;
    lPageIndex += 1;
    
    [self jumpToPage: lPageIndex fromPage: mCurrentPageIndex];
    [self refreshPageNavigators];
//    if (mCresFormData.pageNavigator.navigationType == ECSPageNavigationDefault)
//    {
//        CresFormPageData* lPageData = [mCresFormData.formPages objectAtIndex: mCurrentPageIndex];
//        [mNextBtn setTitle: lPageData.nextPageSelectorTitle forState: UIControlStateNormal];
//    }
}

- (void)goToNextPage: (id)sender
{
    NSInteger lPageIndex = mCurrentPageIndex;
    lPageIndex += 1;
    
    if (mshouldAutoValidate && ![self canMoveToNextPage])
        return;
    
    [mDelegate cresFormView: self
         canMoveToPageIndex: lPageIndex
          completionHandler: ^(BOOL canMove)
     {
         if (canMove)
         {
             [self jumpToPage: lPageIndex fromPage: mCurrentPageIndex];
             [self refreshPageNavigators];
             
//             if (mCresFormData.pageNavigator.navigationType == ECSPageNavigationDefault)
//             {
//                 CresFormPageData* lPageData = [mCresFormData.formPages objectAtIndex: mCurrentPageIndex];
//                 [mNextBtn setTitle: lPageData.nextPageSelectorTitle forState: UIControlStateNormal];
//             }
         }
     }];
}

- (void)goToPreviousPage: (id)sender
{
    NSInteger lPageIndex = mCurrentPageIndex;
    lPageIndex -= 1;
    
    if (mshouldAutoValidate && ![self canMoveToNextPage])
    return;
    
    [mDelegate cresFormView: self
         canMoveToPageIndex: lPageIndex
          completionHandler: ^(BOOL canMove)
     {
         if (canMove)
         {
             [self jumpToPage: lPageIndex fromPage: mCurrentPageIndex];
             [self refreshPageNavigators];
             
             //             if (mCresFormData.pageNavigator.navigationType == ECSPageNavigationDefault)
             //             {
             //                 CresFormPageData* lPageData = [mCresFormData.formPages objectAtIndex: mCurrentPageIndex];
             //                 [mNextBtn setTitle: lPageData.nextPageSelectorTitle forState: UIControlStateNormal];
             //             }
         }
     }];
}

#pragma mark-
#pragma mark- UIScrollViewDelegate
#pragma mark-

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    mCurrentPageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self refreshPageNavigators];
}

#pragma mark-
#pragma mark- CresFormPageViewDelegate
#pragma mark-

- (void)socialLoginCompletedWithData: (CSSocialLoginUser*)userData onCresFormPageView: (CresFormPageView*)formPageView WithError:(NSError *)error
{
    if ([mDelegate respondsToSelector: @selector(submitFormWithChallange:)])
    {
        [mDelegate submitFormWithChallange: userData];
    }
}

- (NSArray*)socialSignupOptionsForFormPage: (CresFormPageView*)cresFormPageView
{
    if ([mDelegate respondsToSelector: @selector(socialSignupOptionsForForm:)])
    {
        return [mDelegate socialSignupOptionsForForm: self];
    }
    
    return nil;
}

- (void)showBannerForPage:(CresFormPageView *)cresFormPageView
          withErrorMesage:(NSString *)msg
            withImageName:(NSString *)imageName
{
    if ([mDelegate respondsToSelector: @selector( showBannerForForm:withErrorMesage:withImageName:)])
    {
        [mDelegate showBannerForForm: self withErrorMesage: msg withImageName: imageName];
    }
}

-(void)activityIndicator
{
    mActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    mActivityIndicator.hidesWhenStopped = TRUE;
    [self addSubview: mActivityIndicator];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
