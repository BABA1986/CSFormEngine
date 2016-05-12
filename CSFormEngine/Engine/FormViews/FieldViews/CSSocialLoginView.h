//
//  CSSocialLoginView.h
//  Edumation
//
//  Created by Ankit Gupta on 10/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <linkedin-sdk/LISDK.h>
#import <TwitterKit/TwitterKit.h>
#import <TwitterKit/TWTRAPIClient.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "CSSocialLoginCell.h"
#import "CSSocialLoginUser.h"
#import "LoginManager.h"



@class GIDSignInButton;
@class CSSocialLoginView;


@protocol CSSocialLoginDelegate <NSObject>


- (void) socialLogin:(CSSocialLoginView *)loginView
   didSignInWithType:(NSString *) type
        WithResponse:(CSSocialLoginUser*)response
           withError:(NSError *)error;

@optional

-(BOOL)willStartSigning:(CSSocialLoginView *)loginView
          withLoginType:(NSInteger ) type;


@end

@interface CSSocialLoginView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FBSDKLoginButtonDelegate,GIDSignInDelegate, GIDSignInUIDelegate>
{
    UICollectionView *mcollectionView;
    NSArray *mOptions;
    UIWindow*               mWindow;
    FBSDKLoginManager *mFBManager;
    UIViewController* mCtr;

}


@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)UICollectionViewFlowLayout *collectionViewLayout;
@property(nonatomic, weak)id<CSSocialLoginDelegate>     delegate;


- (instancetype)initWithFrame: (CGRect)frame
     withSocialNetworkOptions: (NSArray*)list;

- (void)setOptions: (NSArray*)list;


@end
