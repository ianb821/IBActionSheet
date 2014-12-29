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


#import "IBActionSheet.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#pragma mark - IBActionSheet

@implementation IBActionSheet

#pragma mark IBActionSheet Set up methods

- (id)init {
    
    self = [self initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.buttonResponse = IBActionSheetButtonResponseFadesOnPress;
    self.backgroundColor = [UIColor clearColor];
    self.buttons = [[NSMutableArray alloc] init];
    self.shouldCancelOnTouch = YES;
    self.cancelButtonIndex = -1;
    self.destructiveButtonIndex = -1;
    
    self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    self.transparentView.backgroundColor = [UIColor blackColor];
    self.transparentView.alpha = 0.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelection)];
    tap.numberOfTapsRequired = 1;
    [self.transparentView addGestureRecognizer:tap];
    
    return self;
}


- (id)initWithTitle:(NSString *)title delegate:(id<IBActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    if (otherTitles) {
        va_list args;
        va_start(args, otherTitles);
        for (NSString *arg = otherTitles; arg != nil; arg = va_arg(args, NSString* ))
        {
            [titles addObject:arg];
        }
        va_end(args);
    }
    return [self initWithTitle:title delegate:delegate cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherButtonTitlesArray:titles];
}

- (id)initWithTitle:(NSString *)title callback:(IBActionCallback)callback cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    if (otherTitles) {
        va_list args;
        va_start(args, otherTitles);
        for (NSString *arg = otherTitles; arg != nil; arg = va_arg(args, NSString* ))
        {
            [titles addObject:arg];
        }
        va_end(args);
    }
    return [self initWithTitle:title callback:callback cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherButtonTitlesArray:titles];
}





