//
//  CresSeperatorView.m
//  Edumation
//
//  Created by Deepak on 03/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CresSeperatorView.h"

#define kLineHeigh  1.0
#define kFontSize   12.0

@implementation CresSeperatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect: rect];
    
    CGContextRef lContext = UIGraphicsGetCurrentContext();
    UIColor* lColor = [UIColor colorWithRed: 214.0/255.0 green: 214.0/255.0 blue: 214.0/255.0 alpha: 1.0];
    CGContextSetStrokeColorWithColor(lContext, lColor.CGColor);
    CGContextSetFillColorWithColor(lContext, lColor.CGColor);
    CGContextSetLineWidth(lContext, kLineHeigh);

    CGPoint lPLineStart = CGPointZero;
    lPLineStart.x = CGRectGetMinX(rect);
    lPLineStart.y = CGRectGetMidY(rect);
    
    CGPoint lPLineEnd = CGPointZero;
    lPLineEnd.x = CGRectGetMaxX(rect);
    lPLineEnd.y = CGRectGetMidY(rect);
    
    CGContextMoveToPoint(lContext, lPLineStart.x, lPLineStart.y);
    CGContextAddLineToPoint(lContext, lPLineEnd.x, lPLineEnd.y);
    CGContextStrokePath(lContext);
    
    CGContextAddArc(lContext,CGRectGetMidX(rect),CGRectGetMidY(rect),CGRectGetHeight(rect)/2,0.0,M_PI*2,YES);
    CGContextFillPath(lContext);

    
    CGFloat lDiameter = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect));
    CGPoint lTopLeft = CGPointZero;
    lTopLeft.x = CGRectGetMidX(rect) + 0.5*lDiameter*cos(3*M_PI/4);
    lTopLeft.y = CGRectGetMidY(rect) + 0.5*lDiameter*sin(3*M_PI/4);
    
    CGPoint lBottomRight = CGPointZero;
    lBottomRight.x = CGRectGetMidX(rect) + 0.5*lDiameter*cos(7*M_PI/4);
    lBottomRight.y = CGRectGetMidY(rect) + 0.5*lDiameter*sin(7*M_PI/4);
    
    CGFloat lSideLength = lBottomRight.x - lTopLeft.x;
    CGRect lAvailableRectInCircle = CGRectZero;
    lAvailableRectInCircle.origin.x = lTopLeft.x;
    lAvailableRectInCircle.origin.y = CGRectGetHeight(rect) - lTopLeft.y;
    lAvailableRectInCircle.size.width = lSideLength;
    lAvailableRectInCircle.size.height = lSideLength;

    NSString* lStr = @"Or";
    NSMutableParagraphStyle* lStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    lStyle.alignment = NSTextAlignmentCenter;

    UIFont* lFont = [UIFont systemFontOfSize: kFontSize];
    NSDictionary* lAttributes = @{NSFontAttributeName: lFont, NSParagraphStyleAttributeName : lStyle};
    CGSize lSize = [lStr sizeWithAttributes: lAttributes];

    lAvailableRectInCircle.origin.y = (rect.size.height - lSize.height)/2;
    lAvailableRectInCircle.size.height = lSize.height;
    
    [lStr drawInRect: lAvailableRectInCircle withAttributes: lAttributes];
}

@end
