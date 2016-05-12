//
//  CSObjectiveQuestionView.m
//  CSFormEngine
//
//  Created by Deepak on 28/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "CSObjectiveQuestionView.h"

@interface CSObjectiveQuestionView (Private)

- (void)initialiseLayout;
- (ObjectiveQuestionIndexType)indexType;
- (void)removeAllSeleced;
@end

@implementation CSObjectiveQuestionView

@synthesize isMultipleChoice = mIsMultipleChoice;
@synthesize indexType = mIndexType;
@synthesize indexImage = mIndexImage;

- (instancetype)initWithFrame:(CGRect)frame
                 andFieldInfo: (CresFormFieldData*)fieldData
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 0.2];
        mFieldData = fieldData;
        [self initialiseLayout];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)initialiseLayout
{
    CGRect lRect = self.bounds;
    
    NSString* lQuestionText = mFieldData.fieldValue;
    UIFont* lQuestionFont = kQuestionFont;
    CGRect lQLabelRect = CGRectZero;
    lQLabelRect = [lQuestionText boundingRectWithSize: CGSizeMake(lRect.size.width - 2*kXMarginQuestion, lRect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:lQuestionFont } context:nil];
    
    lQLabelRect.origin.y += kYMarginQuestion;
    if (CGRectGetWidth(lQLabelRect) < CGRectGetWidth(lRect) - 2*kXMarginQuestion)
        lQLabelRect.size.width = CGRectGetWidth(lRect) - 2*kXMarginQuestion;
    lQLabelRect.origin.x = (CGRectGetWidth(lRect) - CGRectGetWidth(lQLabelRect))/2;
    
    mQuestionLabel = [[UILabel alloc] initWithFrame: lQLabelRect];
    mQuestionLabel.backgroundColor = [UIColor clearColor];
    mQuestionLabel.font = lQuestionFont;
    mQuestionLabel.text = lQuestionText;
    mQuestionLabel.numberOfLines = 0;
    [self addSubview: mQuestionLabel];
    
    NSString* lHintText = mFieldData.fieldHint;
    CGRect lHintFrame = CGRectZero;
    lHintFrame.origin.y = CGRectGetMaxY(lQLabelRect);

    if (lHintText.length)
    {
        lHintFrame = [lHintText boundingRectWithSize:CGSizeMake(lRect.size.width - 2*kXMarginQuestion, lRect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:kQuestionHintFont } context:nil];
        if (CGRectGetWidth(lHintFrame) < CGRectGetWidth(lRect) - 2*kXMarginQuestion)
            lHintFrame.size.width = CGRectGetWidth(lRect) - 2*kXMarginQuestion;

        lHintFrame.origin.y = CGRectGetMaxY(lQLabelRect);
        lHintFrame.origin.y += kMarginBetweenQAndOptions;
        lHintFrame.origin.x = (CGRectGetWidth(lRect) - CGRectGetWidth(lHintFrame))/2;
        UILabel* lHintLabel = [[UILabel alloc] initWithFrame: lHintFrame];
        lHintLabel.backgroundColor = [UIColor clearColor];
        lHintLabel.font = kQuestionHintFont;
        lHintLabel.textAlignment = NSTextAlignmentCenter;
        lHintLabel.text = lHintText;
        lHintLabel.numberOfLines = 0;
        [self addSubview: lHintLabel];
    }
    
    NSArray* lOptions = mFieldData.subItemsInfo.subItems;
    CGRect lOptBaseRect = CGRectZero;
    lOptBaseRect.origin.y = CGRectGetMaxY(lHintFrame);
    lOptBaseRect.origin.y += kMarginBetweenQAndOptions;
    UIFont* lOptFont = kOptionFont;
    mAnswersLabels = [[NSMutableArray alloc] init];
    
    ObjectiveQuestionIndexType lIndexType = [self indexType];
    CGSize lOptionContraintSize = CGSizeMake(lRect.size.width - 2*kXMarginOption,lRect.size.height);
    if (lIndexType != EObjectiveQuestionIndexDefault)
    {
        lOptionContraintSize.width -= kIndexButtonWidth;
        lOptionContraintSize.width -= kXMarginOption;
    }
    
    NSInteger lIndex = 1;
    for (CSSubItem* lSubItem in lOptions)
    {
        NSString* lSubItemTitle = lSubItem.subItemTitle;
        CGRect lOptBaseFrame = [lSubItemTitle boundingRectWithSize: lOptionContraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:lOptFont} context:nil];
        lOptBaseFrame.size.height += 2*kYOffsetOptionText;

        if(CGRectGetHeight(lOptBaseFrame) < kMinOptionLabelHeight)
            lOptBaseFrame.size.height = kMinOptionLabelHeight;
        
        lOptBaseRect.size.height = lOptBaseFrame.size.height;
        lOptBaseRect.size.width = lOptBaseFrame.size.width;
        
        if (CGRectGetWidth(lOptBaseRect) < CGRectGetWidth(lRect) - 2*kXMarginOption)
            lOptBaseRect.size.width = CGRectGetWidth(lRect) - 2*kXMarginOption;
        
        lOptBaseRect.origin.x = (CGRectGetWidth(lRect) - CGRectGetWidth(lOptBaseRect))/2;
        
        UIView* lOptBaseView = [[UIView alloc] initWithFrame: lOptBaseRect];
        lOptBaseView.tag = lIndex - 1;
        lOptBaseView.backgroundColor = [UIColor whiteColor];
        [self addSubview: lOptBaseView];
        [mAnswersLabels addObject: lOptBaseView];
        
        UITapGestureRecognizer* lGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOnOption:)];
        [lOptBaseView addGestureRecognizer: lGestureRecognizer];
        
        CGRect lOptLabelRect = lOptBaseView.bounds;
        lOptLabelRect.origin.x += kXOffsetOptionText;
        lOptLabelRect.size.width -= 2*kXOffsetOptionText;
        UILabel* lOptionLabel = [[UILabel alloc] initWithFrame: lOptLabelRect];
        lOptionLabel.backgroundColor = [UIColor clearColor];
        lOptionLabel.font = lOptFont;
        lOptionLabel.text = lSubItemTitle;
        lOptionLabel.numberOfLines = 0;
        [lOptBaseView addSubview: lOptionLabel];
        
        lOptBaseRect.origin.y = CGRectGetMaxY(lOptBaseRect);
        lOptBaseRect.origin.y += kMarginBetweenOptions;
        
        if (lIndexType == EObjectiveQuestionIndexDefault)
            continue;

        CGRect lIndexBtnRect = lOptBaseView.bounds;
        lIndexBtnRect.size.height = CGRectGetHeight(lOptBaseFrame) > kIndexButtonWidth ? kIndexButtonWidth : CGRectGetHeight(lOptBaseRect);
        lIndexBtnRect.size.width = lIndexBtnRect.size.height;
        lIndexBtnRect.origin.x = kXOffsetOptionText/2;
        lIndexBtnRect.origin.y = (CGRectGetHeight(lOptBaseRect) - kIndexButtonWidth)/2;
        
        UIButton* lIndexBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        lIndexBtn.frame = lIndexBtnRect;
        lIndexBtn.titleLabel.font = kOptionIndexFont;
        NSString* lTitle = [self optionIndexStrForIndexType: lIndexType andIndex: lIndex];
        [lIndexBtn setTitle: lTitle forState: UIControlStateNormal];
        [lOptBaseView addSubview: lIndexBtn];
        NSDictionary* lSubItemLayoutParams = mFieldData.subItemsInfo.subItemLayoutInfo;
        NSString* lIndexBtnShape = [lSubItemLayoutParams objectForKey: @"indexShape"];
        if (lIndexBtnShape && [lIndexBtnShape compare: @"Rounded" options: NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            lIndexBtn.layer.cornerRadius = CGRectGetWidth(lIndexBtnRect)/2;
            lIndexBtn.clipsToBounds = YES;
        }
        if (lIndexType == EObjectiveQuestionIndexImage)
        {            
            [lIndexBtn setImage: kDefaultUnSelectImage forState: UIControlStateNormal];
            [lIndexBtn setImage: kDefaultSelectImage forState: UIControlStateSelected];
        }
        else
        {
            lIndexBtn.backgroundColor = [UIColor colorWithRed: 34.0/255.0 green: 171.0/255.0 blue: 240.0/255.0 alpha: 1.0];
            [lIndexBtn setTitleColor: [UIColor colorWithWhite: 1.0 alpha: 1.0] forState: UIControlStateNormal];
            [lIndexBtn setTitleColor: [UIColor colorWithWhite: 0.5 alpha: 0.5] forState: UIControlStateHighlighted];
            [lIndexBtn setTitleColor: [UIColor colorWithWhite: 0.5 alpha: 0.5] forState: UIControlStateSelected];
        }
        
        lOptLabelRect.origin.x += CGRectGetMaxX(lIndexBtnRect);
        lOptLabelRect.origin.x += kXOffsetOptionText;
        lOptLabelRect.size.width -= lOptLabelRect.origin.x;
        lOptionLabel.frame = lOptLabelRect;
        
        lIndex += 1;
    }
}