- (id)initWithTitle:(NSString *)title delegate:(id<IBActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitlesArray:(NSArray *)otherTitlesArray {
    
    self = [self init];
    self.delegate = delegate;
    
    NSMutableArray* titles = [otherTitlesArray mutableCopy];
    
    if (destructiveTitle) {
        [titles insertObject:destructiveTitle atIndex:0];
        self.hasDestructiveButton = YES;
        self.destructiveButtonIndex = 0;
    } else {
        self.hasDestructiveButton = NO;
        self.destructiveButtonIndex = -1;
    }
    
    // set up cancel button
    if (cancelTitle) {
        IBActionSheetButton *cancelButton = [[IBActionSheetButton alloc] initWithAllCornersRounded];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
        [cancelButton setTitle:cancelTitle forState:UIControlStateAll];
        [self.buttons addObject:cancelButton];
        self.hasCancelButton = YES;
    } else {
        self.shouldCancelOnTouch = NO;
        self.hasCancelButton = NO;
    }
    
    switch (titles.count) {
            
        case 0: {
            break;
        }
            
        case 1: {
            
            IBActionSheetButton *otherButton;
            
            if (title) {
                otherButton = [[IBActionSheetButton alloc] initWithBottomCornersRounded];
            } else {
                otherButton = [[IBActionSheetButton alloc] initWithAllCornersRounded];
            }
            
            [otherButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:otherButton atIndex:0];
            
            break;
            
        } case 2: {
            
            IBActionSheetButton *otherButton = [[IBActionSheetButton alloc] initWithBottomCornersRounded];
            [otherButton setTitle:[titles objectAtIndex:1] forState:UIControlStateAll];
            
            IBActionSheetButton *secondButton;
            
            if (title) {
                secondButton = [[IBActionSheetButton alloc] init];
            } else {
                secondButton = [[IBActionSheetButton alloc] initWithTopCornersRounded];
            }
            
            [secondButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:secondButton atIndex:0];
            [self.buttons insertObject:otherButton atIndex:1];
            
            break;
            
        } default: {
            
            IBActionSheetButton *bottomButton = [[IBActionSheetButton alloc] initWithBottomCornersRounded];
            [bottomButton setTitle:[titles lastObject] forState:UIControlStateAll];
            
            IBActionSheetButton *topButton;
            
            if (title) {
                topButton = [[IBActionSheetButton alloc] init];
            } else {
                topButton = [[IBActionSheetButton alloc] initWithTopCornersRounded];
            }
            
            [topButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:topButton atIndex:0];
            
            int whereToStop = (int)titles.count - 1;
            for (int i = 1; i < whereToStop; ++i) {
                IBActionSheetButton *middleButton = [[IBActionSheetButton alloc] init];
                [middleButton setTitle:[titles objectAtIndex:i] forState:UIControlStateAll];
                [self.buttons insertObject:middleButton atIndex:i];
            }
            
            [self.buttons insertObject:bottomButton atIndex:(titles.count - 1)];
            
            break;
        }
    }
    
    if (self.hasCancelButton) {
        self.cancelButtonIndex = self.buttons.count - 1;
    } else {
        self.cancelButtonIndex = -1;
    }
    
    [self setUpTheActions];
    
    if (destructiveTitle) {
        [[self.buttons objectAtIndex:0] setTextColor:[UIColor colorWithRed:1.000 green:0.229 blue:0.000 alpha:1.000]];
        [[self.buttons objectAtIndex:0] setOriginalTextColor:[UIColor colorWithRed:1.000 green:0.229 blue:0.000 alpha:1.000]];
    }
    
    for (int i = 0; i < self.buttons.count; ++i) {
        [[self.buttons objectAtIndex:i] setIndex:i];
    }
    
    if (title) {
        self.title = title;
    } else {
        [self setUpTheActionSheet];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title callback:(IBActionCallback)callback cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitlesArray:(NSArray *)otherTitlesArray {
    
    self = [self init];
    self.callback = callback;
    
    NSMutableArray* titles = [otherTitlesArray mutableCopy];
    
    if (destructiveTitle) {
        [titles insertObject:destructiveTitle atIndex:0];
        self.hasDestructiveButton = YES;
        self.destructiveButtonIndex = 0;
    } else {
        self.hasDestructiveButton = NO;
        self.destructiveButtonIndex = -1;
    }
    
    // set up cancel button
    if (cancelTitle) {
        IBActionSheetButton *cancelButton = [[IBActionSheetButton alloc] initWithAllCornersRounded];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
        [cancelButton setTitle:cancelTitle forState:UIControlStateAll];
        [self.buttons addObject:cancelButton];
        self.hasCancelButton = YES;
    } else {
        self.shouldCancelOnTouch = NO;
        self.hasCancelButton = NO;
    }
    
    switch (titles.count) {
            
        case 0: {
            break;
        }
            
        case 1: {
            
            IBActionSheetButton *otherButton;
            
            if (title) {
                otherButton = [[IBActionSheetButton alloc] initWithBottomCornersRounded];
            } else {
                otherButton = [[IBActionSheetButton alloc] initWithAllCornersRounded];
            }
            
            [otherButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:otherButton atIndex:0];
            
            break;
            
        } case 2: {
            
            IBActionSheetButton *otherButton = [[IBActionSheetButton alloc] initWithBottomCornersRounded];
            [otherButton setTitle:[titles objectAtIndex:1] forState:UIControlStateAll];
            
            IBActionSheetButton *secondButton;
            
            if (title) {
                secondButton = [[IBActionSheetButton alloc] init];
            } else {
                secondButton = [[IBActionSheetButton alloc] initWithTopCornersRounded];
            }
            
            [secondButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:secondButton atIndex:0];
            [self.buttons insertObject:otherButton atIndex:1];
            
            break;
            
        } default: {
            
            IBActionSheetButton *bottomButton = [[IBActionSheetButton alloc] initWithBottomCornersRounded];
            [bottomButton setTitle:[titles lastObject] forState:UIControlStateAll];
            
            IBActionSheetButton *topButton;
            
            if (title) {
                topButton = [[IBActionSheetButton alloc] init];
            } else {
                topButton = [[IBActionSheetButton alloc] initWithTopCornersRounded];
            }
            
            [topButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:topButton atIndex:0];
            
            int whereToStop = (int)titles.count - 1;
            for (int i = 1; i < whereToStop; ++i) {
                IBActionSheetButton *middleButton = [[IBActionSheetButton alloc] init];
                [middleButton setTitle:[titles objectAtIndex:i] forState:UIControlStateAll];
                [self.buttons insertObject:middleButton atIndex:i];
            }
            
            [self.buttons insertObject:bottomButton atIndex:(titles.count - 1)];
            
            break;
        }
    }
    
    if (self.hasCancelButton) {
        self.cancelButtonIndex = self.buttons.count - 1;
    } else {
        self.cancelButtonIndex = -1;
    }
    
    [self setUpTheActions];
    
    if (destructiveTitle) {
        [[self.buttons objectAtIndex:0] setTextColor:[UIColor colorWithRed:1.000 green:0.229 blue:0.000 alpha:1.000]];
        [[self.buttons objectAtIndex:0] setOriginalTextColor:[UIColor colorWithRed:1.000 green:0.229 blue:0.000 alpha:1.000]];
    }
    
    for (int i = 0; i < self.buttons.count; ++i) {
        [[self.buttons objectAtIndex:i] setIndex:i];
    }
    
    if (title) {
        self.title = title;
    } else {
        [self setUpTheActionSheet];
    }
    
    return self;
}



- (void)setUpTheActionSheet {
    
    float height;
    float width;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        width = CGRectGetWidth([UIScreen mainScreen].bounds);
    } else {
        width = CGRectGetHeight([UIScreen mainScreen].bounds);
    }
    
    
    // slight adjustment to take into account non-retina devices
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        
        // setup spacing for retina devices
        if (self.hasCancelButton) {
            height = 59.5;
        } else if (!self.hasCancelButton && self.titleView) {
            height = 52.0;
        } else {
            height = 104.0;
        }
        
        if (self.buttons.count) {
            height += (self.buttons.count * 44.5);
        }
        if (self.titleView) {
            height += CGRectGetHeight(self.titleView.frame) - 44;
        }
        
        self.frame = CGRectMake(0, 0, width, height);
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGPoint pointOfReference = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - 30);
        
        int whereToStop;
        if (self.hasCancelButton) {
            [self addSubview:[self.buttons lastObject]];
            [[self.buttons lastObject] setCenter:pointOfReference];
            [[self.buttons objectAtIndex:0] setCenter:CGPointMake(pointOfReference.x, pointOfReference.y - 52)];
            pointOfReference = CGPointMake(pointOfReference.x, pointOfReference.y - 52);
            whereToStop = (int)self.buttons.count - 2;
        } else {
            [self addSubview:[self.buttons lastObject]];
            [[self.buttons lastObject] setCenter:pointOfReference];
            whereToStop = (int)self.buttons.count - 1;
        }
        
        for (int i = 0, j = whereToStop; i <= whereToStop; ++i, --j) {
            [self addSubview:[self.buttons objectAtIndex:i]];
            [[self.buttons objectAtIndex:i] setCenter:CGPointMake(pointOfReference.x, pointOfReference.y - (44.5 * j))];
        }
        
        if (self.titleView) {
            [self addSubview:self.titleView];
            self.titleView.center = CGPointMake(self.center.x, CGRectGetHeight(self.titleView.frame) / 2.0);
        }
        
    } else {
        
        // setup spacing for non-retina devices
        
        if (self.hasCancelButton) {
            height = 60.0;
        } else {
            height = 104.0;
        }
        
        if (self.buttons.count) {
            height += (self.buttons.count * 45);
        }
        if (self.titleView) {
            height += CGRectGetHeight(self.titleView.frame) - 45;
        }
        
        self.frame = CGRectMake(0, 0, width, height);
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGPoint pointOfReference = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - 30);
        
        int whereToStop;
        if (self.hasCancelButton) {
            [self addSubview:[self.buttons lastObject]];
            [[self.buttons lastObject] setCenter:pointOfReference];
            [[self.buttons objectAtIndex:0] setCenter:CGPointMake(pointOfReference.x, pointOfReference.y - 52)];
            pointOfReference = CGPointMake(pointOfReference.x, pointOfReference.y - 52);
            whereToStop = (int)self.buttons.count - 2;
        } else {
            [self addSubview:[self.buttons lastObject]];
            [[self.buttons lastObject] setCenter:pointOfReference];
            whereToStop = (int)self.buttons.count - 1;
        }
        
        for (int i = 0, j = whereToStop; i <= whereToStop; ++i, --j) {
            [self addSubview:[self.buttons objectAtIndex:i]];
            [[self.buttons objectAtIndex:i] setCenter:CGPointMake(pointOfReference.x, pointOfReference.y - (45 * j))];
        }
        
        if (self.titleView) {
            [self addSubview:self.titleView];
            self.titleView.center = CGPointMake(self.center.x, CGRectGetHeight(self.titleView.frame) / 2.0);
        }
    }
    
}

