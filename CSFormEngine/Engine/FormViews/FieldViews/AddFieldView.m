//
//  AddFieldView.m
//  Edumation
//
//  Created by Deepak on 11/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "AddFieldView.h"

@interface AddFieldView (Private)
- (UIViewController*)rootController;
- (void)openSearchPicker;
@end

@implementation AddFieldView

@synthesize addButton = mAddBtn;
@synthesize dataBinder = mDataBinder;
@synthesize delegate = mDelegate;
@synthesize pickerPlaceHolder = mPickerPlaceHolder;
@synthesize pickerHeadingMsg = mPickerHeadingMsg;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        CGRect lRect = CGRectInset(self.bounds, 2.0, 2.0);
        mAddBtn = [[UIButton alloc] initWithFrame: lRect];
        mAddBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [mAddBtn setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
        mAddBtn.titleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Bold" size:15];
        [mAddBtn addTarget: self action: @selector(addFieldClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview: mAddBtn];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect: rect];
    
    CGContextRef lContext = UIGraphicsGetCurrentContext();
    UIColor* lColor = [UIColor colorWithRed: 214.0/255.0 green: 214.0/255.0 blue: 214.0/255.0 alpha: 1.0];
    CGContextSetStrokeColorWithColor(lContext, lColor.CGColor);
    CGContextSetFillColorWithColor(lContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(lContext, 1.0);
    
    CGContextMoveToPoint(lContext, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(lContext, CGRectGetWidth(rect), rect.origin.y);
    
    CGContextMoveToPoint(lContext, rect.origin.x, CGRectGetHeight(rect)-1);
    CGContextAddLineToPoint(lContext, CGRectGetWidth(rect), CGRectGetHeight(rect)-1);
    
    CGContextStrokePath(lContext);
    CGContextFillPath(lContext);
}

- (void)addFieldClicked: (id)selector
{
    if (mDataBinder.bindType == EBindTypeSearchAndAddField)
    {
        [self openSearchPicker];
        return;
    }
    
    if ([mDelegate respondsToSelector: @selector(addFieldOnPageForFieldView:withItems:)])
    {
        //TODO: Deepak
        NSMutableArray* lItems = [[NSMutableArray alloc] init];
        NSMutableDictionary* lItem = [[NSMutableDictionary alloc] init];
        [lItems addObject: lItem];
        
        //TODO: Deepak
        [mDelegate addFieldOnPageForFieldView: self withItems: lItems];
    }
}

- (void)openSearchPicker
{
    if ([mDelegate respondsToSelector: @selector(willPresentPickerOnPageForFieldView:)]) {
        [mDelegate willPresentPickerOnPageForFieldView: self];
    }
    
    SearchPickerCtr *lSearchPicker=[[SearchPickerCtr alloc] initWithLastSelected: mDataBinder.selectedItems];
    lSearchPicker.delegate=self;
    lSearchPicker.pickerTitle = mAddBtn.titleLabel.text;
    lSearchPicker.pickerMsg=self.pickerHeadingMsg;
    lSearchPicker.pickerPlaceholder=self.pickerPlaceHolder;

    UIViewController *lCtr = [self rootController];
    [lCtr presentViewController:lSearchPicker animated:YES completion:nil];
}

-(UIViewController*)rootController
{
    if (mWindow)
    {
        return mWindow.rootViewController;
    }
    
    mWindow = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    mWindow.backgroundColor = [UIColor clearColor] ;
    mWindow.windowLevel = UIWindowLevelNormal;
    
    UIViewController* lCtr = [[UIViewController alloc] init];
    lCtr.view.frame = [[UIScreen mainScreen] bounds];
    [mWindow setRootViewController: lCtr];
    
    [mWindow makeKeyAndVisible];
    return lCtr;
}

#pragma mark-
#pragma mark- SearchPickerDelegate
#pragma mark-

- (void)willDissmissSearckPicker: (SearchPickerCtr*)searchPicker onClickingBtn:(NSString *)btn selectedItems: (NSArray*)selectedItems
{
    UIViewController *lCtr = [self rootController];
        if ([btn isEqualToString:@"next"])
        {
            if ([mDelegate respondsToSelector: @selector(addFieldOnPageForFieldView:withItems:)])
            {
                [mDataBinder.selectedItems removeAllObjects];
                [mDataBinder.selectedItems addObjectsFromArray: selectedItems];
                [mDelegate addFieldOnPageForFieldView: self withItems: selectedItems];
            }
        }
    
    [ lCtr dismissViewControllerAnimated:YES completion:^{
        [mWindow resignKeyWindow];
        mWindow = nil;
    }];
}

@end
