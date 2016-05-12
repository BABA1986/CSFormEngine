//
//  ViewController.m
//  CSFormEngine
//
//  Created by Deepak on 19/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "ViewController.h"
#import "CSFormViewController.h"
#import "FormDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CSForms";
    
    mFormListView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark-
#pragma mark- UITableViewDelegate & UITableViewDataSource
#pragma mark-

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FormDataManager* lFormDataManager = [FormDataManager manager];
    
    return [lFormDataManager.forms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* lCellIdentifier = @"FormListCell";
    
    UITableViewCell* lCell = [tableView dequeueReusableCellWithIdentifier:lCellIdentifier];
    if (lCell == nil)
    {
        lCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: lCellIdentifier];
    }
    
    // Configure the cell...
    FormDataManager* lFormDataManager = [FormDataManager manager];
    CresFormData* lFormData = [lFormDataManager.forms objectAtIndex: indexPath.row];
    lCell.textLabel.text = lFormData.formName;
    lCell.detailTextLabel.text = lFormData.formName;
    
    return lCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSFormViewController* lCSFormViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"CSFormViewController"];
    FormDataManager* lFormDataManager = [FormDataManager manager];
    CresFormData* lFormData = [lFormDataManager.forms objectAtIndex: indexPath.row];
    lCSFormViewController.formData = lFormData;
    [self.navigationController pushViewController: lCSFormViewController animated: YES];
}

@end