- (void)setUpTheActions {
    
    for (IBActionSheetButton *button in self.buttons) {
        if ([button isKindOfClass:[IBActionSheetButton class]]) {
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(highlightPressedButton:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(unhighlightPressedButton:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
        }
    }
}

- (void)highlightPressedButton:(IBActionSheetButton *)button {
    
    [UIView animateWithDuration:0.15f
                     animations:^() {
                         
                         if (self.buttonResponse == IBActionSheetButtonResponseFadesOnPress) {
                             button.alpha = .80f;
                         } else if (self.buttonResponse == IBActionSheetButtonResponseShrinksOnPress) {
                             button.transform = CGAffineTransformMakeScale(.98, .95);
                         } else if (self.buttonResponse == IBActionSheetButtonResponseHighlightsOnPress) {
                             button.backgroundColor = button.highlightBackgroundColor;
                             [button setTitleColor:button.highlightTextColor forState:UIControlStateAll];
                             
                         } else {
                             
                             UIColor *tempColor = button.titleLabel.textColor;
                             [button setTitleColor:button.backgroundColor forState:UIControlStateAll];
                             button.backgroundColor = tempColor;
                         }
                         
                     }];
}

- (void)unhighlightPressedButton:(IBActionSheetButton *)button {
    
    [UIView animateWithDuration:0.3f
                     animations:^() {
                         
                         if (self.buttonResponse == IBActionSheetButtonResponseFadesOnPress) {
                             button.alpha = .95f;
                         } else if( self.buttonResponse == IBActionSheetButtonResponseShrinksOnPress) {
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } else  if (self.buttonResponse == IBActionSheetButtonResponseHighlightsOnPress) {
                             button.backgroundColor = button.originalBackgroundColor;
                             [button setTitleColor:button.originalTextColor forState:UIControlStateAll];
                         } else {
                             UIColor *tempColor = button.backgroundColor;
                             button.backgroundColor = button.titleLabel.textColor;
                             [button setTitleColor:tempColor forState:UIControlStateAll];
                         }
                     }];
    
}

#pragma mark IBActionSheet Helpful methods

- (NSInteger)addButtonWithTitle:(NSString *)title {
    
    int index = (int)self.buttons.count;
    
    if (self.hasCancelButton) {
        index -= 1;
    }
    
    IBActionSheetButton *button;
    
    if ((self.buttons.count == 1 && self.hasCancelButton && !self.titleView) || (self.buttons.count == 0 && !self.titleView))
        button = [[IBActionSheetButton alloc] initWithAllCornersRounded];
    else
        button = [[IBActionSheetButton alloc] initWithBottomCornersRounded];
    
    [button setTitle:title forState:UIControlStateAll];
    
    button.index = index;
    
    if (self.hasCancelButton) {
        
        // update the cancel button with its new index
        [self.buttons insertObject:button atIndex:index];
        IBActionSheetButton *cancelButton = [self.buttons lastObject];
        cancelButton.index += 1;
        [self.buttons replaceObjectAtIndex:(index + 1) withObject:cancelButton];
        
        IBActionSheetButton *tempButton;
        IBActionSheetButton *theButtonToCopy;
        
        if (self.buttons.count == 3) {
            if (self.titleView) {
                tempButton = [[IBActionSheetButton alloc] init];
            } else {
                tempButton = [[IBActionSheetButton alloc] initWithTopCornersRounded];
            }
            
            theButtonToCopy = [self.buttons objectAtIndex:0];
            tempButton.index = theButtonToCopy.index;
            [tempButton setTitle:theButtonToCopy.titleLabel.text forState:UIControlStateAll];
            
            [self.buttons replaceObjectAtIndex:0 withObject:tempButton];
            [self setButtonTextColor:theButtonToCopy.titleLabel.textColor forButtonAtIndex:0];
            [self setButtonBackgroundColor:theButtonToCopy.backgroundColor forButtonAtIndex:0];
            
        } else if (self.buttons.count > 2) {
            
            tempButton = [[IBActionSheetButton alloc] init];
            theButtonToCopy = [self.buttons objectAtIndex:(index - 1)];
            [tempButton setTitle:theButtonToCopy.titleLabel.text forState:UIControlStateAll];
            tempButton.titleLabel.text = theButtonToCopy.titleLabel.text;
            tempButton.index = theButtonToCopy.index;
            
            [self.buttons replaceObjectAtIndex:(index - 1) withObject:tempButton];
            [self setButtonTextColor:theButtonToCopy.titleLabel.textColor forButtonAtIndex:(index - 1)];
            [self setButtonBackgroundColor:theButtonToCopy.backgroundColor forButtonAtIndex:(index - 1)];
        }
    } else {
        
        button.index = self.buttons.count;
        [self.buttons addObject:button];
        
        
        if (self.buttons.count == 3) {
            
            IBActionSheetButton *theButtonToCopy = [self.buttons objectAtIndex:0];
            IBActionSheetButton *tempButton;
            
            if (self.titleView)
                tempButton = [[IBActionSheetButton alloc] init];
            else
                tempButton = [[IBActionSheetButton alloc] initWithTopCornersRounded];
            
            [tempButton setTitle:theButtonToCopy.titleLabel.text forState:UIControlStateAll];
            tempButton.titleLabel.text = theButtonToCopy.titleLabel.text;
            tempButton.index = theButtonToCopy.index;
            
            [self.buttons replaceObjectAtIndex:tempButton.index withObject:tempButton];
        }
        
        if (self.buttons.count >= 2) {
            
            IBActionSheetButton *theButtonToCopy;
            
            if (self.buttons.count == 2 && !self.hasCancelButton)
                theButtonToCopy = [self.buttons objectAtIndex:index - 1];
            else
                theButtonToCopy = [self.buttons objectAtIndex:index];
            IBActionSheetButton *tempButton;
            
            if (self.titleView || self.buttons.count > 2)
                tempButton = [[IBActionSheetButton alloc] init];
            else
                tempButton = [[IBActionSheetButton alloc] initWithTopCornersRounded];
            
            [tempButton setTitle:theButtonToCopy.titleLabel.text forState:UIControlStateAll];
            tempButton.titleLabel.text = theButtonToCopy.titleLabel.text;
            tempButton.index = theButtonToCopy.index;
            
            [self.buttons replaceObjectAtIndex:tempButton.index withObject:tempButton];
            
        }
        
        
    }
    
    [self setUpTheActions];
    [self setUpTheActionSheet];
    
    return index;
}


- (void)buttonClicked:(IBActionSheetButton *)button {
    
    if(self.delegate) [self.delegate actionSheet:self clickedButtonAtIndex:button.index];
    if(self.callback) self.callback(self, button.index);
    self.shouldCancelOnTouch = YES;
    [self removeFromView];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    if (!animated) {
        [self.transparentView removeFromSuperview];
        UIView *blurView = [self.superview viewWithTag:821];
        if (blurView) {
            [blurView removeFromSuperview];
        }
        [self removeFromSuperview];
        self.visible = NO;
        if(self.delegate) [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
        if(self.callback) self.callback(self, buttonIndex);
    } else {
        [self removeFromView];
        if(self.delegate) [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
        if(self.callback) self.callback(self, buttonIndex);
    }
}

- (void)showInView:(UIView *)theView {
    
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    if (NSClassFromString(@"UIVisualEffectView") && self.blurBackground) {
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = theView.bounds;
        visualEffectView.tag = 821;
        [theView addSubview:visualEffectView];
        visualEffectView.userInteractionEnabled = NO;
    }
    
    [theView addSubview:self];
    
    [theView insertSubview:self.transparentView belowSubview:self];
    
    CGRect theScreenRect = [UIScreen mainScreen].bounds;
    
    float height;
    float x;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        height = CGRectGetHeight(theScreenRect);
        x = CGRectGetWidth(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetWidth(theScreenRect), CGRectGetHeight(theScreenRect));
    } else {
        height = CGRectGetWidth(theScreenRect);
        x = CGRectGetHeight(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetHeight(theScreenRect), CGRectGetWidth(theScreenRect));
    }
    
    self.center = CGPointMake(x, height + CGRectGetHeight(self.frame) / 2.0);
    self.transparentView.center = CGPointMake(x, height / 2.0);
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^() {
                             self.transparentView.alpha = 0.4f;
                             self.center = CGPointMake(x, (height - 20) - CGRectGetHeight(self.frame) / 2.0);
                             
                         } completion:^(BOOL finished) {
                             self.visible = YES;
                         }];
    } else {
        
        [UIView animateWithDuration:0.3f
                              delay:0
             usingSpringWithDamping:0.85f
              initialSpringVelocity:1.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.transparentView.alpha = 0.4f;
                             self.center = CGPointMake(x, height - CGRectGetHeight(self.frame) / 2.0);
                             
                         } completion:^(BOOL finished) {
                             self.visible = YES;
                         }];
    }
}

