//
//  SelectedRoleView.m
//  Edumation
//
//  Created by Firoz Khan on 03/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "SelectedRoleView.h"

@interface SelectedRoleView (Private)

- (void)initSelectedRoleLayout;

@end

@implementation SelectedRoleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initSelectedRoleLayout];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSelectedRoleLayout];
    }
    return self;
}

- (void)initSelectedRoleLayout
{
    UILabel *lTextlbl = [[UILabel alloc]init];
    lTextlbl.tag = 100;
    lTextlbl.text = @"I'm a";
    lTextlbl.font = [UIFont fontWithName:@"AGLettericaCondensed-Bold" size:17];
    lTextlbl.textAlignment= NSTextAlignmentCenter;
    [self addSubview:lTextlbl];
    
    self.selectedRoleimageView = [[UIImageView alloc]init];
    self.selectedRoleimageView.tag = 101;
    self.selectedRoleimageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.selectedRoleimageView];
    
    self.selectedRoleLbl= [[UILabel alloc]init];
    self.selectedRoleLbl.textAlignment = NSTextAlignmentCenter;
    self.selectedRoleLbl.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:17];
    [self addSubview:self.selectedRoleLbl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UILabel* lTextlbl = (UILabel*)[self viewWithTag: 100];
    lTextlbl.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.25);
    self.selectedRoleimageView = (UIImageView*)[self viewWithTag: 101];
    self.selectedRoleimageView.frame = CGRectMake((self.frame.size.width - self.frame.size.height*0.5)/2, lTextlbl.frame.size.height, self.frame.size.height*0.5, self.frame.size.height*0.5);
    self.selectedRoleLbl.frame = CGRectMake(0,self.frame.size.height*0.75, self.frame.size.width, self.frame.size.height*0.25);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//
//{
// 
//}


@end
