//
//  CSSocialLoginUser.h
//  Edumation
//
//  Created by Ankit Gupta on 11/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface CSSocialLoginUser : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *dateOfBirth;
@property (nonatomic, strong) NSString *studentID;
@property (nonatomic, strong) NSString *teacherID;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (assign) NSInteger roleType;
@property (assign) NSInteger loginType;


- (void)getProfileImage:(void (^)(BOOL succeeded, UIImage *image))getImageInBlock;
-(void)saveResponseInUserDefaults;
-(void)saveImageInDocumentDirectory:(UIImage *)image;

- (instancetype)initWithSocialResponse: (id)response
     ofType: (NSInteger)loginType withToken:(NSString *)token;


@end
