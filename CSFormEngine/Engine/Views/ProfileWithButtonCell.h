//
//  ProfileWithButtonCell.h
//  Edumation
//
//  Created by Ankit Gupta on 15/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileWithButtonCell;
@protocol ProfileWithButtonCellDelegate <NSObject>


-(void)didSelectOnProfileWithButtonCell:(ProfileWithButtonCell*)cell;
@optional

@end

@interface ProfileWithButtonCell : UITableViewCell
- (IBAction)profileSelect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *profileSelectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property(weak,nonatomic)id<ProfileWithButtonCellDelegate> delegate;

@end
