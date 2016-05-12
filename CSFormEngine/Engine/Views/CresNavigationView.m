//
//  NavigationView.m
//  Edumation
//
//  Created by Deepak Kumar on 10/12/15.
//  Copyright © 2015 Correlation. All rights reserved.
//

#import "CresNavigationView.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation CresNavigationViewItem
@end

@interface CresNavigationView (Private)
- (void)addTitleLabel;
- (void)addLeftItemsBaseView;
- (void)addRightItemsBaseView;

- (BOOL)isLeftItemExistAtIndex: (NSInteger)index;
- (void)removeItemFromIndex: (NSInteger)index isLeftItem: (BOOL)isLeftItem;
- (void)addLeftItemAtIndex:(NSInteger)index item: (CresNavigationViewItem*)item;
- (void)addRightItemAtIndex:(NSInteger)index item:(CresNavigationViewItem*)item;
@end

@implementation CresNavigationView

@synthesize withStatusBar = mWithStatusBar;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        mWithStatusBar = TRUE;
        [self addTitleLabel];
        [self addLeftItemsBaseView];
        [self addRightItemsBaseView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
    [self refreshLayoutsParams];
}

- (void)setWithStatusBar:(BOOL)withStatusBar
{
    mWithStatusBar = withStatusBar;
    [self refreshLayoutsParams];
}

- (void)refreshLayoutsParams
{
    CGFloat lTop = mWithStatusBar ? 20.0 : 0.0;
    CGFloat lHeight = 64.0; lHeight -= lTop;
    
    ///////////////////////////////Title Label///////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mTitleLbl
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1.0
                                                       constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mTitleLbl
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0
                                                       constant:lTop]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mTitleLbl
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:lHeight]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mTitleLbl
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:0.45
                                                       constant:0]];
    
    ///////////////////////////////Left Navigation Bar///////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mLeftItemsBaseView
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeading
                                                     multiplier:1.0
                                                       constant:0]];
    
    //To do distance between label and button is not 5
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mLeftItemsBaseView
                                                      attribute:NSLayoutAttributeTrailing
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:mTitleLbl
                                                      attribute:NSLayoutAttributeLeading
                                                     multiplier:1.0
                                                       constant:5.0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mLeftItemsBaseView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:mTitleLbl
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0
                                                       constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mLeftItemsBaseView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:mTitleLbl
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0
                                                       constant:0]];
    
    ///////////////////////////////Right Navigation Bar///////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    //To do distance between label and button is not 5
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mRightItemsBaseView
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:mTitleLbl
                                                      attribute:NSLayoutAttributeTrailing
                                                     multiplier:1.0
                                                       constant:5.0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mRightItemsBaseView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:mTitleLbl
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0
                                                       constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mRightItemsBaseView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:mTitleLbl
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0
                                                       constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:mRightItemsBaseView
                                                      attribute:NSLayoutAttributeTrailing
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTrailing
                                                     multiplier:1.0
                                                       constant:0]];
    
    ///////////////////////////////Right Navigation Bar Items////////////////
    ///////////////////////////////Left Navigation Bar Items////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    
    NSArray* lItems = mLeftItemsBaseView.subviews;
//    CGFloat lItemTop =  ? 29.0 : 9.0;
    for (CresNavigationViewItem* lItem in lItems)
    {
        if ([lItem isKindOfClass: [CresNavigationViewItem class]])
        {
            CGFloat lItemTopAndBottom = lItem.imageView.image.size.height> lHeight ? 7 : 12;
            CGFloat lItemCorners = lItem.imageView.image.size.width > lItem.frame.size.width ? 7 : 12;
            if(lItem.imageView.image.size.width - lItem.imageView.image.size.height > 20)
                lItemTopAndBottom += IS_IPAD ? 8 : 5;
            else if(lItem.imageView.image.size.height - lItem.imageView.image.size.width > 20)
                lItemCorners += 5;
                
            lItem.contentEdgeInsets = UIEdgeInsetsMake(lItemTopAndBottom, lItemCorners, lItemTopAndBottom, lItemCorners);
        }
    }
    lItems = mRightItemsBaseView.subviews;
//    lItemTop = !mWithStatusBar ? 29.0 : 9.0;
    for (CresNavigationViewItem* lItem in lItems)
    {
        if ([lItem isKindOfClass: [CresNavigationViewItem class]])
        {
            CGFloat lItemTopAndBottom = lItem.imageView.image.size.height> lHeight ? 7 : 12;
            CGFloat lItemCorners = lItem.imageView.image.size.width > lItem.frame.size.width ? 7 : 12;
            if(lItem.imageView.image.size.width - lItem.imageView.image.size.height >20)
                lItemTopAndBottom += IS_IPAD ? 8 : 5;
            else if(lItem.imageView.image.size.height - lItem.imageView.image.size.width >20)
                lItemCorners += 5;
            
            lItem.contentEdgeInsets = UIEdgeInsetsMake(lItemTopAndBottom, lItemCorners, lItemTopAndBottom, lItemCorners);
        }
    }
    
}

