//
//  ProfileImageAreaView.m
//  Edumation
//
//  Created by Firoz Khan on 04/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "ProfileImageAreaView.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kImageXoffSet     10
#define kButtonXorigin    10
#define kButtonHeight     40
#define kLabelHeight      50
#define kLabelXorigin     20

@implementation ProfileImageAreaView
{
    BOOL tappedOnProfileImage;
}

@synthesize editButtonToDisplay;
@synthesize delegate = mDelegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initialiseLabelImageViewAndButton];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutView];
}

-(instancetype)initWithFrame:(CGRect)frame
{
      self = [super initWithFrame:frame];
      if(self)
      {
          [self initialiseLabelImageViewAndButton];
          self.backgroundColor = [UIColor clearColor];
      }
      return self;
}

-(void)initialiseLabelImageViewAndButton
{
    // Profile Image View
    self.profileImageView = [[UIImageView alloc]init];
    self.profileImageView.image = [UIImage imageNamed: @"DefaultProfile.png"];
    self.profileImageView.userInteractionEnabled = TRUE;
    
    // Text Label
    self.textLabel = [[UILabel alloc]init];
    [self.textLabel setFont:[UIFont fontWithName:@"AGLettericaCondensed-Roman" size:15]];
    self.textLabel.text = @"Add you picture so that everyone can find recognize you quickly";
    self.textLabel.numberOfLines= 0.0;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    [self.textLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    
    // Text Button for Edit Screen
    self.textButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.textButton setTitle:@"Edit Profile Picture" forState:UIControlStateNormal];
    self.textButton.titleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:15];
    [self.textButton setTitleColor:[UIColor colorWithRed:98.0/255.0 green:175.0/255.0 blue:211.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[self.textButton layer] setBorderWidth:2.0f];
    [self.textButton.layer setBorderColor:[[UIColor colorWithRed:98.0/255.0 green:175.0/255.0 blue:211.0/255.0 alpha:1.0] CGColor]];
    [self.textButton addTarget: self action: @selector(editButtonDisplay:) forControlEvents: UIControlEventTouchUpInside];
    
    [self addSubview:self.profileImageView];
    [self addSubview:self.textButton];
    [self addSubview:self.textLabel];
    
    UITapGestureRecognizer* lGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOnProfileImage:)];
    [self.profileImageView addGestureRecognizer: lGesture];
}

- (void)layoutView
{
    //Profile Image View Frame
    CGRect lProfileImgRect = self.bounds;
    lProfileImgRect.origin.x = kImageXoffSet;
    lProfileImgRect.size.height = 0.75*CGRectGetHeight(lProfileImgRect);
    lProfileImgRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(lProfileImgRect))/2;
    lProfileImgRect.size.width = lProfileImgRect.size.height;
    
    self.profileImageView.frame = lProfileImgRect;
    self.profileImageView.layer.cornerRadius= self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds=YES;
    
    if(editButtonToDisplay==TRUE)
    {
      //  Button for Edit Screen
        CGRect lRect = self.bounds;
        lRect.origin.x = CGRectGetMaxX(self.profileImageView.frame) + kButtonXorigin;
        lRect.origin.y = (self.frame.size.height - kButtonHeight)/2;
        lRect.size.width = self.frame.size.width - self.profileImageView.frame.size.width-kImageXoffSet -kButtonXorigin-10;
        lRect.size.height = kButtonHeight;
        self.textButton.frame = lRect;
    }
    else
    {
      // Label Text
        CGRect lRect = self.bounds;
        lRect.origin.x = self.profileImageView.frame.size.width+kLabelXorigin;
        lRect.origin.y =self.frame.size.height/2-kLabelHeight/2;
        lRect.size.width =self.frame.size.width-self.profileImageView.frame.size.width-kLabelXorigin-10;
        lRect.size.height = kLabelHeight;
        self.textLabel.frame = lRect;
    }
}

- (void)editButtonDisplay: (id)sender
{
    if (editButtonToDisplay)
    {
     
    }
    if ([mDelegate respondsToSelector: @selector(willSelectImageInProfileImageAreaView:)])
    {
        // keyboard hide click on Edit Button
        [mDelegate willSelectImageInProfileImageAreaView: self];
    }
    tappedOnProfileImage = FALSE;
    [self openImagePickerController: sender];
}