- (void) cancelSelection {
    if(self.callback) self.callback(self, NSIntegerMax);
    [self removeFromView];
}

- (void)removeFromView {
    
    if (self.shouldCancelOnTouch) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^() {
                                 self.transparentView.alpha = 0.0f;
                                 self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);
                                 
                             } completion:^(BOOL finished) {
                                 [self.transparentView removeFromSuperview];
                                 [self removeFromSuperview];
                                 self.visible = NO;
                             }];
        } else {
            
            UIView *blurView = [self.transparentView.superview viewWithTag:821];
            
            [UIView animateWithDuration:0.3f
                                  delay:0
                 usingSpringWithDamping:0.85f
                  initialSpringVelocity:1.0f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 
                                 if (blurView) {
                                     blurView.alpha = 0;
                                 }
                                 
                                 self.transparentView.alpha = 0.0f;
                                 self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);
                                 
                             } completion:^(BOOL finished) {
                                 [self.transparentView removeFromSuperview];
                                 [self removeFromSuperview];
                                 if (blurView) {
                                     [blurView removeFromSuperview];
                                 }
                                 self.visible = NO;
                             }];
        }
        
    }
    
}

- (void)rotateToCurrentOrientation {
    
    float width = SCREEN_WIDTH;
    float height = SCREEN_HEIGHT;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        
        for (IBActionSheetButton * button in self.buttons) {
            [button resizeForPortraitOrientation];
        }
        
        [self.titleView resizeForPortraitOrientation];
        [self setUpTheActionSheet];
        
    } else {
        
        for (IBActionSheetButton * button in self.buttons) {
            [button resizeForLandscapeOrientation];
        }
        [self.titleView resizeForLandscapeOrientation];
        [self setUpTheActionSheet];
        
        
    }
    
    self.transparentView.frame = CGRectMake(0, 0, width, height);
    self.transparentView.center = CGPointMake(width / 2.0, height / 2.0);
    self.center = self.center = CGPointMake(width / 2.0, height - CGRectGetHeight(self.frame) / 2.0);
    
}


