//
//  PopOverController.m
//  PhotoSelectionTool
//
//  Created by Firoz Khan on 27/01/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "CSActionSheetCtr.h"

@implementation ActionSheetButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 10.0;
}

@end

@interface CSActionSheetCtr ()
@end

@implementation CSActionSheetCtr
@synthesize delegate = mDelegate;

- (void)viewDidLoad
{
        [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleTaps:)];
        tapGestureRecognizer.numberOfTouchesRequired = 1;
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

//----Remove Action sheet tapping on view
-(void)handleTaps: (UITapGestureRecognizer*)sender
{
    if (mDelegate && [mDelegate respondsToSelector: @selector(cSActionSheetCtr:clickedButtonAtIndex:)])
    {
        [mDelegate cSActionSheetCtr: self clickedButtonAtIndex: 3];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender
{
    if (mDelegate && [mDelegate respondsToSelector: @selector(cSActionSheetCtr:clickedButtonAtIndex:)])
    {
        [mDelegate cSActionSheetCtr: self clickedButtonAtIndex: 3];
    }
}

- (IBAction)Avatar:(id)sender {
    [mDelegate cSActionSheetCtr: self clickedButtonAtIndex: 0];
}

- (IBAction)takePhoto:(id)sender {
    [mDelegate cSActionSheetCtr: self clickedButtonAtIndex: 1];
}

- (IBAction)ChooseExisting:(id)sender {
    [mDelegate cSActionSheetCtr: self clickedButtonAtIndex: 2];
}

-(void)actionSheet:(CSActionSheetCtr *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [actionSheet.view removeFromSuperview];
}

@end
