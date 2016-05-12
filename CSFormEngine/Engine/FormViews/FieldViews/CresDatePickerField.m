//
//  CresDataPickerField.m
//  Edumation
//
//  Created by Deepak on 09/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CresDatePickerField.h"
#import "CustomPopOverView.h"

#define kXGap               10.0
#define kHintIconSize       38.0

@implementation CresDatePickerField

@synthesize titleLabel = mTitleLabel;
@synthesize detailField = mDetailField;
@synthesize delegate = mDelegate;
@synthesize hintText = mHintText;
@synthesize selectedDateStr = mSelectedDateStr;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect lTitleRect = self.bounds;
     lTitleRect.origin.x = kXGap;
    lTitleRect.size.width = 100;
    
    mTitleLabel.frame = lTitleRect;
    
    CGRect lDetailRect = self.bounds;
    lDetailRect.origin.x = CGRectGetMaxX(lTitleRect);
    lDetailRect.size.width = self.bounds.size.width - CGRectGetMaxX(lTitleRect) - kHintIconSize - kXGap;
    mDetailField.frame = lDetailRect;
    
    CGRect lHintBtnRect = self.bounds;
    lHintBtnRect.origin.x = CGRectGetMaxX(self.bounds) - kHintIconSize;
    lHintBtnRect.origin.y = (CGRectGetHeight(self.bounds) - kHintIconSize)/2;
    lHintBtnRect.size.width = kHintIconSize;
    lHintBtnRect.size.height = kHintIconSize;
    mHintIconBtn.frame = lHintBtnRect;
    
    [self setNeedsDisplay];
}

- (void)setPefilledDateValue: (NSString*)selectedDate
{
    if (!selectedDate.length)
    {
        return;
    }
    
    NSDateFormatter* lFormate = [[NSDateFormatter alloc] init];
    [lFormate setDateFormat:@"MMyy"];
    NSTimeZone* lZone = [NSTimeZone defaultTimeZone];
    [lFormate setTimeZone: lZone];
    NSDate* lDate = [lFormate dateFromString: selectedDate];
    if (lDate)
    {
        lFormate = [[NSDateFormatter alloc] init];
        [lFormate setDateFormat:@"MMMM yyyy"];
        lZone = [NSTimeZone defaultTimeZone];
        [lFormate setTimeZone: lZone];
        NSString* lDatePickerStr = [lFormate stringFromDate: lDate];
        mDetailField.text = lDatePickerStr;
    }
}

- (void)addSubviews
{
    mTitleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    mTitleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:15];
    mTitleLabel.backgroundColor = [UIColor clearColor];
    mTitleLabel.numberOfLines = 0;
    [self addSubview: mTitleLabel];
    
    mDetailField = [[UITextField alloc] initWithFrame: CGRectZero];
    mDetailField.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:15];
    mDetailField.backgroundColor = [UIColor clearColor];
    mDetailField.enabled = FALSE;
    [self addSubview: mDetailField];
    
    mHintIconBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    mHintIconBtn.hidden = TRUE;
    [mHintIconBtn addTarget: self action: @selector(hintIconClicked:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: mHintIconBtn];
    
    UITapGestureRecognizer* lTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tabOnField:)];
    [self addGestureRecognizer: lTapGesture];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect: rect];
    
    CGContextRef lContext = UIGraphicsGetCurrentContext();
    UIColor* lColor = [UIColor colorWithRed: 214.0/255.0 green: 214.0/255.0 blue: 214.0/255.0 alpha: 1.0];
    CGContextSetStrokeColorWithColor(lContext, lColor.CGColor);
    CGContextSetFillColorWithColor(lContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(lContext, 1.0);
    
    CGContextMoveToPoint(lContext, rect.origin.x, rect.origin.y+1);
    CGContextAddLineToPoint(lContext, CGRectGetWidth(rect), rect.origin.y+1);
    
    CGContextMoveToPoint(lContext, rect.origin.x, CGRectGetHeight(rect)-1);
    CGContextAddLineToPoint(lContext, CGRectGetWidth(rect), CGRectGetHeight(rect)-1);
    
    CGContextStrokePath(lContext);
    CGContextFillPath(lContext);
}

