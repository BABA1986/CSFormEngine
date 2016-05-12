//
//  CresFormPageView.h
//  Edumation
//
//  Created by Deepak on 02/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CresFormData.h"
#import "CresFieldBaseView.h"

@class CresFormPageView;
@protocol CresFormPageViewDelegate <NSObject>

- (void)showBannerForPage:(CresFormPageView *)cresFormPageView
          withErrorMesage:(NSString *)msg
            withImageName:(NSString *)imageName;

- (void)socialLoginCompletedWithData: (CSSocialLoginUser*)userData onCresFormPageView: (CresFormPageView*)formPageView WithError:(NSError *)error;

- (NSArray*)socialSignupOptionsForFormPage: (CresFormPageView*)cresFormPageView;

@end

@interface CresFormPageView : UIView <CresFieldBaseViewDelegate>
{
    UIScrollView*                               mScrollView;
    __strong CresFormPageData*                  mPageData;
    __weak id<CresFormPageViewDelegate>         mDelegate;
    
     //Default Is false
    BOOL                                        mIsOpenForEditExistingValue;
}

@property(nonatomic, readonly)CresFormPageData*                                 pageData;
@property(nonatomic, weak, readonly)__weak id<CresFormPageViewDelegate>         delegate;
@property(nonatomic, assign)BOOL                                                isOpenForEditExistingValue;

- (instancetype)initWithFrame: (CGRect)frame
              andFormPageData: (CresFormPageData*)pageData
                  andDelegate: (id<CresFormPageViewDelegate>)delegate
        openForEditSavedValue: (BOOL)editSavedValue;

- (void)reloadPage;
- (BOOL)areAllFieldsMeetsConditions;

@end
