//
//  FormDataManager.m
//  CSFormEngine
//
//  Created by Deepak on 20/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "FormDataManager.h"

@interface FormDataManager (Private)

- (void)initialiseForms;

@end

@implementation FormDataManager

@synthesize forms = mForms;

+ (id)manager
{
    static dispatch_once_t once;
    static FormDataManager* sFormDataManager = nil;
    dispatch_once(&once, ^
                  {
                      sFormDataManager = [[self alloc] init];
                      [sFormDataManager initialiseForms];
                  });
    
    return sFormDataManager;
}

- (void)initialiseForms
{
    NSString* lBundlePath = [[NSBundle mainBundle] pathForResource:@"Form" ofType:@"json"];
    NSFileManager* lFileManager = [NSFileManager defaultManager];
    if (![lFileManager fileExistsAtPath: lBundlePath])
        return;
    
    NSData* lJsonData = [lFileManager contentsAtPath: lBundlePath];
    NSError* lError;
    
    if (lJsonData!=nil)
    {
        NSDictionary* lDict = [NSJSONSerialization JSONObjectWithData:lJsonData
                                                              options:kNilOptions error:&lError];
        NSMutableArray* lForms = [[NSMutableArray alloc] init];
        NSArray* lFormList = [lDict objectForKey: @"FormTypes"];
        for (NSDictionary* lFormInfo in lFormList)
        {
            CresFormData* lCresFormData = [[CresFormData alloc] initWithDict: lFormInfo];
            [lForms addObject: lCresFormData];
        }
        
        mForms = [[NSArray alloc] initWithArray: lForms];
    }
}

@end
