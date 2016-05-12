//
//  FormDataManager.h
//  CSFormEngine
//
//  Created by Deepak on 20/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CresFormData.h"

@interface FormDataManager : NSObject
{
    NSArray*            mForms;
}

@property(nonatomic, readonly)NSArray*            forms;

+ (id)manager;

@end
