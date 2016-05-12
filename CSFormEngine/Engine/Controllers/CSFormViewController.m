//
//  CSFormViewController.m
//  CSFormEngine
//
//  Created by Deepak on 25/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "CSFormViewController.h"
#import "FormDataManager.h"

@interface CSFormViewController (Private)
@end

@implementation CSFormViewController

@synthesize formData = mFormData;

- (instancetype)initWithFormData: (CresFormData*)formData
{
    self = [super init];
    if (self)
    {
        self.formData = formData;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mCresFormView.dataSource = self;
    mCresFormView.delegate = self;
    self.title = self.formData.formName;
    
    UIBarButtonItem* lBackButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"navBack.png"] style: UIBarButtonItemStylePlain target: self action: @selector(backButtonClicked:)];
    self.navigationItem.leftBarButtonItem = lBackButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [mCresFormView reloadFormView];
    mCresFormView.shouldAutoValidate = FALSE;
}

- (void)backButtonClicked: (id)sender
{
    NSUInteger lPageIndex = mCresFormView.currentPageIndex;
    if (lPageIndex == 0
        || mFormData.pageNavigator.navigationType == ECSPageNavigationNextPrevious)
    {
        [self.navigationController popViewControllerAnimated: TRUE];
        return;
    }
    
    lPageIndex -= 1;
    [self.view endEditing:TRUE];
    [mCresFormView jumpToPage: lPageIndex fromPage: mCresFormView.currentPageIndex];
    [mCresFormView refreshPageNavigators];
}

#pragma mark-
#pragma mark- CresFormViewDataSource & CresFormViewDelegate
#pragma mark-

- (BOOL)cresFormView: (CresFormView*)cresFormView
  canMoveToPageIndex: (NSUInteger)pageIndex
{
    return TRUE;
}

- (void)cresFormView: (CresFormView*)cresFormView
  canMoveToPageIndex: (NSUInteger)pageIndex
   completionHandler:(void (^)(BOOL canMove))completionHandler
{
    completionHandler(TRUE);
    return;
}

- (CresFormData*)formDataForCresFormView: (CresFormView*)cresFormView
{
    return self.formData;
}

- (void)cresFormView: (CresFormView*)cresFormView
 willMoveToPageIndex: (NSInteger)toPageIndex
       fromPageIndex: (NSUInteger)fromPageIndex
{
    
}

- (void)cresFormView: (CresFormView*)cresFormView
  didMoveToPageIndex: (NSInteger)toPageIndex
       fromPageIndex: (NSUInteger)fromPageIndex
{
    
}

- (void)showBannerForForm:(CresFormView *)cresFormView
          withErrorMesage:(NSString *)msg
            withImageName:(NSString *)imageName
{

}

- (void)cresFormView: (CresFormView*)cresFormView
        toMoveOnPage: (NSUInteger)pageIndex
       findChallange: (CresNextPageMoveChallenge)challengeReason
   completionHandler:(void (^)())completionHandler
{
    if (challengeReason == EPageNotAvailable)
    {
        NSUInteger lPageIndex = mCresFormView.currentPageIndex;
        if (lPageIndex == NSUIntegerMax)
        {
            [self.navigationController popViewControllerAnimated: TRUE];
        }
    }
}

- (void)submitFormWithChallange:(CSSocialLoginUser *)socialLoginUser
{
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