- (void)setHintText:(NSString *)hintText
{
    if (hintText.length)
    {
        mHintIconBtn.hidden = FALSE;
        [mHintIconBtn setImage: [UIImage imageNamed: @"info.png"] forState: UIControlStateNormal];

    }
    
    mHintText = [hintText copy];
}

- (void)tabOnField: (id)sender
{
    if (mDatePicker)
    {
        [mDatePicker removeFromSuperview];
        mDatePicker = nil;
        return;
    }

    if ([mDelegate respondsToSelector: @selector(presentPickerInView:andRect:forCresDatePickerField:)])
    {
        UIView* lPresentInview = nil;
        CGRect lPresentRect = CGRectZero;
        [mDelegate presentPickerInView: &lPresentInview andRect: &lPresentRect forCresDatePickerField: self];
        
        if (lPresentInview)
        {
            CGRect lRect = lPresentRect;
            lRect.origin.y += CGRectGetHeight(lRect);

            mDatePicker = [[NTMonthYearPicker alloc] initWithFrame:CGRectMake(0, 0, lRect.size.width, lRect.size.height)];
            mDatePicker.backgroundColor = [UIColor whiteColor];
            mDatePicker.frame = lRect;
            [mDatePicker setMaximumDate:[NSDate date]];
            
            // Set mode to month + year
            // This is optional; default is month + year
            mDatePicker.datePickerMode = NTMonthYearPickerModeMonthAndYear;
            
            [mDatePicker addTarget: self action: @selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            [lPresentInview addSubview: mDatePicker];
            [lPresentInview bringSubviewToFront: mDatePicker];
            
            [UIView animateWithDuration:0.2
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 mDatePicker.frame = lPresentRect;
                             }
                             completion:^(BOOL finished){
                                [lPresentInview bringSubviewToFront: mDatePicker];
                             }];
        }
    }
}

- (void)onDatePickerValueChanged: (id)sender
{
    NSDateFormatter* lFormate = [[NSDateFormatter alloc] init];
    [lFormate setDateFormat:@"MMMM yyyy"];
    NSTimeZone* lZone = [NSTimeZone defaultTimeZone];
    [lFormate setTimeZone: lZone];

    mDetailField.text = [lFormate stringFromDate: mDatePicker.date];
    
    [lFormate setDateFormat:@"MMyy"];
    lZone = [NSTimeZone defaultTimeZone];
    [lFormate setTimeZone: lZone];
    self.selectedDateStr = [lFormate stringFromDate: mDatePicker.date];
    
    if ([mDelegate respondsToSelector: @selector(didSelectValueInPicker:)])
    {
        [mDelegate didSelectValueInPicker: self];
    }
}

- (void)hintIconClicked: (id)sender
{
    UIApplication* lApplication = [UIApplication sharedApplication];
    UIWindow* lWindow = lApplication.delegate.window;
    CGRect lHintBtnRectInSelf = [self convertRect: mHintIconBtn.frame toView: lWindow.rootViewController.view];

    CGFloat lLabelMargin = 8.0;
    CGFloat lLableWidth = 210.0;

    NSDictionary* lAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 12.0]};
    CGRect lRect = [mHintText boundingRectWithSize:CGSizeMake(lLableWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:lAttributes context:nil];
    
    if (lRect.size.width < lLableWidth)
        lRect.size.width = lLableWidth;
    
    CustomPopOverView* lPopOver = [[CustomPopOverView alloc] initPopoverFromRect:  lHintBtnRectInSelf inView: lWindow.rootViewController.view withSize: CGSizeMake(lRect.size.width,  lRect.size.height + kTipHeight + 2*lLabelMargin) arrowDirections: CustomPopoverArrowDirectionDown];
    
    lRect.origin.y += lLabelMargin;
    
    lRect = CGRectInset(lRect, 5.0, 0.0);
    UILabel* lHintLabel = [[UILabel alloc] initWithFrame: lRect];
    lHintLabel.text = mHintText;
    lHintLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:12];
    lHintLabel.textAlignment = NSTextAlignmentCenter;
    lHintLabel.numberOfLines = 0;
    lHintLabel.textColor = [UIColor whiteColor];
    lHintLabel.backgroundColor = [UIColor clearColor];
    [lPopOver addSubview: lHintLabel];
}

@end
