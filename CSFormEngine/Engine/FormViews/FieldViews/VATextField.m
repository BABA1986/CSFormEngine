
//
//  CSTextField.m
//  CSTextField
//
//  Created by Vidhi on 25/01/16.
//  Copyright © 2016 Vidhi. All rights reserved.
//

#import "VATextField.h"
#import "CustomPopOverView.h"

#define mcsIconViewHeight           30
#define mcsIconViewWidth            30
#define iconViewX                   30
#define iconViewY                   15
#define frameViewX                   2
#define mFrameViewX                 10
#define detailLabelHeightInTable    0.2
#define detailLabelHeightInDefault  0.4
#define imageWidth                  30
#define imageHeight                 30


@implementation VATextField
@synthesize titleLabelToDisplay            = titleLabel;
@synthesize detailedtitleLabelToDisplay    = detailedtitleLabel;
@synthesize textFieldToDisplay             = textField;
@synthesize iconViewToDisplay              = iconView;
@synthesize cSTextFieldStyle               = mCSTextFieldStyle;
@synthesize didIconToDispaly               = didIconViewToDispaly;
@synthesize didDetailTitleLabelToDisplay   = didDetailLabelToDispaly;
@synthesize borderLineOnTop                = mBorderLineOnTop;
@synthesize borderLineOnBottom             = mBorderLineOnBottom;
@synthesize img                            = mImg;
@synthesize cSTextFieldButtonStyle         =mCSTextFieldButtonStyle;
@synthesize hintButtonText                 = mHintButtonText;

-(void)awakeFromNib
{
    [self initialiseText];
    [self addSubview:textField];
    [self addSubview:titleLabel];
    [self addSubview:iconView];
    [self addSubview:mImg];
    [self addSubview:detailedtitleLabel];
    [self addSubview:mBorderLineOnTop];
    [self addSubview:mBorderLineOnBottom];
    
    [self iconViewFrameOnDisplay];
    [self detailLabelFrameOnDispaly];
    [self layoutTextField];
}

//Method to initialise frame and them on view
-(instancetype)initWithFrame:(CGRect)frame
{
    didIconViewToDispaly = false;
    didDetailLabelToDispaly = false;
    
    self = [super initWithFrame:frame];
    if(self)
    {
        UITapGestureRecognizer* lGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOnOption:)];
        [self addGestureRecognizer: lGestureRecognizer];

        [self initialiseText];
        [self addSubview:textField];
        [self addSubview:titleLabel];
        [self addSubview:iconView];
        [self addSubview:mImg];
        [self addSubview:detailedtitleLabel];
        [self addSubview:mBorderLineOnTop];
        [self addSubview:mBorderLineOnBottom];
        
        [self iconViewFrameOnDisplay];
        [self detailLabelFrameOnDispaly];
        [self layoutTextField];
    }
    return self;
}

//Method to initialise frame and layout style of view
- (instancetype)initWithFrame:(CGRect)frame andStyle:(CSTextFieldStyle)cSTextFieldStyle
{
    didIconViewToDispaly = false;
    didDetailLabelToDispaly = false;
    self = [super initWithFrame:frame];
    mCSTextFieldStyle = cSTextFieldStyle;
    
    if(self)
    {
        UITapGestureRecognizer* lGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOnOption:)];
        [self addGestureRecognizer: lGestureRecognizer];

        [self initialiseText];
        [self addSubview:textField];
        [self addSubview:titleLabel];
        [self addSubview:iconView];
        [self addSubview:mImg];
        [self addSubview:detailedtitleLabel];
        [self addSubview:mBorderLineOnTop];
        [self addSubview:mBorderLineOnBottom];
        
        [self iconViewFrameOnDisplay];
        [self detailLabelFrameOnDispaly];
        [self layoutTextField];
    }
    return self;
}

-(void)initialiseText
{
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:15];
    titleLabel.tag = 100;
    titleLabel.numberOfLines = 0;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 10/titleLabel.font.pointSize;
    
    textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:15];
    textField.tag = 101;
    textField.placeholder = @"Enter Text";
    
    detailedtitleLabel = [[UILabel alloc]init];
    detailedtitleLabel.font = [UIFont fontWithName:@"AGLettericaCondensed-Roman" size:10];
    detailedtitleLabel.numberOfLines = 0;
    detailedtitleLabel.adjustsFontSizeToFitWidth = YES;
    detailedtitleLabel.minimumScaleFactor = 8/detailedtitleLabel.font.pointSize;
    detailedtitleLabel.tag = 103;
    
    iconView = [[UIButton alloc]init];
    iconView.tag = 102;
    [iconView addTarget:self action:@selector(actionOnButtonClickOnView:) forControlEvents:UIControlEventTouchUpInside];
    
    mImg = [[UIImageView alloc]init];
    mImg.tag = 104;
    
    mBorderLineOnTop = [[UIView alloc]init];
    mBorderLineOnTop.backgroundColor = [UIColor colorWithRed: 214.0/255.0 green: 214.0/255.0 blue: 214.0/255.0 alpha: 1.0];
    mBorderLineOnTop.tag = 105;
    
    mBorderLineOnBottom = [[UIView alloc]init];
    mBorderLineOnBottom.backgroundColor = [UIColor colorWithRed: 214.0/255.0 green: 214.0/255.0 blue: 214.0/255.0 alpha: 1.0];
    mBorderLineOnBottom.tag = 106;
}

