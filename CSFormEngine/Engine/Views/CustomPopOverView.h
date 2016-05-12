//
//  CustomPopOverView.h
//  Edumation
//
//  Created by Ankit Gupta on 17/11/15.
//  Copyright © 2015 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTipWidth       20
#define kTipHeight      10


typedef enum {
    CustomPopoverArrowDirectionUp,
    CustomPopoverArrowDirectionDown,
    CustomPopoverArrowDirectionLeft,
    CustomPopoverArrowDirectionRight
    }
CustomPopoverArrowDirection;

@class CustomPopOverView;
@protocol CustomPopOverViewDelegate <NSObject>

- (void)customPopoverDidFinish: (CustomPopOverView*)customPopOverView;

@end


@interface CustomPopOverView : UIView<UIGestureRecognizerDelegate>{
    CGRect atRect;
    
    CGPoint mTipPoint;
}


- (id)initPopoverFromRect:(CGRect)rect
                   inView:(UIView *)view
                 withSize: (CGSize)popOverSize
          arrowDirections:(CustomPopoverArrowDirection)arrowDirections;


@property (assign) CustomPopoverArrowDirection arrowDirection;
@property (nonatomic, weak) NSObject<CustomPopOverViewDelegate> *delegate;




@end
