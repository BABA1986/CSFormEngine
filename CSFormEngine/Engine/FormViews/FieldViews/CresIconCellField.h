//
//  CresIconCellField.h
//  Edumation
//
//  Created by Deepak on 19/02/16.
//  Copyright © 2016 Correlation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CresIconCellField : UIView
{
    UIImageView*                mIconView;
    UILabel*                    mDescLabel;
}

@property(nonatomic, strong)UIImageView*            iconView;
@property(nonatomic, strong)UILabel*                descLabel;

- (void)setImageFromSource: (NSString*)imageSrc;

@end
