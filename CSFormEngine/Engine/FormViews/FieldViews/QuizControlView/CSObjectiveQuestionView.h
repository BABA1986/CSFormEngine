//
//  CSObjectiveQuestionView.h
//  CSFormEngine
//
//  Created by Deepak on 28/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFormConstant.h"
#import "CresFormData.h"

@protocol CSObjectiveQuestionViewDelegate <NSObject>


@end

@interface CSObjectiveQuestionView : UIView
{
    UILabel*                        mQuestionLabel;
    NSMutableArray*                 mAnswersLabels;
    
    BOOL                            mIsMultipleChoice;
    ObjectiveQuestionIndexType      mIndexType;
    UIImage*                        mIndexImage;
    CresFormFieldData*              mFieldData;
}

@property(nonatomic, assign)BOOL                            isMultipleChoice;
@property(nonatomic, assign)ObjectiveQuestionIndexType      indexType;
@property(nonatomic, strong)UIImage*                        indexImage;


- (instancetype)initWithFrame:(CGRect)frame
                 andFieldInfo: (CresFormFieldData*)fieldData;
@end
