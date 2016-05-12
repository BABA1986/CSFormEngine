//
//  SearchPickerCtr.m
//  Edumation
//
//  Created by Ankit Gupta on 12/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import "SearchPickerCtr.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"


@interface SearchPickerCtr ()
{
    NSMutableArray*         mProfileData;
    NSMutableArray*         mSearchedProfileData;
}

@end

@implementation SearchPickerCtr

- (instancetype)initWithLastSelected: (NSMutableArray*)lastSelected
{
    if ([super initWithNibName: @"SearchPickerCtr" bundle: nil])
    {
        mLastSelected = lastSelected;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navBar];
    self.nextBtn.backgroundColor=[UIColor greenColor];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.txtView setText:self.pickerMsg];
    self.txtView.textAlignment=NSTextAlignmentCenter;
    [self.txtView sizeToFit];
    [self.txtView layoutIfNeeded]; 
    self.profileSearch.placeholder=self.pickerPlaceholder;
    self.profileSearch.delegate = self;
    
    [self getTeacherList];
}

-(void)navBar
{
    UIImage* backImage=[UIImage imageNamed:@"navback_arrow.png"];
    [mNavigationView setTitle:@"Add Teacher"];
    [mNavigationView addLeftItemAtIndex:0 withImage:backImage withText:@"Back" target:self andSelector:
     @selector(backButtonAction:)];
}

-(void)getTeacherList
{
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    //'UISearchBar` started conforming to the `UITextInputTraits` protocol as of iOS 7.1
    if ([self.profileSearch respondsToSelector:@selector(enablesReturnKeyAutomatically)])
    {
        self.profileSearch.enablesReturnKeyAutomatically = NO;
    }
}

- (NSMutableArray*)selectedItems
{
    NSMutableArray* lSelectedItems = [[NSMutableArray alloc] init];
    for (NSDictionary* lItem in mProfileData)
    {
        if ([[lItem objectForKey: @"IsSelected"] boolValue])
        {
            [lSelectedItems addObject: lItem];
        }
    }
    return lSelectedItems;
}

- (BOOL)isLastSelected: (NSDictionary*)item
{
    BOOL lIsLastSelected = FALSE;
    for (NSDictionary* lLastSelectedItemId in mLastSelected)
    {
        NSString* lItemID = [item objectForKey: @"ID"];
        NSString* lLastItemID = [lLastSelectedItemId objectForKey: @"ID"];
        
        if ([lItemID isEqualToString: lLastItemID])
        {
            lIsLastSelected = TRUE;
            break;
        }
    }
    
    return lIsLastSelected;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backButtonAction:(id)sender
{
    [self.delegate willDissmissSearckPicker: self onClickingBtn:@"cancel" selectedItems: [self selectedItems]];
}

- (IBAction)nextBtnPressed:(id)sender
{
    [self.delegate willDissmissSearckPicker: self onClickingBtn:@"next" selectedItems: [self selectedItems]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mSearchedProfileData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";
    
    ProfileWithButtonCell *cell= (ProfileWithButtonCell*)
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileWithButtonCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;
    
    NSDictionary* lData = [mSearchedProfileData objectAtIndex:indexPath.row];
    cell.name.text = [lData valueForKey:@"DisplayName"];
    BOOL lSelected = [[lData objectForKey: @"IsSelected"] boolValue];
    cell.profileSelectBtn.selected = lSelected;
    
    NSString* url = [lData objectForKey:@"URL"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imageURL = [NSURL URLWithString:url];
    

    {
        SDImageCache *imageCache=[SDImageCache sharedImageCache];
        SDWebImageManager *imageManager=[SDWebImageManager sharedManager];
        NSString *str= [imageManager cacheKeyForURL:imageURL];
        UIImage *tempImg=[imageCache imageFromDiskCacheForKey:str];
        if(tempImg!=nil)
            cell.profileImgView.image=tempImg;
        else
            cell.profileImgView.image=[UIImage imageNamed:@"profile_not_available.png"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileWithButtonCell* lCell= (ProfileWithButtonCell*)cell;
    CGRect lCellRect = lCell.profileImgView.bounds;
    lCell.profileImgView.layer.cornerRadius = (lCellRect.size.height/2);
    lCell.profileImgView.layer.masksToBounds = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileWithButtonCell* lProfileWithButtonCell = (ProfileWithButtonCell*)[tableView cellForRowAtIndexPath: indexPath];
    [self didSelectOnProfileWithButtonCell: lProfileWithButtonCell];
}

-(void)didSelectOnProfileWithButtonCell:(ProfileWithButtonCell *)cell
{
    NSIndexPath* indexPath = [self.tableview indexPathForCell:cell];
    NSMutableDictionary* lData = [mSearchedProfileData objectAtIndex:indexPath.row];
    BOOL lSelected = [[lData objectForKey: @"IsSelected"] boolValue];
    [lData setObject: [NSNumber numberWithBool: !lSelected] forKey: @"IsSelected"];
    [self.tableview reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark - SearchBar Delegate
#pragma mark -

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [ self prepareSearchData:searchBar];
    
    [searchBar resignFirstResponder];
}

-(void)prepareSearchData:(UISearchBar *)searchBar{
    NSString * text =  [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self searchProfile:text];
    
    [self.tableview reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0 )
    {
//        mSearchedProfileData = mProfileData;
//        [self.tableview reloadData];

        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
    }
    else if ([searchText length] < 3 && [searchText length] > 0)
    {
        mSearchedProfileData = nil;
        [self.tableview reloadData];
    }
    else if ([searchText length] >= 3)
    {
        [self performSelector:@selector(searchProfile:)
                   withObject:searchText
                   afterDelay:0];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchProfile:(NSString*)searchScope
{
    if(!searchScope.length)
        return;
    
    NSArray *lprofileData = [NSArray arrayWithArray:mProfileData];
        lprofileData = [self searchProfiles:searchScope];
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"DisplayName contains[cd] %@",searchScope];
    NSMutableArray* lOriginalData = [[NSMutableArray alloc] initWithArray: mProfileData];
    
    [mProfileData filterUsingPredicate: predicate];
    mSearchedProfileData = mProfileData;
    mProfileData = lOriginalData;
    
    [self.tableview reloadData];
}

-(NSArray *)searchProfiles: (NSString *)searchScope
{
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"DisplayName contains[cd] %@",searchScope];
    NSArray* entityArray = [mProfileData filteredArrayUsingPredicate:predicate];
    
    if (entityArray && [entityArray count]>0)
        return entityArray;
    
    return nil;
    
}


@end