#pragma mark IBActionSheet Color methods

- (void)setButtonTextColor:(UIColor *)color {
    
    for (IBActionSheetButton *button in self.buttons) {
        [button setTitleColor:color forState:UIControlStateAll];
        button.originalTextColor = color;
    }
    
    [self setTitleTextColor:color];
}

- (void)setButtonBackgroundColor:(UIColor *)color {
    
    for (IBActionSheetButton *button in self.buttons) {
        button.backgroundColor = color;
        button.originalBackgroundColor = color;
    }
    
    [self setTitleBackgroundColor:color];
}

- (void)setTitleTextColor:(UIColor *)color {
    self.titleView.titleLabel.textColor = color;
}

- (void)setTitleBackgroundColor:(UIColor *)color {
    self.titleView.backgroundColor = color;
}

- (void)setTextColor:(UIColor *)color ForButton:(IBActionSheetButton *)button {
    [button setTitleColor:color forState:UIControlStateAll];
}

- (void)setButtonBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index {
    [[self.buttons objectAtIndex:index] setBackgroundColor:color];
}

- (void)setButtonTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index {
    [self setTextColor:color ForButton:[self.buttons objectAtIndex:index]];
}

- (UIColor *)buttonBackgroundColorAtIndex:(NSInteger)index {
    return [[self.buttons objectAtIndex:index] backgroundColor];
}

