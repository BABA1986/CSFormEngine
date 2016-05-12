//
//  FormWebViewCtr.m
//  Edumation
//
//  Created by Ankit Gupta on 03/03/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "FormWebViewCtr.h"

@interface FormWebViewCtr ()

@end

@implementation FormWebViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [mNavigationView setTitle: self.titleString];
    [mNavigationView addRightItemAtIndex:0 withImage: nil target:self andSelector:@selector(actionOnCloseButton)];

    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webview loadRequest:urlRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)actionOnCloseButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate willDissmissFormWebview:self];
    }];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return TRUE;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
}


@end