- (void)adjustLayout
{
    
}

- (ObjectiveQuestionIndexType)indexType
{
    NSDictionary* lSubItemLayoutParams = mFieldData.subItemsInfo.subItemLayoutInfo;
    NSString* lIndexTypeStr = [lSubItemLayoutParams objectForKey: @"indexType"];

    if ([lIndexTypeStr compare: @"default" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return EObjectiveQuestionIndexDefault;
    }
    else if ([lIndexTypeStr compare: @"Alphabetic" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return EObjectiveQuestionIndexAlphabet;
    }
    else if ([lIndexTypeStr compare: @"Numeric" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return EObjectiveQuestionIndexNum;
    }
    else if ([lIndexTypeStr compare: @"Custom" options: NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return EObjectiveQuestionIndexImage;
    }
    
    return EObjectiveQuestionIndexDefault;
}

- (NSString*)optionIndexStrForIndexType: (ObjectiveQuestionIndexType)indexType
                               andIndex: (NSInteger)index
{
    NSString* lRetIndexTitleStr = @"";
    if (indexType == EObjectiveQuestionIndexAlphabet)
    {
        lRetIndexTitleStr = [NSString stringWithFormat: @"%c", 64+(int)index];
        return lRetIndexTitleStr;
    }
    else if(indexType == EObjectiveQuestionIndexNum)
    {
        lRetIndexTitleStr = [NSString stringWithFormat: @"%d", (int)index];
        return lRetIndexTitleStr;
    }
    
    return lRetIndexTitleStr;
}

- (void)removeAllSeleced
{
    for (UIView* lOptionView in mAnswersLabels)
    {
        lOptionView.backgroundColor = [UIColor whiteColor];
        NSArray* lSubViews = [lOptionView subviews];
        for (UIView* lSubView in lSubViews)
        {
            if ([lSubView isKindOfClass: [UIButton class]])
            {
                UIButton* lButton = (UIButton*)lSubView;
                [lButton setSelected: FALSE];
            }
        }
    }
}

- (void)tapOnOption: (UITapGestureRecognizer*)gesture
{
    BOOL lIsSingleSelect = (mFieldData.fieldType == ECresFieldTypeObjectiveSingleChoice);
    UIView* lTapOnView = [gesture view];
    
    if (lIsSingleSelect)
        [self removeAllSeleced];
    
    NSArray* lSubViews = [lTapOnView subviews];
    for (UIView* lSubView in lSubViews)
    {
        if ([lSubView isKindOfClass: [UIButton class]])
        {
            UIButton* lButton = (UIButton*)lSubView;
            [lButton setSelected: !lButton.selected];
            lTapOnView.backgroundColor = (lButton.selected) ? [UIColor lightGrayColor] : [UIColor whiteColor];
        }
    }
}

@end