- (UIColor *)buttonTextColorAtIndex:(NSInteger)index {
    return [[[self.buttons objectAtIndex:index] titleLabel] textColor];
}

- (void)setButtonHighlightBackgroundColor:(UIColor *)color {
    for (IBActionSheetButton *button in self.buttons) {
        button.highlightBackgroundColor = color;
    }
}

- (void)setButtonHighlightBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index {
    [[self.buttons objectAtIndex:index] setHighlightBackgroundColor:color];
}

- (void)setButtonHighlightTextColor:(UIColor *)color {
    for (IBActionSheetButton *button in self.buttons) {
        button.highlightTextColor = color;
    }
}

- (void)setButtonHighlightTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index {
    [[self.buttons objectAtIndex:index] setHighlightTextColor:color];
}

#pragma mark IBActionSheet Other Properties methods

- (void)setTitle:(NSString *)title {
    self.titleView = [[IBActionSheetTitleView alloc] initWithTitle:title font:nil];
    [self setUpTheActionSheet];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index {
    return [[[self.buttons objectAtIndex:index] titleLabel] text];
}

- (NSInteger)numberOfButtons {
    return self.buttons.count;
}

- (void)setFont:(UIFont *)font {
    for (IBActionSheetButton *button in self.buttons) {
        [self setFont:font forButton:button];
    }
    
    [self setTitleFont:font];
}

- (void)setFont:(UIFont *)font forButtonAtIndex:(NSInteger)index {
    [[[self.buttons objectAtIndex:index] titleLabel] setFont:font];
}

- (void)setFont:(UIFont *)font forButton:(IBActionSheetButton *)button {
    button.titleLabel.font = font;
}

- (void)setTitleFont:(UIFont *)font {
    if (self.titleView) {
        UIColor *backgroundColor = self.titleView.backgroundColor;
        UIColor *textColor = self.titleView.titleLabel.textColor;
        self.titleView = [[IBActionSheetTitleView alloc] initWithTitle:self.titleView.titleLabel.text font:font];
        self.titleView.backgroundColor = backgroundColor;
        self.titleView.titleLabel.textColor = textColor;
        [self setUpTheActionSheet];
    }
}

- (void)setCancelButtonFont:(UIFont *)font {
    if (self.hasCancelButton) {
        [self setFont:font forButtonAtIndex:self.cancelButtonIndex];
    }
}

- (void)setDestructiveButtonFont:(UIFont *)font {
    if (self.hasDestructiveButton) {
        [self setFont:font forButtonAtIndex:self.destructiveButtonIndex];
    }
}

@end



#pragma mark - IBActionSheetButton

@implementation IBActionSheetButton


- (id)init {
    
    float width;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        width = CGRectGetWidth([UIScreen mainScreen].bounds);
    } else {
        width = CGRectGetHeight([UIScreen mainScreen].bounds);
    }
    self = [self initWithFrame:CGRectMake(0, 0, width - 16, 44)];
    
    self.backgroundColor = [UIColor whiteColor];
    self.originalBackgroundColor = self.backgroundColor;
    self.titleLabel.font = [UIFont systemFontOfSize:21];
    [self setTitleColor:[UIColor colorWithRed:0.000 green:0.500 blue:1.000 alpha:1.000] forState:UIControlStateAll];
    self.originalTextColor = [UIColor colorWithRed:0.000 green:0.500 blue:1.000 alpha:1.000];
    
    self.alpha = 0.95f;
    
    self.cornerType = IBActionSheetButtonCornerTypeNoCornersRounded;
    
    return self;
}

