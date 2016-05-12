//
//  CSFieldSizeCalculator.m
//  CSFormEngine
//
//  Created by Deepak on 29/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "CSFieldSizeCalculator.h"

@implementation CSFieldSizeCalculator

+ (CGSize)sizeFitsForField: (CresFormFieldData*)fieldData
         constrainedToSize: (CGSize)constraintSize
{
    CGSize lRetSize = CGSizeZero;
    lRetSize.width = constraintSize.width;
    
    if (fieldData.fieldType == ECresFieldTypeObjectiveSingleChoice
        || fieldData.fieldType == ECresFieldTypeObjectiveMultiChoice)
    {
        NSString* lQuestionText = fieldData.fieldValue;
        NSArray* lOptions = fieldData.subItemsInfo.subItems;
        NSDictionary* lSubItemLayoutInfo = fieldData.subItemsInfo.subItemLayoutInfo;
        
        lRetSize.height += kYMarginQuestion;
        UIFont* lQuestionFont = kQuestionFont;
        CGSize lQConstraintSize = constraintSize;
        lQConstraintSize.width -= 2*kXMarginQuestion;
        CGRect lQFrame = [lQuestionText boundingRectWithSize:lQConstraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:lQuestionFont } context:nil];
        
        lRetSize.height += CGRectGetHeight(lQFrame);
        lRetSize.height += kMarginBetweenQAndOptions;
        
        NSString* lHintText = fieldData.fieldHint;
        if (lHintText.length)
        {
            CGRect lHintFrame = [lHintText boundingRectWithSize:lQConstraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:kQuestionHintFont } context:nil];
            
            lRetSize.height += CGRectGetHeight(lHintFrame);
            lRetSize.height += kMarginBetweenQAndOptions;
        }
        
        CGSize lOptConstraintSize = constraintSize;
        lOptConstraintSize.width -= 2*kXMarginOption;
        lOptConstraintSize.width -= 2*kXOffsetOptionText;
        if (![[lSubItemLayoutInfo objectForKey: @"indexType"] isEqualToString: @"default"])
        {
            lOptConstraintSize.width -= kIndexButtonWidth;
            lOptConstraintSize.width -= kXOffsetOptionText;
        }
        
        UIFont* lOptFont = kOptionFont;
        for (CSSubItem* lSubItem in lOptions)
        {
            NSString* lSubItemTitle = lSubItem.subItemTitle;
            CGRect lOptFrame = [lSubItemTitle boundingRectWithSize:lOptConstraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:lOptFont} context:nil];
            lOptFrame.size.height += 2*kYOffsetOptionText;

            if(lOptFrame.size.height < kMinOptionLabelHeight)
                lOptFrame.size.height = kMinOptionLabelHeight;

            lRetSize.height += CGRectGetHeight(lOptFrame);
            lRetSize.height += kMarginBetweenOptions;
        }
    }
    else if(fieldData.fieldType == ECresFieldTypePlainText)
    {
        NSString* lPlainText = fieldData.fieldValue;
        UIFont* lPlainTextFont = kQuestionFont;
        CGSize lPlainTextConstraintSize = constraintSize;
        lPlainTextConstraintSize.width -= 2*kXMarginQuestion;
        CGRect lPlainTextFrame = [lPlainText boundingRectWithSize:lPlainTextConstraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:lPlainTextFont } context:nil];
        
        lPlainTextFrame.size.height += 2*kYOffsetOptionText;
        return CGSizeMake(lPlainTextFrame.size.width, lPlainTextFrame.size.height);
    }
    
    return lRetSize;
}


@end
