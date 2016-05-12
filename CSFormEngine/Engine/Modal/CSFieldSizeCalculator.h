//
//  CSFieldSizeCalculator.h
//  CSFormEngine
//
//  Created by Deepak on 29/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CresFormData.h"
#import "CSFormConstant.h"

@interface CSFieldSizeCalculator : NSObject
{
    
}

+ (CGSize)sizeFitsForField: (CresFormFieldData*)fieldData
         constrainedToSize: (CGSize)constraintSize;

@end
