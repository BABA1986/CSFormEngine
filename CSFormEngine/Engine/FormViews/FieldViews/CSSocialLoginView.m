//
//  CSSocialLoginView.m
//  Edumation
//
//  Created by Ankit Gupta on 10/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CSSocialLoginView.h"
#import "CresFormData.h"

#define kCellMargin         18
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IMAGE3X ([[UIScreen mainScreen] scale] >= 3.0)

@implementation CSSocialLoginView
@synthesize collectionView=mcollectionView;
@synthesize delegate = mDelegate;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setCollectionView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage * lImg = [UIImage imageNamed: @"facebook.png"];
    CGSize lImgSize=lImg.size;
    if (IS_RETINA)
    {
        lImgSize.width=lImgSize.width/2;
        lImgSize.height=lImgSize.height/2;
    }
    else if (IS_IMAGE3X)
    {
        lImgSize.width=lImgSize.width/3;
        lImgSize.height=lImgSize.height/3;
    }
    
    CGRect lRect = self.bounds;
    mcollectionView.frame = lRect;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)mcollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width/2 - 2*kCellMargin, lImgSize.height);
    flowLayout.sectionInset = UIEdgeInsetsMake(20, kCellMargin, 0, kCellMargin);
//    flowLayout.minimumInteritemSpacing = kCellMargin;
//    flowLayout.minimumLineSpacing = kCellMargin;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    UIImage * lImg = [UIImage imageNamed: @"facebook.png"];
    CGSize lImgSize=lImg.size;
    if (IS_RETINA)
    {
        lImgSize.width=lImgSize.width/2;
        lImgSize.height=lImgSize.height/2;
    }
    else if (IS_IMAGE3X)
    {
        lImgSize.width=lImgSize.width/3;
        lImgSize.height=lImgSize.height/3;
        
    }

    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width/2 - 2*kCellMargin, lImgSize.height);
    flowLayout.sectionInset = UIEdgeInsetsMake(20, kCellMargin, 0, kCellMargin);
//    flowLayout.minimumInteritemSpacing = kCellMargin;
//    flowLayout.minimumLineSpacing = kCellMargin;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return flowLayout;
}

- (instancetype)initWithFrame: (CGRect)frame
     withSocialNetworkOptions: (NSArray*)list
{
    self = [super initWithFrame:frame];
    if (self) {
        if (list.count>0)
            mOptions = [[NSArray alloc]initWithArray:list];
        [self setCollectionView];
       // [self setUpGoogleDelegate];
    }
    return self;
}

- (void)setOptions: (NSArray*)list
{
    mOptions = [[NSArray alloc]initWithArray:list];
    [mcollectionView reloadData];
}

-(void)setUpGoogleDelegate
{
    [GIDSignInButton class];
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
}

-(void)setCollectionView
{
    CGRect rect = self.bounds;
        
    mcollectionView=[[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[self collectionViewFlowLayout]];
    [mcollectionView setDelegate:self];
    [mcollectionView setDataSource:self];
    [mcollectionView setBackgroundColor:[UIColor clearColor]];
    [mcollectionView registerNib:[UINib nibWithNibName:@"CSSocialLoginCell" bundle:nil]
      forCellWithReuseIdentifier:@"SocialBtnCell"];
    [self addSubview:mcollectionView];
}



- (UIViewController*)rootController
{
    if (mWindow)
    {
        return mWindow.rootViewController;
    }
    mWindow =[UIWindow new];
    mWindow.frame = [[UIScreen mainScreen] bounds];
    mWindow.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];

    mWindow.windowLevel = UIWindowLevelNormal;
    
    mCtr = [[UIViewController alloc] init];
    mCtr.view.frame = [[UIScreen mainScreen] bounds];
    [mWindow setRootViewController: mCtr];
    
    [mWindow makeKeyAndVisible];
    
    return mCtr;
}