- (void)addTitleLabel
{
    mTitleLbl = [[UILabel alloc] init];
    mTitleLbl.textAlignment = NSTextAlignmentCenter;
    mTitleLbl.backgroundColor = [UIColor clearColor];
    [mTitleLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview: mTitleLbl];
}

- (void)addLeftItemsBaseView
{
    mLeftItemsBaseView = [[UIView alloc] init];
    mLeftItemsBaseView.backgroundColor = [UIColor clearColor];
    [mLeftItemsBaseView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview: mLeftItemsBaseView];
}

- (void)addRightItemsBaseView;
{
    mRightItemsBaseView = [[UIView alloc] init];
    mRightItemsBaseView.backgroundColor = [UIColor clearColor];
    [mRightItemsBaseView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview: mRightItemsBaseView];
}

- (void)removeItemFromIndex: (NSInteger)index isLeftItem: (BOOL)isLeftItem
{
    NSArray* lItems = isLeftItem ? mLeftItemsBaseView.subviews : mRightItemsBaseView.subviews;
    for (CresNavigationViewItem* lItem in lItems)
    {
        if (lItem && lItem.index == index && [lItem isKindOfClass: [CresNavigationViewItem class]])
        {
            [lItem removeFromSuperview];
            break;
        }

    }
}

//TODO: If Last Index was Not Added Force to shift the item at previous Index Item Location
//Patch Due to the back button as the Image dimensions of btn is not same as others
- (BOOL)isLeftItemExistAtIndex: (NSInteger)index
{
    BOOL lRetVal = FALSE;
    NSArray* lItems = mLeftItemsBaseView.subviews;
    for (CresNavigationViewItem* lItem in lItems)
    {
        if (lItem && lItem.index == index && [lItem isKindOfClass: [CresNavigationViewItem class]])
        {
            lRetVal = TRUE;
            break;
        }
    }
    
    return lRetVal;
}

- (void)addLeftItemAtIndex:(NSInteger)index item:(CresNavigationViewItem *)item
{
    [self removeItemFromIndex: index isLeftItem: TRUE];
    [self refreshLayoutsParams];
    CGFloat lItemWidth = mWithStatusBar ? 44 : 64;
    //When text and image both are present leading constant at 0th index is 8 else 0
    CGFloat lLeadingConstantForZeroIndex = (item.titleLabel.text.length == 0) ? 0 :(IS_IPAD) ? 16 : 8;
    CGFloat lLeadingConstant = (!index) ? lLeadingConstantForZeroIndex : lItemWidth + lLeadingConstantForZeroIndex + 1;
    CGFloat lItemHeight = mWithStatusBar ? 44 : 64;
    
    //TODO: Patch Due to the bad Image of back button. Coomented on method as well.
    if ((item.imageView.image.size.width>50 && item.imageView.image.size.width != item.imageView.image.size.height) || !(item.titleLabel.text.length == 0))
        {
            lItemWidth = 64.0;
        }
    //Resize button frame when an image and text both are present on button
    if(item.currentBackgroundImage != nil && !(item.titleLabel.text.length == 0))
    {
        CGFloat backgroundImageHeight = (item.currentBackgroundImage.size.height > lItemHeight) ? 14 : 24;
        if(item.currentBackgroundImage.size.width - item.currentBackgroundImage.size.height > 20)
            backgroundImageHeight += IS_IPAD ? 8 : 5;
        lItemHeight -= backgroundImageHeight;
    }
    
    [item setTranslatesAutoresizingMaskIntoConstraints: NO];
    item.index = index;
    [mLeftItemsBaseView addSubview: item];
    
    [mLeftItemsBaseView addConstraint: [NSLayoutConstraint constraintWithItem:item
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:mLeftItemsBaseView
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0
                                                                     constant:lLeadingConstant]];
    
    [mLeftItemsBaseView addConstraint: [NSLayoutConstraint constraintWithItem:item
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:mLeftItemsBaseView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0]];
    
    [mLeftItemsBaseView addConstraint: [NSLayoutConstraint constraintWithItem:item
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:lItemHeight]];
    
    [mLeftItemsBaseView addConstraint: [NSLayoutConstraint constraintWithItem:item
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:lItemWidth]];
}

- (void)addRightItemAtIndex:(NSInteger)index item:(CresNavigationViewItem*)item
{
    [self removeItemFromIndex: index isLeftItem: FALSE];
    [self refreshLayoutsParams];
    CGFloat lItemWidth = mWithStatusBar ? 44 : 64;
    CGFloat lItemHeight = mWithStatusBar ? 44 : 64;
    if((item.imageView.image.size.width>50 && item.imageView.image.size.width != item.imageView.image.size.height)|| !(item.titleLabel.text.length == 0) )
    {
        lItemWidth = 64.0;
    }
    //Resize button frame when an image and text both are present on button
    if(item.currentBackgroundImage != nil || !(item.titleLabel.text.length == 0))
    {
        CGFloat backgroundImageHeight = (item.currentBackgroundImage.size.height > lItemHeight) ? 14 : 24;
        if(item.currentBackgroundImage.size.width - item.currentBackgroundImage.size.height > 20)
            backgroundImageHeight += IS_IPAD ? 8 : 5;
        lItemHeight -= backgroundImageHeight;
    }
    
    CGFloat lTrailingConstant = (!index) ? (index+1)*lItemWidth : (index+1)*lItemWidth + 1;
    [item setTranslatesAutoresizingMaskIntoConstraints: NO];
    item.index = index;
    [mRightItemsBaseView addSubview: item];
    
    [mRightItemsBaseView addConstraint: [NSLayoutConstraint constraintWithItem:item
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:mRightItemsBaseView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:-lTrailingConstant]];
    
    [mRightItemsBaseView addConstraint: [NSLayoutConstraint constraintWithItem:item
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:mRightItemsBaseView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0]];
    
    [mRightItemsBaseView addConstraint: [NSLayoutConstraint constraintWithItem:item
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:lItemHeight]];
    
    [mRightItemsBaseView addConstraint: [NSLayoutConstraint constraintWithItem:item
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:lItemWidth]];
}

