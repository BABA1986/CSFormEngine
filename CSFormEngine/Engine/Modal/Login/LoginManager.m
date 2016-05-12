//
//  LoginManager.m
//  Edumation
//
//  Created by Ankit Gupta on 08/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager
static LoginManager *sharedInstance;
static NSString * const kClientID =
@"689563118190-m2ohe529rmutga9bos9ul7d1sknhs6q0.apps.googleusercontent.com";



#pragma mark - Shared Instance

+(LoginManager*)SharedInstance
{
    @synchronized(self)
    {
        if(!sharedInstance)
            sharedInstance = [[LoginManager alloc] init];
    }
    
    return sharedInstance;
}

+(id)alloc
{
    @synchronized(self)
    {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton ContentManager class.");
        sharedInstance = [super alloc];
    }
    
    return sharedInstance;
}

-(id)init
{
    if ( self = [super init])
    {
        [[Twitter sharedInstance] startWithConsumerKey:@"o5DWxSy8Vn0kGYOkArljhQIJC" consumerSecret:@"BPGnpl8HBq5Rws9YjIqewyxttpzaoTsVeL4DgHqMrH18lE4wwI"];
        [GIDSignIn sharedInstance].clientID = kClientID;
        self.socialLoginUser=[self getLoginInfo];
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application
openURLInSocialLogin:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
            options:(NSDictionary *)options
         annotation:(id)annotation
{

    NSString *lPlistSchemes=[self getIdentifierFromUrl:url.scheme];
    
    if ([lPlistSchemes isEqualToString:@"google"])
    {
        return [self application:application
            processOpenURLAction:url
               sourceApplication:sourceApplication
                      annotation:annotation
                      iosVersion:8];

    }
    else if ([lPlistSchemes isEqualToString:@"linkedIn"])
    {
        if ([LISDKCallbackHandler shouldHandleUrl:url]) {
            return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        }
        

    }
    else if ([lPlistSchemes isEqualToString:@"facebook"])
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];

    }

    return YES;

}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options NS_AVAILABLE_IOS(9_0)
{
    return [self application:app
        processOpenURLAction:url
           sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                  iosVersion:9];
}

-(BOOL)application:(UIApplication *)application processOpenURLAction:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation iosVersion:(int)version
{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (void)applicationBecomeActiveFromSocialLogin:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

-(NSString *)getIdentifierFromUrl:(NSString *)urlScheme
{
    NSString *CFBundleURLIdentifier=nil;
    NSArray *lPlistUrlTypes = (NSArray*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    for (int i=0; i<lPlistUrlTypes.count; i++) {
        NSArray *lScheme=[[lPlistUrlTypes objectAtIndex:i]objectForKey:@"CFBundleURLSchemes"];
        if ([lScheme containsObject:urlScheme]) {
            CFBundleURLIdentifier= [[lPlistUrlTypes objectAtIndex:i]objectForKey:@"CFBundleURLName"];
        }
    }
    return CFBundleURLIdentifier;
}


-(void)signOut
{
    [self removeProfileImageFromDocumentDirectory];
    GIDGoogleUser *googleUser = [[GIDSignIn sharedInstance] currentUser];
    if (googleUser.authentication)
        [[GIDSignIn sharedInstance]signOut];

    switch (self.socialLoginUser.loginType) {
            
        case 2:
        {
            GIDGoogleUser *googleUser = [[GIDSignIn sharedInstance] currentUser];
            if (googleUser.authentication)
                [[GIDSignIn sharedInstance]signOut];
            break;
        }
        case 5:
        {
            FBSDKLoginManager *lFBManager = [[FBSDKLoginManager alloc] init];
            [lFBManager logOut];
            break;
        }
        case 3:
        {
//            [[Twitter sharedInstance]logOut];
            break;
        }
        case 4:
        {
            [LISDKSessionManager clearSession];
            break;
        }

        default:
            break;
    }
    self.socialLoginUser=nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"CSSocialLoginUserInfo"];
}

-(void)disconnect
{
    
}

-(CSSocialLoginUser *)getLoginInfo
{
    self.socialLoginUser=[[CSSocialLoginUser alloc]init];
    id userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"CSSocialLoginUserInfo"];
    if ([userData isKindOfClass:[NSData class]]||userData)
    {
        
        id userDict=[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        NSDictionary *lResponse = (NSDictionary *)userDict;
        for (NSString *fieldName in lResponse) {
            [self.socialLoginUser setValue:[lResponse objectForKey:fieldName] forKey:fieldName];
        }
        return self.socialLoginUser;
    }
    
    return nil;
}

-(NSDictionary *)getLoginInfoDict
{
    id userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"CSSocialLoginUserInfo"];
    if ([userData isKindOfClass:[NSData class]]||userData)
    {
        id userDict=[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        NSDictionary *lResponse = (NSDictionary *)userDict;
        return lResponse;
    }
    
    return nil;
}

- (void) setObject:(id) object ValuesFromDictionary:(NSDictionary *) dictionary
{
    for (NSString *fieldName in dictionary) {
        [object setValue:[dictionary objectForKey:fieldName] forKey:fieldName];
    }
}

- (CSSocialLoginUser *)userInfoWithRespose: (id)response
                                    ofType: (NSInteger)loginType withToken:(NSString *)token
{
    self.socialLoginUser = [[CSSocialLoginUser alloc]initWithSocialResponse:response ofType:loginType withToken:token];
    return self.socialLoginUser;
}

-(void)saveResponseInCaching:(NSDictionary *)response
{
    self.socialLoginUser=nil;
    self.socialLoginUser = [[CSSocialLoginUser alloc]initWithSocialResponse:response ofType:0 withToken:nil];
    [self.socialLoginUser saveResponseInUserDefaults];
}

-(void)clearUserInfo
{
    self.socialLoginUser=nil;
    self.socialLoginUser = [[CSSocialLoginUser alloc] init];
    [self signOut];
}
-(void)removeProfileImageFromDocumentDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"loginProfileImage.png"];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:imagePath error:&error];
    if (!success) {
        NSLog(@"Could not delete Image -:%@ ",[error localizedDescription]);
    }
}

@end
