//
//  LinkTextView.h
//  Edumation
//
//  Created by Deepak on 29/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormWebViewCtr.h"
@class LinkTextView;
@protocol LinkTextViewDelegate <NSObject>
- (void)ClickOnLink: (LinkTextView*)LinkTextView
      WithUrlString: (NSString *)urlString andTitleStr: (NSString*)titleStr;
@end
@interface LinkTextView : UIView <UIWebViewDelegate,FormWebViewCtrDelegate>
{
    UIWebView*          mWebView;
    UIWindow*           mWindow;

}
@property(nonatomic, weak)id<LinkTextViewDelegate>         delegate;
- (instancetype)initWithHtmlText: (NSString*)htmlText
                        andFrame: (CGRect)frame;

@end