- (void)addLeftItemAtIndex: (NSInteger)index
                 withImage: (UIImage*)image
                    target: (id)target
               andSelector: (SEL)selector
{
    //TODO: Now only Two Left items Are allowed
    assert(index < 2);
    CresNavigationViewItem* lItem = [CresNavigationViewItem buttonWithType: UIButtonTypeCustom];
    [lItem addTarget: target action: selector forControlEvents: UIControlEventTouchUpInside];
    [lItem setImage:image forState: UIControlStateNormal];
    lItem.contentMode = UIViewContentModeScaleAspectFit;
    [self addLeftItemAtIndex: index item: lItem];
}

- (void)addLeftItemAtIndex: (NSInteger)index
                 withImage: (UIImage*)image
                  withText: (NSString*)text
                    target: (id)target
               andSelector: (SEL)selector
{
    //TODO: Now only Two Left items Are allowed
    assert(index < 2);
    CresNavigationViewItem* lItem = [CresNavigationViewItem buttonWithType: UIButtonTypeCustom];
    [lItem addTarget: target action: selector forControlEvents: UIControlEventTouchUpInside];
    [lItem setTitle:text forState:UIControlStateNormal];
    lItem.titleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:14];
    lItem.titleLabel.adjustsFontSizeToFitWidth = YES;
    lItem.titleLabel.textColor = [UIColor whiteColor];
    [lItem setBackgroundImage:image forState: UIControlStateNormal];
    lItem.contentMode = UIViewContentModeScaleAspectFit;
    [self addLeftItemAtIndex: index item: lItem];
}

//Item must be the type of CresNavigationViewItem
- (void)addLeftItem: (CresNavigationViewItem*)item
             target: (id)target
        andSelector: (SEL)selector
{
    assert([item isKindOfClass: [CresNavigationViewItem class]]);
    NSArray* lItems = mLeftItemsBaseView.subviews;
    //TODO: Now only Two Left items Are allowed
    assert(lItems.count < 2);
    [self addLeftItemAtIndex: lItems.count item: item];
}

- (void)addRightItem: (CresNavigationViewItem*)item
              target: (id)target
         andSelector: (SEL)selector;
{
    assert([item isKindOfClass: [CresNavigationViewItem class]]);
    NSArray* lItems = mRightItemsBaseView.subviews;
    //TODO: Now only Two Left items Are allowed
    assert(lItems.count < 2);
    [self addRightItemAtIndex: lItems.count item: item];
}

- (void)addRightItemAtIndex: (NSInteger)index
                  withImage: (UIImage*)image
                     target: (id)target
                andSelector: (SEL)selector
{
    CresNavigationViewItem* lItem = [CresNavigationViewItem buttonWithType: UIButtonTypeCustom];
    [lItem addTarget: target action: selector forControlEvents: UIControlEventTouchUpInside];
    [lItem setImage: image forState: UIControlStateNormal];
    lItem.contentMode = UIViewContentModeScaleAspectFit;
    [self addRightItemAtIndex: index item: lItem];
}
- (void)addRightItemAtIndex: (NSInteger)index
                  withImage: (UIImage*)image
                   withText: (NSString*)text
                     target: (id)target
                andSelector: (SEL)selector
{
    CresNavigationViewItem* lItem = [CresNavigationViewItem buttonWithType: UIButtonTypeCustom];
    [lItem addTarget: target action: selector forControlEvents: UIControlEventTouchUpInside];
    [lItem setTitle:text forState:UIControlStateNormal];
    lItem.titleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:14];
    lItem.titleLabel.adjustsFontSizeToFitWidth = YES;
    lItem.titleLabel.textColor = [UIColor whiteColor];
    [lItem setBackgroundImage:image forState: UIControlStateNormal];
    lItem.contentMode = UIViewContentModeScaleAspectFit;
    [self addRightItemAtIndex: index item: lItem];
}

- (void)refreshCresNavigationBar
{
    mTitleLbl.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:16];

    mTitleLbl.textColor = [UIColor whiteColor];
   // mTitleLbl.text = @"Title";
    self.backgroundColor = [UIColor redColor];
}

- (void)setTitle: (NSString*)titleString
{
    mTitleLbl.text = titleString;
}

@end
