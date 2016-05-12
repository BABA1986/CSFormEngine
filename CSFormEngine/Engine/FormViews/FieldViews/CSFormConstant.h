//
//  CSFormConstant.h
//  CSFormEngine
//
//  Created by Deepak on 29/04/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#ifndef CSFormConstant_h
#define CSFormConstant_h

#define kHelveticaNeueBoldItalic           @"HelveticaNeue-BoldItalic"
#define kHelveticaNeueLight                @"HelveticaNeue-Light"
#define kHelveticaNeueUltraLightItalic     @"HelveticaNeue-UltraLightItalic"
#define kHelveticaNeueCondensedBold        @"HelveticaNeue-CondensedBold"
#define kHelveticaNeueMediumItalic         @"HelveticaNeue-MediumItalic"
#define kHelveticaNeueThin                 @"HelveticaNeue-Thin"
#define kHelveticaNeueMedium               @"HelveticaNeue-Medium"
#define kHelveticaNeueThinItalic           @"HelveticaNeue-ThinItalic"
#define kHelveticaNeueLightItalic          @"HelveticaNeue-LightItalic"
#define kHelveticaNeueUltraLight           @"HelveticaNeue-UltraLight"
#define kHelveticaNeueBold                 @"HelveticaNeue-Bold"
#define kHelveticaNeue                     @"HelveticaNeue"
#define kHelveticaNeueCondensedBlack       @"HelveticaNeue-CondensedBlack"

#define kFont(fontFamily, xSize)          [UIFont fontWithName:fontFamily size:xSize]


//////////////////////////////CSObjectiveQuestionView///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
#define kRadioNormalImage                 @""
#define kRadioSelectedImage               @""
#define kMultiSelectNormalImage           @""
#define kMultiSelectSelectedImage         @""

#define kMarginBetweenQAndOptions         20.0
#define kMarginBetweenOptions             10.0
#define kYMarginQuestion                  20.0
#define kXMarginQuestion                  10.0
#define kXMarginOption                    10.0
#define kYOffsetOptionText                10.0
#define kXOffsetOptionText                5.0
#define kIndexButtonWidth                 40.0
#define kMinOptionLabelHeight             45.0


#define kQuestionFont                   kFont(kHelveticaNeueBold, 15)
#define kOptionIndexFont                kFont(kHelveticaNeueMedium, 20)
#define kOptionFont                     kFont(kHelveticaNeueLight, 15)
#define kQuestionHintFont               kFont(kHelveticaNeueUltraLight, 13)

#define kDefaultSelectImage             [UIImage imageNamed: @"selected.png"]
#define kDefaultUnSelectImage           [UIImage imageNamed: @"unselected.png"]

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////


#endif /* CSFormConstant_h */