#pragma mark -
#pragma mark - Collection View Delegates & DataSource
#pragma mark -


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mOptions.count;

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSSocialLoginCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SocialBtnCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    cell.layer.cornerRadius=5;
    cell.userInteractionEnabled=YES;
    CSSubItem* lCSSubItem = [mOptions objectAtIndex: indexPath.row];
    cell.imgView.image = [UIImage imageNamed: lCSSubItem.itemIconSrc];
    cell.imgView.backgroundColor = [UIColor clearColor];
    if ([LoginManager SharedInstance].socialLoginUser)
    {
//        cell.userInteractionEnabled=NO;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSSocialLoginCell *cell = (CSSocialLoginCell*)[collectionView cellForItemAtIndexPath:indexPath];
 
    BOOL isLogin=false;
    if ([mDelegate respondsToSelector: @selector(willStartSigning:withLoginType:)])
    {
        isLogin  = [mDelegate willStartSigning:self withLoginType:cell.cellLoginType];
    }
    
    if (isLogin)
    {
        GIDGoogleUser *googleUser = [[GIDSignIn sharedInstance] currentUser];
        if (googleUser.authentication)
        [[GIDSignIn sharedInstance]signOut];

        CSSubItem* lCSSubItem = [mOptions objectAtIndex: indexPath.row];
        if ([lCSSubItem.subItemTitle isEqualToString: @"facebook"])
        {
            [self facebookLoginButtonClicked];
        }
        else if ([lCSSubItem.subItemTitle isEqualToString: @"linkedin"])
        {
            [self linkedInButtonPressed];
        }
        else if ([lCSSubItem.subItemTitle isEqualToString: @"twitter"])
        {
            [self TwitterButtonPressed];
        }
        else if ([lCSSubItem.subItemTitle isEqualToString: @"google"])
        {
            [self googleButtonPressed];
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark - Social Login Selector
#pragma mark -


- (void)linkedInButtonPressed
{
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION, nil]
                                         state:@"some state"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(id returnState) {
                                      [[LISDKSessionManager sharedInstance] session];
                                      if ([LISDKSessionManager hasValidSession])
                                      {
                                          NSString *urlString = [NSString stringWithFormat:@"%@/people/~:(id,first-name,last-name,maiden-name,email-address,picture-url)", LINKEDIN_API_URL];
                                          [[LISDKAPIHelper sharedInstance]getRequest:urlString success:^(LISDKAPIResponse *response)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^(void)
                                                              {
                                                                  [self linkedInloginButtonDidCompleteWithResult:response];
                                                              });
                                           }
                                                                               error:^(LISDKAPIError *error)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^(void)
                                                              {
                                               NSLog(@"%s %@","error called! ", [error description]);
                                               [mDelegate socialLogin:self didSignInWithType:@"linkedIn" WithResponse:nil withError:error];
                                               [self.collectionView reloadData];
                                                              });
                                               
                                           }];
                                          
                                      }
                                      
                                  }
                                    errorBlock:^(NSError *error) {
                                        dispatch_async(dispatch_get_main_queue(), ^(void)
                                                       {
                                        [mDelegate socialLogin:self didSignInWithType:@"linkedIn" WithResponse:nil withError:error];
                                        [self.collectionView reloadData];
                                                       });

                                        
                                    }
     ];
}


- (void)TwitterButtonPressed
{
#if 0
//    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error)
    [[Twitter sharedInstance] logInWithViewController: [self rootController] completion:^(TWTRSession *session, NSError *error)
     {
         [self removeViewControllerFromWindow];
        if (session) {
            TWTRAPIClient* lClient = [[TWTRAPIClient alloc] init];
            [lClient loadUserWithID:[session userID]
                                                      completion:^(TWTRUser *user,
                                                                   NSError *error)
             {
                 if (![error isEqual:nil]) {
                     NSLog(@"Twitter info   -> user = %@ ",user);
                     
                     TWTRShareEmailViewController *shareEmailViewController =
                     [[TWTRShareEmailViewController alloc]
                      initWithCompletion:^(NSString *email, NSError *errorWhileEmail)
                      {
                          [self removeViewControllerFromWindow];
                          [mCtr removeFromParentViewController];
                          [mCtr.view removeFromSuperview];
                          mCtr=nil;
                          if (errorWhileEmail) {
                              [mDelegate socialLogin:self didSignInWithType:@"twitter" WithResponse:nil withError:errorWhileEmail];

                          }
                          else
                          {
                              NSString  *token=session.authToken;
                              NSMutableDictionary *twtResponse=[[NSMutableDictionary alloc]init];
                              [twtResponse setObject:user.name forKey:@"Name"];
                              [twtResponse setObject:user.userID forKey:@"UserID"];
                              [twtResponse setObject:user.profileImageLargeURL forKey:@"ImageURL"];
                            if (email)
                              [twtResponse setObject:email forKey:@"Email"];
                              CSSocialLoginUser *lUserInfo=[[LoginManager SharedInstance] userInfoWithRespose:twtResponse ofType:3 withToken:token];
                              [mDelegate socialLogin:self didSignInWithType:@"twitter" WithResponse:lUserInfo withError:nil];
                          }
                          [self.collectionView reloadData];

                      }];
                     
                     [[self rootController] presentViewController:shareEmailViewController
                                                         animated:YES
                                                       completion:nil];
                     
                 } else {
                     [mDelegate socialLogin:self didSignInWithType:@"twitter" WithResponse:nil withError:error];
                     [self.collectionView reloadData];

                 }
             }];
        } else {
            [mDelegate socialLogin:self didSignInWithType:@"twitter" WithResponse:nil withError:error];
            [self.collectionView reloadData];

        }
    }];
#endif
}


