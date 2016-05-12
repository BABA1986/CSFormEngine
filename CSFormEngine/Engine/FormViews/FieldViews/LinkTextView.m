//
//  LinkTextView.m
//  Edumation
//
//  Created by Deepak on 29/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "LinkTextView.h"

@implementation LinkTextView

- (instancetype)initWithHtmlText: (NSString*)htmlText
                        andFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        CGRect lRect = CGRectInset(self.bounds, 2.0, 2.0);
        NSString* lHtmlText = [NSString stringWithFormat: @"<html><body style=' background-color: #fcfcfc;'>%@</body></html>", htmlText];
        mWebView = [[UIWebView alloc] initWithFrame: lRect];
        mWebView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [mWebView loadHTMLString: lHtmlText baseURL: nil];
        mWebView.delegate = self;
        
        mWebView.scrollView.scrollEnabled = NO;
        mWebView.scrollView.bounces = NO;
        [self addSubview: mWebView];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType==UIWebViewNavigationTypeLinkClicked)
    {
        NSString* lRequestUrlStr = [request.URL absoluteString];
        NSString *lJS = [NSString stringWithFormat:@"(function(requestUrl){var lInnerHTMLText = ''; var lAnchorTags = document.getElementsByTagName('a'); for (var i = lAnchorTags.length >>> 0; i--;){lInnerHTMLText = lAnchorTags[i].innerHTML; var lHref = lAnchorTags[i].href; if(lHref == requestUrl){break;}} return lInnerHTMLText;})('%@');", lRequestUrlStr];
        
        NSString *lLinkText = [webView stringByEvaluatingJavaScriptFromString: lJS];
        [self.delegate ClickOnLink:self WithUrlString:lRequestUrlStr andTitleStr:lLinkText];
        return false;
    }
    return true;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
 
}
@end
