//
//  CSSocialLoginUser.m
//  Edumation
//
//  Created by Ankit Gupta on 11/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CSSocialLoginUser.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <objc/runtime.h>
#import "LoginManager.h"


@interface CSSocialLoginUser ()

@property (nonatomic, strong) UIImage *profileImage;

@end

@implementation CSSocialLoginUser

- (instancetype)initWithSocialResponse: (id)response
                                ofType: (NSInteger)loginType
                             withToken:(NSString *)token
{
    if (self) {
        
        self.loginType=loginType;
        self.token=token;
        
        if (loginType==4)
        {
            [self linkedInAPIWithResponse:response];
        }
        else  if (loginType==5)
        {
            [self facebookAPIWithResponse:response];
        }
        else  if (loginType==3)
        {
            [self twitterAPIWithResponse:response];
        }
        else  if (loginType==2)
        {
            [self googleAPIWithResponse:response];
        }
        else  if (loginType==1)
        {
            [self nonSocial:response];
        }
        else  if (loginType==0)
        {
            [self profileData:response];
        }

//        [self saveResponseInUserDefault];
    }

    return self;
}

-(void)linkedInAPIWithResponse:(id)response
{
    
    self.profileImageUrl=[NSURL URLWithString:[response objectForKey:@"pictureUrl"]];
    self.lastName=[response objectForKey:@"lastName"];
    self.userId=[response objectForKey:@"id"];
    self.firstName=[response objectForKey:@"firstName"];
    self.email=[response objectForKey:@"emailAddress"];
    [self setFirsNameAndLastName:self.name];
}

-(void)nonSocial:(id)response
{
    NSDictionary *userInfo=[response objectForKey:@"data"];
    
    self.email=[userInfo objectForKey:@"Email"];
    self.firstName=[userInfo objectForKey:@"FName"];
    self.name=[userInfo objectForKey:@"Name"];
    self.lastName=[userInfo objectForKey:@"LName"];
    self.profileImage=[userInfo objectForKey:@"ImageRawData"];
    self.password=[userInfo objectForKey:@"Password"];
    self.dateOfBirth=[userInfo objectForKey:@"BirthYear"];
    self.studentID=[userInfo objectForKey:@"StudentID"];
    self.teacherID=[userInfo objectForKey:@"TeacherID"];
    [self setFirsNameAndLastName:self.name];
    
}


-(void)googleAPIWithResponse:(id)response
{
    if ([response isKindOfClass:[GIDGoogleUser class]])
    {
        GIDGoogleUser *lResponse = (GIDGoogleUser *)response;

        self.profileImageUrl=[lResponse.profile imageURLWithDimension:120];
        self.userId=lResponse.userID;
        self.name=lResponse.profile.name;
        self.email=lResponse.profile.email;
        [self setFirsNameAndLastName:self.name];


    }
}

-(void)facebookAPIWithResponse:(id)response
{

    self.name=[response objectForKey:@"name"];
    self.lastName=[response objectForKey:@"last_name"];
    self.userId=[response objectForKey:@"id"];
    self.gender=[response objectForKey:@"gender"];
    self.firstName=[response objectForKey:@"first_name"];
    self.email=[response objectForKey:@"email"];
    self.firstName=[response objectForKey:@"first_name"];
    self.profileImageUrl=[NSURL URLWithString:[[[response objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]];
    [self setFirsNameAndLastName:self.name];



}

-(void)twitterAPIWithResponse:(id)response
{
    self.email=[response objectForKey:@"Email"];
    self.name=[response objectForKey:@"Name"];
    self.profileImageUrl=[NSURL URLWithString:[response objectForKey:@"ImageURL"]];
    self.userId=[response objectForKey:@"UserID"];
    [self setFirsNameAndLastName:self.name];

}

-(void)profileData:(id)response

{
    self.email=[response objectForKey:@"Email"];
    self.name=[response objectForKey:@"Name"];
    self.firstName=[response objectForKey:@"FName"];
    self.gender=[response objectForKey:@"Gender"];
    self.profileImage=[response objectForKey:@"ImageRawData"];
    self.profileImageUrl=[NSURL URLWithString:[response objectForKey:@"ImageURL"]];
    self.lastName=[response objectForKey:@"LName"];
    self.phoneNumber=[response objectForKey:@"MobileNo"];
    self.password=[response objectForKey:@"Password"];
    self.dateOfBirth=[response objectForKey:@"BirthYear"];
    self.studentID=[response objectForKey:@"StudentID"];
    self.teacherID=[response objectForKey:@"TeacherID"];
    self.roleType=[[response objectForKey:@"RoleId"] integerValue];
    self.userId=[response objectForKey:@"UserID"];
    self.loginType=[[response objectForKey:@"SignupTypeId"] integerValue];
    [self setFirsNameAndLastName:self.name];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)getProfileImage:(void (^)(BOOL succeeded, UIImage *image))getImageInBlock
{
    UIImage *profileImage=[self getImageFromDocumentDirectory];
    
    getImageInBlock(YES,profileImage);
    
    if (self.profileImageUrl) {
        [self downloadImageWithURL:self.profileImageUrl completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded)
            {
                self.profileImage=image;
                [self saveImageInDocumentDirectory:image];
                getImageInBlock(YES,self.profileImage);
                
                
            }
        }];

    }
}


-(void)saveResponseInUserDefaults
{
    NSMutableDictionary *ldictionary=[self dictionaryWithPropertiesOfObject:self];
    [LoginManager SharedInstance].socialLoginUser=self;
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:ldictionary];
    [[NSUserDefaults standardUserDefaults]setObject:encodedObject forKey:@"CSSocialLoginUserInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma Convert Object to NSDictionary

- (NSMutableDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([obj valueForKey:key])
            [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return dict;
}

-(void)setFirsNameAndLastName:(NSString *)name
{
    if (!name)
        return;
    
    NSArray *FLName=[name componentsSeparatedByString:@" "];
    if (FLName.count==1 && self.firstName==nil)
        self.firstName=[FLName objectAtIndex:0];
    else if (FLName.count>1 && self.firstName==nil) {
        self.firstName=[FLName objectAtIndex:0];
        self.lastName=[FLName objectAtIndex:1];
    }
}

-(void)saveImageInDocumentDirectory:(UIImage *)image
{
    if (!image)
        return;

    NSString *imagePath=[self getDocumentDirectoryPath];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:imagePath atomically:NO];
}

- (UIImage *)getImageFromDocumentDirectory
{
    NSString *imagePath=[self getDocumentDirectoryPath];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}

-(void)removeProfileImageFromDocumentDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagePath=[self getDocumentDirectoryPath];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:imagePath error:&error];
    if (!success) {
        NSLog(@"Could not delete Image -:%@ ",[error localizedDescription]);
    }
}
-(NSString *)getDocumentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"loginProfileImage.png"];
    return imagePath;
}
@end
