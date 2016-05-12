//
//  CustomPopOverView.m
//  Edumation
//
//  Created by Ankit Gupta on 17/11/15.
//  Copyright © 2015 Correlation. All rights reserved.
//

#import "CustomPopOverView.h"

#define kTipWidth       20
#define kTipHeight      10


@implementation CustomPopOverView


- (id)initPopoverFromRect:(CGRect)rect
                   inView:(UIView *)view
                 withSize: (CGSize)popOverSize
          arrowDirections:(CustomPopoverArrowDirection)arrowDirections
{
    self = [super init];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
        self.arrowDirection=arrowDirections;
        [self adjustPopoverFrameFromRect: rect inView: view withSize: popOverSize arrowDirections: arrowDirections];
        [self addTransparentViewOnSuperView:view];
        
    }
    return self;
}

- (void)adjustPopoverFrameFromRect:(CGRect)rect
                            inView:(UIView *)view
                          withSize: (CGSize)popOverSize
                   arrowDirections:(CustomPopoverArrowDirection)arrowDirections
{
    CGRect lSelfRect = CGRectZero;
    if (arrowDirections == CustomPopoverArrowDirectionDown)
    {
        CGFloat lTipX = CGRectGetMinX(rect) + CGRectGetWidth(rect)/2;
        CGFloat lTipY = CGRectGetMinY(rect);
        CGPoint lTipInParent = CGPointMake(lTipX, lTipY);
        
        lSelfRect = CGRectMake(0, 0, popOverSize.width, popOverSize.height);
        lSelfRect.origin.y = lTipInParent.y - popOverSize.height;
        
        CGFloat lDeff = lTipX - popOverSize.width/2;
        CGFloat lSelfOriginX = (lDeff < 0) ? 10 : lDeff;//
        lSelfRect.origin.x = lSelfOriginX;
        
        lDeff = CGRectGetMaxX(lSelfRect) - view.frame.size.width;
        lSelfOriginX = (lDeff > 0) ? (lSelfOriginX - (lDeff+10)) : lSelfOriginX;//
        lSelfRect.origin.x = lSelfOriginX;
        
        self.frame = lSelfRect;
        mTipPoint.x = lTipInParent.x-lSelfRect.origin.x;
        mTipPoint.y = lTipInParent.y-lSelfRect.origin.y;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.arrowDirection==CustomPopoverArrowDirectionDown) {
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        
        // If you were making this as a routine, you would probably accept a rectangle
        // that defines its bounds, and a radius reflecting the "rounded-ness" of the rectangle.
        CGRect rrect = rect;
        rrect.size.height -= kTipHeight;
        
        CGFloat radius = 10.0;
        // NOTE: At this point you may want to verify that your radius is no more than half
        // the width and height of your rectangle, as this technique degenerates for those cases.
        
        // In order to draw a rounded rectangle, we will take advantage of the fact that
        // CGContextAddArcToPoint will draw straight lines past the start and end of the arc
        // in order to create the path from the current position and the destination position.
        
        // In order to create the 4 arcs correctly, we need to know the min, mid and max positions
        // on the x and y lengths of the given rectangle.
        CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
        CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
        
        CGContextMoveToPoint(context, minx, midy);
        // Add an arc through 2 to 3
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
        // Add an arc through 4 to 5
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
        // Add an arc through 6 to 7
        
        CGFloat ltipDiffFromLeft= maxx-(mTipPoint.x+kTipWidth/2);
        CGFloat lradiusLeft = (ltipDiffFromLeft < radius) ? ltipDiffFromLeft : radius;

        CGContextAddArcToPoint(context, maxx, maxy, mTipPoint.x + kTipWidth/2, maxy, lradiusLeft);
        CGContextAddLineToPoint(context, mTipPoint.x + kTipWidth/2, maxy);
        CGContextAddLineToPoint(context, mTipPoint.x, mTipPoint.y);
        CGContextAddLineToPoint(context, mTipPoint.x - kTipWidth/2, maxy);
        
        CGFloat ltipDiffFromRight= mTipPoint.x-kTipWidth/2;
        CGFloat lradiusRight = (ltipDiffFromRight < radius) ? ltipDiffFromRight : radius;
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, lradiusRight);

        // Close the path
        CGContextClosePath(context); 
        // Fill & stroke the path 
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}
-(void)addTransparentViewOnSuperView:(UIView *)view{
    UIView *transparentView=[[UIView alloc]initWithFrame:view.frame];
    transparentView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.1];
    [view addSubview:transparentView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTransparentView:)];
    tapGesture.delegate=self;
    tapGesture.numberOfTapsRequired=1;
    [transparentView addGestureRecognizer:tapGesture];

    [transparentView addSubview:self];
}

-(void)removeTransparentView:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView: recognizer.view];
    touchPoint = [recognizer.view convertPoint: touchPoint toView: self];
    
    if (CGRectContainsPoint(self.bounds, touchPoint))
        return;

    [self.delegate customPopoverDidFinish:self];
    [recognizer.view removeFromSuperview];
}


@end
