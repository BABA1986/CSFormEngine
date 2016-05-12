//
//  NavigationView.h
//  Edumation
//
//  Created by Deepak Kumar on 10/12/15.
//  Copyright © 2015 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CresNavigationViewItem : UIButton
@property(nonatomic, assign)NSInteger           index;
@end


@interface CresNavigationView : UIView
{
    UILabel*                mTitleLbl;
    
    UIView*                 mLeftItemsBaseView;
    UIView*                 mRightItemsBaseView;
    BOOL                    mWithStatusBar;
}

@property(nonatomic, readwrite)BOOL                 withStatusBar;

//Refresh Navigation bar decoration. Provided by the server template Data
- (void)refreshCresNavigationBar;
- (void)setTitle: (NSString*)titleString;

/*Left most item is at o index. Only two left items are supported in this method.*/
- (void)addLeftItemAtIndex: (NSInteger)index
                 withImage: (UIImage*)image
                    target: (id)target
               andSelector: (SEL)selector;

/*Left most item is at o index. Only two left items are supported in this method.*/
- (void)addLeftItem: (CresNavigationViewItem*)item
             target: (id)target
        andSelector: (SEL)selector;

/*To add text and image both at right index.*/
- (void)addRightItemAtIndex: (NSInteger)index
                  withImage: (UIImage*)image
                   withText: (NSString*)text
                     target: (id)target
                andSelector: (SEL)selector;

/*Right most item is at o index. Only Three right items are supported in this method.*/
- (void)addRightItemAtIndex: (NSInteger)index
                  withImage: (UIImage*)image
                     target: (id)target
                andSelector: (SEL)selector;

/*Right most item is at o index. Only Three right items are supported in this method.*/
- (void)addRightItem: (CresNavigationViewItem*)item
              target: (id)target
         andSelector: (SEL)selector;

/*To add image and text both at left index.*/
- (void)addLeftItemAtIndex: (NSInteger)index
                 withImage: (UIImage*)image
                  withText: (NSString*)text
                    target: (id)target
               andSelector: (SEL)selector;

@end