- (void)tapOnProfileImage: (id)sender
{
    if (editButtonToDisplay)
    {
        
    }
    if ([mDelegate respondsToSelector: @selector(willSelectImageInProfileImageAreaView:)])
    {
        // keyboard hide click on profile image
        [mDelegate willSelectImageInProfileImageAreaView: self];
    }
    
    tappedOnProfileImage = TRUE;
    UITapGestureRecognizer* lGesture = (UITapGestureRecognizer*)sender;
    UIView* lView = (UIView*)lGesture.view;
    [self openImagePickerController: lView];
}

- (void)resignAllWindowStuff
{
    [mNavCtr removeFromParentViewController];
    [mNavCtr.view removeFromSuperview];
    [mCtr removeFromParentViewController];
    [mCtr.view removeFromSuperview];

    [mWindow resignKeyWindow];
    mWindow = nil;
    
    if ([mDelegate respondsToSelector: @selector(didSelectImageInProfileImageAreaView:)])
    {
        [mDelegate didSelectImageInProfileImageAreaView: self];
    }
}

- (void)openImagePickerController: (id)sender
{
    mMediaPicker = [[UIImagePickerController alloc] init];
    mWindow = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    mWindow.backgroundColor = [UIColor clearColor] ;
    mWindow.windowLevel = UIWindowLevelNormal;

    UIViewController* lCtr = [[UIViewController alloc] init];
    
    mNavCtr = [[UINavigationController alloc] initWithRootViewController: lCtr];
    mNavCtr.navigationBarHidden = TRUE;
    
    mCtr = [[UIViewController alloc] init];
    mCtr.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    [mWindow setRootViewController: mCtr];
    [mWindow makeKeyAndVisible];
    
    [mCtr addChildViewController: mNavCtr];
    [mCtr.view addSubview: mNavCtr.view];
    
    CSActionSheetCtr* lActionSheetCtr = [[CSActionSheetCtr alloc] initWithNibName: @"CSActionSheetCtr" bundle: nil];
    lActionSheetCtr.delegate = self;

    if (IS_IPAD)
    {
        // iPad-specific interface here
        CGRect lRect = CGRectMake(262, 50, 500, 650);
        mNavCtr.view.frame = lRect;
        if (mPopovercontrol) {
            [mPopovercontrol dismissPopoverAnimated:TRUE];
        }
     
        mPopovercontrol = [[UIPopoverController alloc]initWithContentViewController:lActionSheetCtr];
        mPopovercontrol.backgroundColor = [UIColor lightGrayColor];
        mPopovercontrol.popoverContentSize = CGSizeMake(300, 220);
        mPopovercontrol.delegate = self;
        
        // PopOver Arrow Direction Up for Edit Button & Left for profile Image
        UIPopoverArrowDirection arrowDir = tappedOnProfileImage ? UIPopoverArrowDirectionLeft:UIPopoverArrowDirectionUp;
        
        // Getting rect of Profile & edit button
        CGRect lrect = [self getPopOverPositionRect];
        
        [mPopovercontrol presentPopoverFromRect: lrect
                                        inView:mWindow.rootViewController.view
                      permittedArrowDirections:arrowDir
                                      animated:YES];
    }
    else
    {
        CGRect lRect = lCtr.view.bounds;
        lRect.origin.y += CGRectGetHeight(lRect);
        
        lActionSheetCtr.view.frame = lRect;
        [mNavCtr addChildViewController: lActionSheetCtr];
        [mNavCtr.view addSubview: lActionSheetCtr.view];

        CGRect lAnimateToRect = lCtr.view.bounds;
        CGFloat lDuration = 0.5;
        [UIView animateWithDuration: lDuration
                              delay: 0.0
             usingSpringWithDamping: 0.8
              initialSpringVelocity: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^(){lActionSheetCtr.view.frame = lAnimateToRect;}
                         completion:^(BOOL finished){
                         }];        
    }
}

// Getting the rect of profile image or Edit Button for PopOver iPad Only
-(CGRect)getPopOverPositionRect
{
    UIView* lSenderView = tappedOnProfileImage ? (UIView*)self.profileImageView : (UIView*)self.textButton;
    CGRect lSenderFrame = [self convertRect: lSenderView.frame toView: mWindow.rootViewController.view];
    
    CGRect lRect1 = CGRectMake(CGRectGetMaxX(lSenderFrame), CGRectGetMidY(lSenderFrame), 0, 0);
    CGRect lRect2 = CGRectMake(CGRectGetMidX(lSenderFrame), CGRectGetMaxY(lSenderFrame), 0, 0);
    CGRect lrect = tappedOnProfileImage ? lRect1: lRect2;
    return lrect;
}

