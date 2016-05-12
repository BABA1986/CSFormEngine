//
//  FormWebViewCtr.h
//  Edumation
//
//  Created by Ankit Gupta on 03/03/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CresNavigationView.h"
#import "CresBaseViewController.h"

@class FormWebViewCtr;
@protocol FormWebViewCtrDelegate <NSObject>

- (void)willDissmissFormWebview: (FormWebViewCtr*)searchPicker;

@optional

@end

@interface FormWebViewCtr : CresBaseViewController<UIWebViewDelegate>
{
    

}
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property(strong,nonatomic) NSString *urlString;
@property (strong,nonatomic) NSString *titleString;
@property(weak,nonatomic)id<FormWebViewCtrDelegate> delegate;


@end
