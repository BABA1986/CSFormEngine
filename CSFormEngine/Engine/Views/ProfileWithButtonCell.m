//
//  ProfileWithButtonCell.m
//  Edumation
//
//  Created by Ankit Gupta on 15/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "ProfileWithButtonCell.h"

@implementation ProfileWithButtonCell

- (void)awakeFromNib
{
    // Initialization code
    [self.profileSelectBtn setImage: [UIImage imageNamed: @"check_state_default.png"] forState: UIControlStateNormal];
    [self.profileSelectBtn setImage: [UIImage imageNamed: @"check_state_allselected.png"] forState: UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)profileSelect:(id)sender
{
    [self.delegate didSelectOnProfileWithButtonCell:self];
}
@end