- (void)openImageCropViewWithImage: (UIImage*)image
{
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage: image];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [mNavCtr pushViewController:controller animated: TRUE];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* lPickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera)
    {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self openImageCropViewWithImage: lPickedImage];
        }];
    }
    else
    {
        if(!IS_IPAD)
        {
            [picker dismissViewControllerAnimated:YES completion:^{
                [self openImageCropViewWithImage: lPickedImage];
            }];
        }
        else{
            [mPopovercontrol dismissPopoverAnimated:FALSE];
            [self openImageCropViewWithImage: lPickedImage];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
     [picker dismissViewControllerAnimated:TRUE completion:nil];
     [self resignAllWindowStuff];
}


#pragma mark-
#pragma mark- ImageCropViewControllerDelegate
#pragma mark-

- (void)ImageCropViewControllerSuccess:(ImageCropViewController* )controller didFinishCroppingImage:(UIImage *)croppedImage
{
    UIImage *lReziseImg =[self resizeImage:croppedImage];
    self.profileImageView.image = lReziseImg;
    [mNavCtr popViewControllerAnimated:TRUE];
    [self resignAllWindowStuff];
}

- (void)ImageCropViewControllerDidCancel:(UIViewController *)controller
{
    [self resignAllWindowStuff];
}

#pragma mark-
#pragma mark- CSActionSheetCtrDelegate
#pragma mark-

- (void)cSActionSheetCtr:(CSActionSheetCtr*)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [mPopovercontrol dismissPopoverAnimated: FALSE];
    if (buttonIndex == 0)
    {
        AvatarPhotoVC *avtarController = [[AvatarPhotoVC alloc]initWithNibName:@"AvatarPhotoVC" bundle:nil];
        avtarController.delegate= self;
        [mNavCtr pushViewController: avtarController animated: TRUE];
    }
    else if (buttonIndex==1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            mMediaPicker.sourceType=UIImagePickerControllerSourceTypeCamera;

            if( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront ])
            {
                mMediaPicker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
            }
            
            mMediaPicker.delegate=self;
            mMediaPicker.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [mNavCtr presentViewController:mMediaPicker animated:TRUE completion:nil];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
    else if (buttonIndex==2)
    {
        [mMediaPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        mMediaPicker.delegate=self;
        
        if(IS_IPAD){
            
            mPopovercontrol =[[UIPopoverController alloc] initWithContentViewController:mMediaPicker];
            mPopovercontrol.delegate = self;
            
            UIPopoverArrowDirection arrowDirc = tappedOnProfileImage ? UIPopoverArrowDirectionLeft:UIPopoverArrowDirectionUp;
            
            // Getting rect of profile Image & Edit Button
            CGRect lrect = [self getPopOverPositionRect];
            [mPopovercontrol presentPopoverFromRect:lrect inView:mWindow.rootViewController.view permittedArrowDirections:arrowDirc animated:TRUE];
        }
        else
        {
            [mNavCtr presentViewController:mMediaPicker animated:TRUE completion:nil];
        }
        
    }
    else if (buttonIndex == 3)
    {
        [self resignAllWindowStuff];
    }
}

-(void)actionSheet:(CSActionSheetCtr *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self resignAllWindowStuff];
}

#pragma mark-
#pragma mark- AvatarPhotoVCDelegate
#pragma mark-

- (void)avtarImagePickerController:(AvatarPhotoVC *)AvtarPicker didFinishPickinginfo:(UIImage *)pic
{
  UIImage *lReziseImg = [self resizeImage:pic];
    
    self.profileImageView.image = lReziseImg;
    [self resignAllWindowStuff];
}

-(void)avtarImagePickerControllerDidCancel:(AvatarPhotoVC *)controller
{
    [self resignAllWindowStuff];
}

// PopOver Controller Dismiss
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self resignAllWindowStuff];
}

// Profile Image Resize
-(UIImage*)resizeImage: (UIImage*)orignalImg
{
    CGFloat maxSize = 210.0;
    CGFloat width = orignalImg.size.width;
    CGFloat height = orignalImg.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;

    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = maxSize;
        } else {
            newHeight = maxSize;
            newWidth = maxSize;
        }
    }
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [orignalImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
