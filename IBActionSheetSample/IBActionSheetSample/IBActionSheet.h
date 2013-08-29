//  Created by Ian Burns on 8/24/13.
//
//  Copyright (c) 2013 Ian Burns
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#define UIControlStateAll UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted
#define SYSTEM_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)

// Define 'button press' effects
typedef NS_ENUM(NSInteger, IBActionSheetButtonResponse) {
    
    IBActionSheetButtonResponseFadesOnPress,
    IBActionSheetButtonResponseReversesColorsOnPress,
    IBActionSheetButtonResponseShrinksOnPress,
    IBActionSheetButtonResponseHighlightsOnPress
};

typedef NS_ENUM(NSInteger, IBActionSheetButtonCornerType) {
    
    IBActionSheetButtonCornerTypeNoCornersRounded,
    IBActionSheetButtonCornerTypeTopCornersRounded,
    IBActionSheetButtonCornerTypeBottomCornersRounded,
    IBActionSheetButtonCornerTypeAllCornersRounded
    
};

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


// forward declarations
@class IBActionSheet, IBActionSheetTitleView;

#pragma mark - IBActionSheetDelegate Protocol

// Protocol needed to receive notifications from the IBActionSheet (Will receive UIActionSheet notifications as well)
@protocol IBActionSheetDelegate <NSObject>

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

#pragma mark - IBActionSheet

@interface IBActionSheet : UIView {
    
}

- (void)showInView:(UIView *)theView;
- (NSInteger)addButtonWithTitle:(NSString *)title;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (id)initWithTitle:(NSString *)title delegate:(id<IBActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


- (NSInteger)numberOfButtons;
- (NSString *)buttonTitleAtIndex:(NSInteger)index;
- (void)rotateToCurrentOrientation;


// fonts
- (void)setFont:(UIFont *)font;
- (void)setTitleFont:(UIFont *)font;
- (void)setFont:(UIFont *)font forButtonAtIndex:(NSInteger)index;


// standard colors
- (void)setTitleTextColor:(UIColor *)color;
- (void)setButtonTextColor:(UIColor *)color;
- (void)setTitleBackgroundColor:(UIColor *)color;
- (void)setButtonBackgroundColor:(UIColor *)color;
- (UIColor *)buttonTextColorAtIndex:(NSInteger)index;
- (UIColor *)buttonBackgroundColorAtIndex:(NSInteger)index;
- (void)setButtonTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;
- (void)setButtonBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;


// highlight colors
- (void)setButtonHighlightBackgroundColor:(UIColor *)color;
- (void)setButtonHighlightTextColor:(UIColor *)color;
- (void)setButtonHighlightTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;
- (void)setButtonHighlightBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;

@property UIView *transparentView;
@property NSMutableArray *buttons;
@property (nonatomic) NSString *title;
@property IBActionSheetTitleView *titleView;
@property (weak) id <IBActionSheetDelegate> delegate;
@property IBActionSheetButtonResponse buttonResponse;
@property BOOL visible, hasCancelButton, hasDestructiveButton, shouldCancelOnTouch;

@end

#pragma mark - IBActionSheetButton

@interface IBActionSheetButton : UIButton


- (id)initWithTopCornersRounded;
- (id)initWithAllCornersRounded;
- (id)initWithBottomCornersRounded;
- (void)resizeForPortraitOrientation;
- (void)resizeForLandscapeOrientation;
- (void)setTextColor:(UIColor *)color;

@property NSInteger index;
@property IBActionSheetButtonCornerType cornerType;
@property UIColor *originalTextColor, *highlightTextColor;
@property UIColor *originalBackgroundColor, *highlightBackgroundColor;


@end


#pragma mark - IBActionSheetTitleView

@interface IBActionSheetTitleView : UIView

- (void)resizeForPortraitOrientation;
- (void)resizeForLandscapeOrientation;
- (id)initWithTitle:(NSString *)title;



@property UILabel *titleLabel;

@end