- (id)initWithTopCornersRounded {
    self = [self init];
    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    self.cornerType = IBActionSheetButtonCornerTypeTopCornersRounded;
    return self;
}

- (id)initWithBottomCornersRounded {
    self = [self init];
    [self setMaskTo:self byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    self.cornerType = IBActionSheetButtonCornerTypeBottomCornersRounded;
    return self;
}

- (id)initWithAllCornersRounded {
    self = [self init];
    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight];
    self.cornerType = IBActionSheetButtonCornerTypeAllCornersRounded;
    return self;
}


- (void)setTextColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateAll];
}

- (void)resizeForPortraitOrientation {
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 16, CGRectGetHeight(self.frame));
    
    switch (self.cornerType) {
        case IBActionSheetButtonCornerTypeNoCornersRounded:
            break;
            
        case IBActionSheetButtonCornerTypeTopCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
            break;
        }
        case IBActionSheetButtonCornerTypeBottomCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            break;
        }
            
        case IBActionSheetButtonCornerTypeAllCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight];
            break;
        }
            
        default:
            break;
    }
}

- (void)resizeForLandscapeOrientation {
    self.frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds) - 16, CGRectGetHeight(self.frame));
    
    switch (self.cornerType) {
        case IBActionSheetButtonCornerTypeNoCornersRounded:
            break;
            
        case IBActionSheetButtonCornerTypeTopCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
            break;
        }
        case IBActionSheetButtonCornerTypeBottomCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            break;
        }
            
        case IBActionSheetButtonCornerTypeAllCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}
