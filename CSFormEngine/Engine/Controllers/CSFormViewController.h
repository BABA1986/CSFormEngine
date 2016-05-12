//
//  CSFormViewController.h
//  CSFormEngine
//
//  Created by Deepak on 25/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CresFormView.h"

@interface CSFormViewController : UIViewController<CresFormViewDataSource, CresFormViewDelegate>
{
    IBOutlet CresFormView*           mCresFormView;
    CresFormData*                    mFormData;
}

@property(nonatomic, strong)CresFormData*   formData;

@end
