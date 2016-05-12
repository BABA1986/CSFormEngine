//
//  CresBaseViewController.m
//  Edumation
//
//  Created by Deepak Kumar on 10/12/15.
//  Copyright © 2015 Correlation. All rights reserved.
//

#import "CresBaseViewController.h"

@interface CresBaseViewController ()
@end

@implementation CresBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden: YES animated: YES];
    [self initialiseNavBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO: Plan to introduce default navigation bar instead of UIView
- (void)initialiseNavBar
{
    mNavigationView = [[CresNavigationView alloc] init];
    [self.view addSubview: mNavigationView];
    [mNavigationView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [mNavigationView refreshCresNavigationBar];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:mNavigationView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:mNavigationView
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeLeading
                                                          multiplier:1.0
                                                            constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mNavigationView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:64]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mNavigationView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
}

- (void)setCresNavViewHidden: (BOOL)shouldHidden
{
    
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
