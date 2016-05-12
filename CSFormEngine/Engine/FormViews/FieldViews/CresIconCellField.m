//
//  CresIconCellField.m
//  Edumation
//
//  Created by Deepak on 19/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CresIconCellField.h"
#import "UIImageView+WebCache.h"

@implementation CresIconCellField

@synthesize iconView = mIconView;
@synthesize descLabel = mDescLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect lSelfRect = self.bounds;
        CGRect lIconRect = CGRectZero;
        self.backgroundColor = [UIColor whiteColor];
        
        lIconRect.origin.x = 5.0;
        lIconRect.origin.y = (CGRectGetHeight(lSelfRect) - 40.0)/2;
        lIconRect.size.width = lIconRect.size.height = 40.0;
        mIconView = [[UIImageView alloc] initWithFrame: lIconRect];
        mIconView.layer.cornerRadius = (lIconRect.size.height/2);
        mIconView.layer.masksToBounds = YES;
        [self addSubview: mIconView];
        
        CGRect lDescRect = self.bounds;
        lDescRect.origin.x = CGRectGetMaxX(lIconRect) + 10.0;
        lDescRect.size.width = CGRectGetWidth(lSelfRect) - CGRectGetMinX(lDescRect);
        lDescRect.size.height = CGRectGetHeight(lSelfRect) - 5.0;
        lIconRect.origin.y = (CGRectGetHeight(lSelfRect) - CGRectGetHeight(lDescRect))/2;
        
        mDescLabel = [[UILabel alloc] initWithFrame: lDescRect];
        mDescLabel.backgroundColor = [UIColor clearColor];
        [self addSubview: mDescLabel];
        
        self.backgroundColor = [UIColor colorWithRed: 244.0/255.0 green: 244.0/255.0 blue: 244.0/255.0 alpha: 1.0];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect: rect];
    
    CGContextRef lContext = UIGraphicsGetCurrentContext();
    UIColor* lColor = [UIColor colorWithRed: 214.0/255.0 green: 214.0/255.0 blue: 214.0/255.0 alpha: 1.0];
    CGContextSetStrokeColorWithColor(lContext, lColor.CGColor);
    CGContextSetLineWidth(lContext, 1.0);
    
    CGContextMoveToPoint(lContext, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(lContext, CGRectGetWidth(rect), rect.origin.y);
    
    CGContextMoveToPoint(lContext, rect.origin.x, CGRectGetHeight(rect));
    CGContextAddLineToPoint(lContext, CGRectGetWidth(rect), CGRectGetHeight(rect));
    
    CGContextStrokePath(lContext);
}

- (void)setImageFromSource: (NSString*)imageSrc
{
    NSString* lUrlStr = [imageSrc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* lUrl = [NSURL URLWithString: lUrlStr];
    
    [mIconView sd_setImageWithURL:lUrl placeholderImage:[UIImage imageNamed:@"loading_ds.png"] completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error)
         {
             mIconView.image=[UIImage imageNamed:@"profile_not_available.png"];
         }
     }];
}

@end