- (void)googleButtonPressed
{
    [self setUpGoogleDelegate];
    [[GIDSignIn sharedInstance]signIn];
    
}

- (void)logOutButtonPressed
{
    
    [[LoginManager SharedInstance]signOut];
}
-(void)disconnectButtonPressed
{
    [[LoginManager SharedInstance]disconnect];

}

-(void)facebookLoginButtonClicked
{
    
    mFBManager = [[FBSDKLoginManager alloc] init];
    [mFBManager
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:[self rootController]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         [self removeViewControllerFromWindow];

         if (error) {
             NSLog(@"Process error");
             [mDelegate socialLogin:self didSignInWithType:@"facebook" WithResponse:nil withError:[[NSError alloc]initWithDomain:@"Process error" code:1 userInfo:nil]];
             [self.collectionView reloadData];

         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             [mDelegate socialLogin:self didSignInWithType:@"facebook" WithResponse:nil withError:[[NSError alloc]initWithDomain:@"Cancelled" code:1 userInfo:nil]];
             [self.collectionView reloadData];

         } else {
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,email,picture,first_name,last_name,age_range,gender" forKey:@"fields"];
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSMutableDictionary *response, NSError *error) {
                  if (!error) {
                      NSString *token=result.token.tokenString;
                      NSMutableDictionary *lLoginDict = [response mutableCopy];
                      CSSocialLoginUser *lUserInfo=[[LoginManager SharedInstance] userInfoWithRespose:lLoginDict ofType:5 withToken:token];
                      [mDelegate socialLogin:self didSignInWithType:@"facebook" WithResponse:lUserInfo withError:nil];
                      [self.collectionView reloadData];

                      
                  }
                  else
                  {
                      [mDelegate socialLogin:self didSignInWithType:@"facebook" WithResponse:nil withError:error];
                      [self.collectionView reloadData];

                      
                  }
              }];
         }
     }];
}

-(void)removeViewControllerFromWindow
{
    [mCtr removeFromParentViewController];
    [mCtr.view removeFromSuperview];
    [mWindow resignKeyWindow];
    mWindow = nil;
    
}

#pragma mark -
#pragma mark - Facebook Delegate
#pragma mark -


- (void)loginButton:	(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:	(NSError *)error
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);
         }
     }];
    
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
    
}

#pragma mark - GIDSignInDelegate


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user 
     withError:(NSError *)error
{
    [self removeViewControllerFromWindow];
    if (error) {
        [mDelegate socialLogin:self didSignInWithType:@"google" WithResponse:nil withError:error];
        [self.collectionView reloadData];

        return;
    }
    [self reportAuthStatus];
}


- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    [self removeViewControllerFromWindow];
    if (error) {
    } else {
        
        
    }
    [self reportAuthStatus];
}


- (void)presentSignInViewController:(UIViewController *)viewController
{
    UIViewController* lCtr = [self rootController];
    [lCtr presentViewController: viewController animated: true completion: nil];
}


- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
   
    UIViewController* lCtr = [self rootController];
    [lCtr presentViewController: viewController animated: true completion: nil];
}


- (void)reportAuthStatus
{
    GIDGoogleUser *googleUser = [[GIDSignIn sharedInstance] currentUser];
    NSString *token=googleUser.authentication.idToken;
    if (googleUser.authentication)
    {
        CSSocialLoginUser *lUserInfo=[[LoginManager SharedInstance] userInfoWithRespose:googleUser ofType:2 withToken:token];
        [mDelegate socialLogin:self didSignInWithType:@"google" WithResponse:lUserInfo withError:nil];
        [self.collectionView reloadData];

        
    } else
    {
        // To authenticate, use Google+ sign-in button.
    }
    
}

#pragma mark -
#pragma mark - LinkedIn Custom Method
#pragma mark -

- (void)linkedInloginButtonDidCompleteWithResult:(LISDKAPIResponse *)response
{
    NSString *token = [[LISDKSessionManager sharedInstance].session.accessToken accessTokenValue];
    NSData *objectData = [response.data dataUsingEncoding:NSUTF8StringEncoding];
    id lLoginDict = [NSJSONSerialization JSONObjectWithData:objectData options:kNilOptions error:nil];
    CSSocialLoginUser *lUserInfo=[[LoginManager SharedInstance] userInfoWithRespose:lLoginDict ofType:4 withToken:token];
    [mDelegate socialLogin:self didSignInWithType:@"linkedIn" WithResponse:lUserInfo withError:nil];
    [self.collectionView reloadData];
}

@end
