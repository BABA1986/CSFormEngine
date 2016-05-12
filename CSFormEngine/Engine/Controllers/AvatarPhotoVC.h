//
//  AvatarPhotoVC.h
//  PhotoSelectionTool
//
//  Created by Firoz Khan on 31/01/16.
//  Copyright (c) 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarCustomCell.h"
#import "CresBaseViewController.h"


@class AvatarPhotoVC;
@protocol AvatarPhotoVCDelegate <NSObject>

- (void)avtarImagePickerController:(AvatarPhotoVC *)AvtarPicker didFinishPickinginfo:(UIImage *)pic;

- (void)avtarImagePickerControllerDidCancel:(AvatarPhotoVC *)controller;
@end

@interface AvatarPhotoVC : CresBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    IBOutlet UIButton                       *confirmButton;
    __weak id<AvatarPhotoVCDelegate>        mDelegate;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id<AvatarPhotoVCDelegate> delegate;
@property (nonatomic,strong) UIImage *selectedImage;
- (IBAction)ConfirmAvatar:(id)sender;


@end
