//
//  SearchPickerCtr.h
//  Edumation
//
//  Created by Ankit Gupta on 12/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileWithButtonCell.h"
#import "CresBaseViewController.h"

@class SearchPickerCtr;
@protocol SearchPickerCtrDelegate <NSObject>

- (void)willDissmissSearckPicker: (SearchPickerCtr*)searchPicker onClickingBtn:(NSString *)btn selectedItems: (NSArray*)selectedItems;

@optional

@end

@interface SearchPickerCtr : CresBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ProfileWithButtonCellDelegate>
{
    NSMutableArray*                 mLastSelected;
}

@property (copy, nonatomic) IBOutlet NSString *pickerTitle;
@property (copy, nonatomic)  NSString *pickerMsg;
@property (copy, nonatomic)  NSString *pickerPlaceholder;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *profileSearch;
@property (weak, nonatomic) IBOutlet UILabel *txtView;

@property(weak,nonatomic)id<SearchPickerCtrDelegate> delegate;

- (instancetype)initWithLastSelected: (NSMutableArray*)lastSelected;
- (IBAction)nextBtnPressed:(id)sender;



@end
