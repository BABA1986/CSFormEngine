//
//  AvatarPhotoVC.m
//  PhotoSelectionTool
//
//  Created by Firoz Khan on 31/01/16.
//  Copyright (c) 2016 Correlation. All rights reserved.
//

#import "AvatarPhotoVC.h"
#import "AvatarCustomCell.h"
#import "AppDelegate.h"

@interface AvatarPhotoVC ()
{
    NSInteger           selectedIndex;
    
    NSArray*            mAvatarResources;
}

- (void)gerAvatarResources;

@end

@implementation AvatarPhotoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedIndex = -1;
    self.collectionView.dataSource= self;
    self.collectionView.delegate=self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"AvatarCustomCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    // confirm Button & text color Change here
    confirmButton.backgroundColor= [UIColor greenColor];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self navBarSetup];
    
//    if([NetworkManager SharedInstance].isInternetReachable)
//    {
//        [self gerAvatarResources];
//    }
//    else
//    {
//        mAvatarResources = [[DataManager SharedInstance] getResourceWithType:@"7"];
//        if(!mAvatarResources)
//        {
//            [self showNoAvatarFound];
//        }
//    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNoAvatarFound
{
    [self noAvatarImages];
    confirmButton.enabled = FALSE;
    confirmButton.backgroundColor= [UIColor lightGrayColor];
}

- (void)gerAvatarResources
{
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mAvatarResources.count;
}

- (AvatarCustomCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AvatarCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.layer.shouldRasterize=YES;
    
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2;
    cell.imageView.clipsToBounds=YES;
    
    cell.imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cell.imageView.layer.borderWidth = 0.5;

    if(indexPath.row == selectedIndex)
    {
      cell.imageView.layer.borderColor = [UIColor grayColor].CGColor;
      cell.imageView.layer.borderWidth = 2.0;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage* lImage = nil;
    self.selectedImage = lImage;
    selectedIndex = indexPath.row;
    [self.collectionView reloadData];
}

- (IBAction)ConfirmAvatar:(id)sender
{
    if(self.selectedImage != nil)
    {
        [self.delegate avtarImagePickerController:self didFinishPickinginfo:self.selectedImage];
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else
    {
        UIAlertView * alervew = [[UIAlertView alloc]initWithTitle:nil message:@"Please select your profile picture" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alervew show];
    }
}

-(void)navBarSetup
{
    [mNavigationView setTitle: @"Title"];
    
    [mNavigationView addLeftItemAtIndex: 0 withImage: nil withText:@"Back" target: self andSelector: @selector(backButtonAction)];
}

-(void)backButtonAction
{
    [self.delegate avtarImagePickerControllerDidCancel:self];
}

-(void)noAvatarImages
{
    UILabel * lMsg = [[UILabel alloc]init];
    [lMsg setTranslatesAutoresizingMaskIntoConstraints:NO];
    lMsg.text = @"Sorry there are no Images Available";
    lMsg.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:lMsg];

    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:lMsg attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual toItem:self.view
                              attribute:NSLayoutAttributeCenterX multiplier:1.0f
                              constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:lMsg attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual toItem:self.view
                              attribute:NSLayoutAttributeCenterY multiplier:1.0f
                              constant:0.0f]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