-(void)iconViewFrameOnDisplay
{
    if(didIconViewToDispaly == false)
    {
        iconView.frame = CGRectMake(0, 0, 0, 0);
    }
    
    else if(mCSTextFieldButtonStyle ==  UITextFieldNormalButton)
    {
        iconView.frame = CGRectMake(self.bounds.origin.x + self.frame.size.width - iconViewX, self.bounds.origin.y +self.frame.size.height/frameViewX - iconViewY, mcsIconViewWidth, mcsIconViewHeight);
    }
    
    else if(mCSTextFieldButtonStyle == UITextFieldHintButton)
    {
        iconView.frame = CGRectMake(self.bounds.size.width - 40, self.frame.size.height/frameViewX - iconViewY, mcsIconViewWidth, mcsIconViewHeight);
        [iconView addTarget:self action:@selector(hintIconClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)detailLabelFrameOnDispaly
{
    CGFloat lIconViewFrame = didIconViewToDispaly? 30 : 0;
    if(didDetailLabelToDispaly == false)
    {
        detailedtitleLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    else
    {
        if(mCSTextFieldStyle == UITextStyleTable)
        {
            detailedtitleLabel.frame = CGRectMake(self.bounds.origin.x + mFrameViewX, self.bounds.origin.y + self.frame.size.height * 0.8, self.frame.size.width - lIconViewFrame - mFrameViewX, self.frame.size.height * detailLabelHeightInTable);
        }
        
        else if (mCSTextFieldStyle == UITextStyleDefault || mCSTextFieldStyle == UITextStyleDetailed)
        {
            detailedtitleLabel.frame = CGRectMake(self.bounds.origin.x + mFrameViewX,  self.bounds.origin.y + self.frame.size.height * 0.6, self.frame.size.width - lIconViewFrame - mFrameViewX, self.frame.size.height * detailLabelHeightInDefault);
        }
    }
}

//Method to set frame size
- (void)layoutTextField
{
    textField.delegate = self;
    CGFloat lIconViewFrame = didIconViewToDispaly? ((mCSTextFieldButtonStyle == UITextFieldNormalButton) ? 30 : 35) : 0;
    if(mCSTextFieldStyle == UITextStyleSystem)
    {
        [[self viewWithTag:103]removeFromSuperview];
        titleLabel.frame = CGRectMake(self.bounds.origin.x + mFrameViewX ,self.bounds.origin.y, self.frame.size.width - lIconViewFrame - mFrameViewX, self.frame.size.height/frameViewX);
        
        textField.frame = CGRectMake(self.bounds.origin.x + mFrameViewX, self.bounds.origin.y + self.frame.size.height/frameViewX , self.frame.size.width - lIconViewFrame - mFrameViewX, self.frame.size.height/frameViewX);
    }
    
    else if (mCSTextFieldStyle == UITextStyleTable)
    {
        CGFloat ltextFrame = didDetailLabelToDispaly ? 0.4 : 0.5;
        titleLabel.frame = CGRectMake(self.bounds.origin.x + mFrameViewX, self.bounds.origin.y , self.frame.size.width - lIconViewFrame - mFrameViewX, self.frame.size.height * ltextFrame);
        textField.frame = CGRectMake(self.bounds.origin.x + mFrameViewX, self.bounds.origin.y + titleLabel.frame.size.height ,self.frame.size.width - lIconViewFrame - mFrameViewX, self.frame.size.height * ltextFrame);
    }
    
    else if (mCSTextFieldStyle == UITextStyleDefault || mCSTextFieldStyle == UITextStyleDetailed)
    {
        CGFloat ltextFrame = didDetailLabelToDispaly? 0.6 : 1.0;
        titleLabel.frame = CGRectMake(self.bounds.origin.x + mFrameViewX, self.bounds.origin.y, 100, self.frame.size.height * ltextFrame);
        
        textField.frame = CGRectMake(titleLabel.frame.size.width + titleLabel.frame.origin.x , self.bounds.origin.y,(self.frame.size.width - lIconViewFrame - mFrameViewX - titleLabel.bounds.origin.x - titleLabel.bounds.size.width) , self.frame.size.height * ltextFrame);
    }
    
    else if (mCSTextFieldStyle == UITextStyleImageWithText)
    {
        mImg.frame = CGRectMake(self.bounds.origin.x + mFrameViewX, self.bounds.origin.y + self.frame.size.height/frameViewX - 15, imageWidth, imageHeight);
        titleLabel.frame = CGRectMake(mImg.frame.origin.x + mImg.frame.size.width + frameViewX + iconViewY, self.bounds.origin.y, self.frame.size.width - lIconViewFrame - mFrameViewX - iconViewY - mImg.frame.size.width, self.frame.size.height);
    }
    
    mBorderLineOnTop.frame = CGRectMake(0,0, self.frame.size.width, 1);
    mBorderLineOnBottom.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 1);
}

//Method to set frame of view
- (void)setFrame:(CGRect)frame
{
    [super setFrame: frame];
    [self iconViewFrameOnDisplay];
    [self detailLabelFrameOnDispaly];
    [self layoutTextField];
}

//Method to set layout style of view
- (void)setCSTextFieldStyle:(CSTextFieldStyle)cSTextFieldStyle
{
    mCSTextFieldStyle = cSTextFieldStyle;
    [self layoutTextField];
}

-(void)setCSTextFieldButtonStyle:(CSTextFieldButtonStyle)cSTextFieldButtonStyle
{
    mCSTextFieldButtonStyle = cSTextFieldButtonStyle;
    didIconViewToDispaly = YES;
    [iconView setImage:nil forState:UIControlStateNormal];
    [self iconViewFrameOnDisplay];
    [self layoutTextField];
}

-(void)setDidIconToDispaly:(BOOL)didIconToDispaly
{
    didIconViewToDispaly = didIconToDispaly;
    [self iconViewFrameOnDisplay];
    [self layoutTextField];
}

-(void)setDidDetailTitleLabelToDisplay:(BOOL)didDetailTitleLabelToDisplay
{
    didDetailLabelToDispaly = didDetailTitleLabelToDisplay;
    [self detailLabelFrameOnDispaly];
    [self layoutTextField];
}

- (void)hintIconClicked: (id)sender
{
    UIApplication* lApplication = [UIApplication sharedApplication];
    UIWindow* lWindow = lApplication.delegate.window;
    CGRect lHintBtnRectInSelf = [self convertRect: iconView.frame toView: lWindow.rootViewController.view];
    
    CGFloat lLabelMargin = 10.0;
    CGFloat lLableWidth = 180.0;
    
    NSDictionary* lAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 12.0]};
    CGRect lRect = [mHintButtonText boundingRectWithSize:CGSizeMake(lLableWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:lAttributes context:nil];
    CustomPopOverView* lPopOver = [[CustomPopOverView alloc] initPopoverFromRect:  lHintBtnRectInSelf inView: lWindow.rootViewController.view withSize: CGSizeMake(lRect.size.width,  lRect.size.height + kTipHeight + 2*lLabelMargin) arrowDirections: CustomPopoverArrowDirectionDown];
    
    lRect.origin.y += lLabelMargin;
    
    UILabel* lHintLabel = [[UILabel alloc] initWithFrame: lRect];
    lHintLabel.text = mHintButtonText;
    lHintLabel.font = [UIFont systemFontOfSize: 12.0];
    lHintLabel.textAlignment = NSTextAlignmentCenter;
    lHintLabel.numberOfLines = 0;
    lHintLabel.textColor = [UIColor whiteColor];
    lHintLabel.backgroundColor = [UIColor clearColor];
    [lPopOver addSubview: lHintLabel];
}

//Method to define action on button
-(void)actionOnButtonClickOnView:(VATextField*)CSView
{
    if([self.delegate respondsToSelector:@selector(didSelectedHintIconOn:)])
    {
        [self.delegate didSelectedIconOn:CSView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self iconViewFrameOnDisplay];
    [self detailLabelFrameOnDispaly];
    [self layoutTextField];
}

-(void)updateConstraints
{
    [super updateConstraints];
    [self iconViewFrameOnDisplay];
    [self detailLabelFrameOnDispaly];
    [self layoutTextField];
}

- (void)tapOnOption: (id)sender
{
    [self.textFieldToDisplay becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector: @selector(csTextFieldShouldBeginEditing:)])
    {
        [self.delegate csTextFieldShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.delegate respondsToSelector: @selector(csTextFieldShouldReturn:)])
    {
        [self.delegate csTextFieldShouldReturn:self];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector: @selector(csTextFieldShouldEndEditing:)])
    {
        [self.delegate csTextFieldShouldEndEditing:self];
    }
    return true;
}
@end