@end



#pragma mark - IBActionSheetTitleView

@implementation IBActionSheetTitleView

- (id)initWithTitle:(NSString *)title font:(UIFont *)font {
    
    self = [self init];
    
    float width;
    float labelBuffer;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        width = CGRectGetWidth([UIScreen mainScreen].bounds);
        labelBuffer = 44;
    } else {
        width = CGRectGetHeight([UIScreen mainScreen].bounds);
        labelBuffer = 24;
    }
    
    self.alpha = .95f;
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width - labelBuffer, 44)];
    self.titleLabel.textColor = [UIColor colorWithWhite:0.564 alpha:1.000];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = title;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    if (font) {
        self.titleLabel.font = font;
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    
    [self.titleLabel sizeToFit];
    
    
    
    if ((CGRectGetHeight(self.titleLabel.frame) + 30) < 44) {
        self.frame = CGRectMake(0, 0, width - 16, 44);
    } else {
        self.frame = CGRectMake(0, 0, width - 16, CGRectGetHeight(self.titleLabel.frame) + 30);
    }
    
    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self addSubview:self.titleLabel];
    self.titleLabel.center = self.center;
    
    return self;
}

- (void)resizeForPortraitOrientation {
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 16, CGRectGetHeight(self.frame));
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 24, 44);
    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
}

- (void)resizeForLandscapeOrientation {
    
    self.frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds) - 16, CGRectGetHeight(self.frame));
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds) - 44, 44);
    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
}

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}

@end
