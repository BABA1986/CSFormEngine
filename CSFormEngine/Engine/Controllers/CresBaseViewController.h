//
//  CresBaseViewController.h
//  Edumation
//
//  Created by Deepak Kumar on 10/12/15.
//  Copyright © 2015 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CresNavigationView.h"

@interface CresBaseViewController : UIViewController
{
     CresNavigationView*            mNavigationView;
}

- (void)initialiseNavBar;
- (void)setCresNavViewHidden: (BOOL)shouldHidden;

@end
