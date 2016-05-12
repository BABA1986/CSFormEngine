//
//  LoginManager.h
//  Edumation
//
//  Created by Ankit Gupta on 08/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <linkedin-sdk/LISDK.h>
#import <TwitterKit/TwitterKit.h>
#import "CSSocialLoginUser.h"


@interface LoginManager : NSObject

@property(nonatomic, strong) CSSocialLoginUser *socialLoginUser;


+(LoginManager*)SharedInstance;


- (void)signOut;

- (void)disconnect;


- (void)applicationBecomeActiveFromSocialLogin:(UIApplication *)application;
- (CSSocialLoginUser *)userInfoWithRespose: (id)response
                                ofType: (NSInteger)loginType withToken:(NSString *)token;


- (BOOL)application:(UIApplication *)application
            openURLInSocialLogin:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
            options:(NSDictionary *)options
         annotation:(id)annotation;
-(void)saveResponseInCaching:(NSDictionary *)response;
-(void)clearUserInfo;
-(CSSocialLoginUser *)getLoginInfo;
-(NSDictionary *)getLoginInfoDict;

@end
