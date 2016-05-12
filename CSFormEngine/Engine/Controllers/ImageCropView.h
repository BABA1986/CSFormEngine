//
//  Created by Ming Yang on 7/7/12.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "CresBaseViewController.h"
#import "AppDelegate.h"

#pragma mark ControlPointView interface

typedef enum : NSUInteger {
    EControlPositionTopLeft,
    EControlPositionTopRight,
    EControlPositionBottomLeft,
    EControlPositionBottomRight
} ControlPosition;

@interface ControlPointView : UIView
{
    CGFloat red, green, blue, alpha;
}

@property (nonatomic, retain) UIColor* color;
@property (nonatomic) BOOL toolbarHidden;
@property (nonatomic)ControlPosition controlPosition;


@end

#pragma mark ShadeView interface

@interface ShadeView : UIView {
    CGFloat cropBorderRed, cropBorderGreen, cropBorderBlue, cropBorderAlpha;
    CGRect cropArea;
    CGFloat shadeAlpha;
}

@property (nonatomic, retain) UIColor* cropBorderColor;
@property (nonatomic) CGRect cropArea;
@property (nonatomic) CGFloat shadeAlpha;
@property (nonatomic, strong) UIImageView *blurredImageView;

@end

CGRect SquareCGRectAtCenter(CGFloat centerX, CGFloat centerY, CGFloat size);

//UIView* dragView;
typedef struct {
    CGPoint dragStart;
    CGPoint topLeftCenter;
    CGPoint bottomLeftCenter;
    CGPoint bottomRightCenter;
    CGPoint topRightCenter;
    CGPoint clearAreaCenter;
} DragPoint;

// Used when working with multiple dragPoints
typedef struct {
    DragPoint mainPoint;
    DragPoint optionalPoint;
    NSUInteger lastCount;
} MultiDragPoint;

#pragma mark CropAreaView interface

@interface CropAreaView : UIView {
}
@end

#pragma mark ImageCropView interface

@interface ImageCropView : UIView {
    UIImageView* imageView;
    CGRect imageFrameInView;
    CGFloat imageScale;
    
    CGFloat controlPointSize;
    ControlPointView* topLeftPoint;
    ControlPointView* bottomLeftPoint;
    ControlPointView* bottomRightPoint;
    ControlPointView* topRightPoint;
    NSArray *PointsArray;
    UIColor* controlColor;

    CropAreaView* cropAreaView;
    DragPoint dragPoint;
    MultiDragPoint multiDragPoint;
    
    UIView* dragViewOne;
    UIView* dragViewTwo;
    }

- (id)initWithFrame:(CGRect)frame blurOn:(BOOL)blurOn;
- (void)initViews;
- (void)setImage:(UIImage*)image;

@property (nonatomic) CGFloat controlPointSize;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic) CGRect cropAreaInView;
@property (nonatomic) CGRect cropAreaInImage;
@property (nonatomic, readonly) CGFloat imageScale;
@property (nonatomic) CGFloat maskAlpha;
@property (nonatomic, retain) UIColor* controlColor;
@property (nonatomic, strong) ShadeView* shadeView;
@property (nonatomic) BOOL blurred;

@end

#pragma mark ImageCropViewController interface
@protocol ImageCropViewControllerDelegate <NSObject>

- (void)ImageCropViewControllerSuccess:(UIViewController* )controller didFinishCroppingImage:(UIImage *)croppedImage;
- (void)ImageCropViewControllerDidCancel:(UIViewController *)controller;

@end

@class ImageCropView;
@interface ImageCropViewController : CresBaseViewController
{
    ImageCropView * cropView;
    IBOutlet UIView *contentView;
    IBOutlet UIButton *confrmButton;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, weak) id<ImageCropViewControllerDelegate> delegate;
@property (nonatomic) BOOL blurredBackground;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain)IBOutlet ImageCropView* cropView;

- (id)initWithImage:(UIImage*)image;

- (IBAction)confirmAction:(id)sender;

@end

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

@end

