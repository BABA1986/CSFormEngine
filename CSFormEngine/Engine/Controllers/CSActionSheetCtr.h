//
//  PopOverController.h
//  PhotoSelectionTool
//
//  Created by Firoz Khan on 27/01/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionSheetButton : UIButton

@end

@class CSActionSheetCtr;
@protocol CSActionSheetCtrDelegate <NSObject>
- (void)cSActionSheetCtr:(CSActionSheetCtr*)actionSheet
           clickedButtonAtIndex:(NSInteger)buttonIndex;
@optional
-(void)actionSheet:(CSActionSheetCtr *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;

@end


@interface CSActionSheetCtr : UIViewController
{
    __weak id<CSActionSheetCtrDelegate>        mDelegate;
}

@property(nonatomic, weak)id<CSActionSheetCtrDelegate>        delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)Avatar:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)ChooseExisting:(id)sender;



@end
