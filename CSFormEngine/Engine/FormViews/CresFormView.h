//
//  CresFormView.h
//  Edumation
//
//  Created by Deepak on 02/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CresFormData.h"
#import "CSSocialLoginUser.h"
#import "CresFormPageView.h"
#import "StyledPageControl.h"

@class CresFormView;
@protocol CresFormViewDataSource <NSObject>

- (CresFormData*)formDataForCresFormView: (CresFormView*)cresFormView;

@end

@protocol CresFormViewDelegate <NSObject>

- (BOOL)cresFormView: (CresFormView*)cresFormView
  canMoveToPageIndex: (NSUInteger)pageIndex;

- (void)cresFormView: (CresFormView*)cresFormView
  canMoveToPageIndex: (NSUInteger)pageIndex
   completionHandler:(void (^)(BOOL canMove))completionHandler;

- (void)cresFormView: (CresFormView*)cresFormView
 willMoveToPageIndex: (NSInteger)toPageIndex
       fromPageIndex: (NSUInteger)fromPageIndex;

- (void)cresFormView: (CresFormView*)cresFormView
  didMoveToPageIndex: (NSInteger)toPageIndex
       fromPageIndex: (NSUInteger)fromPageIndex;

- (void)cresFormView: (CresFormView*)cresFormView
        toMoveOnPage: (NSUInteger)pageIndex
       findChallange: (CresNextPageMoveChallenge)challengeReason
   completionHandler:(void (^)())completionHandler;

- (void)showBannerForForm:(CresFormView *)cresFormView
          withErrorMesage:(NSString *)msg
            withImageName:(NSString *)imageName;

@optional
//socialLoginUser Will be nil in case of crescerance login
- (void)submitFormWithChallange: (CSSocialLoginUser*)socialLoginUser;
- (NSArray*)socialSignupOptionsForForm: (CresFormView*)cresFormView;

@end

@interface CresFormView : UIView<UIScrollViewDelegate, CresFormPageViewDelegate, UIScrollViewDelegate>
{
    CresFormData*                           mCresFormData;
    UIScrollView*                           mScrollView;
    UIButton*                               mNextBtn;
    UIButton*                               mPreviousBtn;
    StyledPageControl*                      mPageControl;
    UIActivityIndicatorView*                mActivityIndicator;
    UIView *                                mValidationBanner;

    __weak IBOutlet id<CresFormViewDataSource>       mDataSource;
    __weak IBOutlet id<CresFormViewDelegate>         mDelegate;
    
    NSUInteger                                       mCurrentPageIndex;
    
    //Default Is false
    BOOL                                             mOpenForEditingSavedValue;
    BOOL                                             mshouldAutoValidate;
}

@property(nonatomic, strong)CresFormData*                   cresFormData;
@property(nonatomic, weak)id<CresFormViewDataSource>        dataSource;
@property(nonatomic, weak)id<CresFormViewDelegate>          delegate;
@property(nonatomic, assign)NSUInteger                      currentPageIndex;
@property(nonatomic, assign)BOOL                            openForEditingSavedValue;
@property(nonatomic, assign)BOOL                            shouldAutoValidate;

- (id)initWithDataSource: (id<CresFormViewDataSource>)dataSource
             andDelegate: (id<CresFormViewDelegate>)delegate;

- (void)reloadFormView;
- (void)reloadFormPageAtIndex: (NSInteger)pageIndex;
- (void)jumpToPage: (NSUInteger)toPageIndex
          fromPage: (NSUInteger)fromPageIndex;

//Avoid below methods, need to implement due to Bad services.
- (CresFormFieldData*)fieldHasServiceChallengeOnPage: (NSInteger)pageIndex;
- (CresFormFieldData*)fieldHasServiceChallengeOnCurrentPage;
- (NSString*)passwordOnCurrentPage;
//Avoid this method to use.
- (void)forceMoveToNextPage;
- (void)refreshPageNavigators;

@end
