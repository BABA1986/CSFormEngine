//
//  ProfileImageAreaView.h
//  Edumation
//
//  Created by Firoz Khan on 04/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSActionSheetCtr.h"
#import "ImageCropView.h"
#import "AvatarPhotoVC.h"

@class ProfileImageAreaView;
@protocol ProfileImageAreaViewDelegate <NSObject>

- (void)willSelectImageInProfileImageAreaView:(ProfileImageAreaView*)imageAreaView;
- (void)didSelectImageInProfileImageAreaView:(ProfileImageAreaView*)imageAreaView;

@end

@interface ProfileImageAreaView : UIView <CSActionSheetCtrDelegate,UIImagePickerControllerDelegate,ImageCropViewControllerDelegate,AvatarPhotoVCDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>
{
    BOOL editButtonDisplay;
    
    UIWindow*                                          mWindow;
    UINavigationController*                            mNavCtr;
    UIImagePickerController*                           mMediaPicker;
    UIPopoverController*                               mPopovercontrol;
    UIViewController*                                  mCtr;
    __weak id<ProfileImageAreaViewDelegate>            mDelegate;
}

@property (nonatomic,weak) id<ProfileImageAreaViewDelegate> delegate;
@property (nonatomic,strong) UIImageView *profileImageView;
@property (nonatomic,strong) UIButton *textButton;
@property (nonatomic,strong) UILabel *textLabel;

@property (assign,nonatomic) BOOL editButtonToDisplay;

-(instancetype)initWithFrame:(CGRect)frame;

@end
