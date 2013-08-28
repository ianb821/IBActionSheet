//
//  ViewController.m
//  IBActionSheetDemo
//
//  Created by Ian Burns on 8/26/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
//
// Simple sample project that compares the built in UIActionSheet with IBActionSheet
// Note: not really made to support landscape, but you can see the top two options if you
// want to rotate it.

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeButtonsLookSomeWhatLikeButtons];

    self.backgroundColor = [UIColor colorWithRed:0.037 green:0.172 blue:0.261 alpha:1.0f];
    self.textColor = [UIColor colorWithRed:0.236 green:0.764 blue:0.790 alpha:1.000];
    
    self.customIBActionSheetView.alpha = 0.0f;
    self.customIBActionSheetView.layer.cornerRadius = 6.0f;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.822 green:0.960 blue:1.000 alpha:1.000];
    
    self.showCustomIBASButton.layer.cornerRadius = 16.0f;
    self.showCustomIBASButton.layer.borderWidth = 2.0f;
    self.showCustomIBASButton.layer.borderColor = self.showCustomIBASButton.titleLabel.textColor.CGColor;
    
    self.semiTransparentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCustomIBActionPanel)];
    [self.semiTransparentView addGestureRecognizer:cancelTap];
    self.semiTransparentView.backgroundColor = [UIColor blackColor];
    self.semiTransparentView.alpha = 0.0f;
    
    [self.view insertSubview:self.semiTransparentView belowSubview:self.customIBActionSheetView];
    
}

#pragma mark - IBActionSheet Examples

- (IBAction)standardUIActionSheetPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Standard UIActionSheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Emphasis" otherButtonTitles:@"Other", @"Buttons", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)standardIBActionSheetPressed:(id)sender {
    
    IBActionSheet *actionSheet = [[IBActionSheet alloc] initWithTitle:@"Standard IBActionSheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Emphasis" otherButtonTitles:@"Other", @"Buttons", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)showCustomSheetButtonPressed:(id)sender {
    
    NSString *title;
    if (self.titleSegmentedControl.selectedSegmentIndex == 0) {
        title = @"This is a title!";
    }
    
    IBActionSheet *customIBActionSheet = [[IBActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Some" otherButtonTitles:@"Other", @"Buttons", nil];
    
    [customIBActionSheet setButtonBackgroundColor:self.backgroundColor];
    [customIBActionSheet setButtonTextColor:self.textColor];
    
    if (self.buttonEffectSegmentedControl.selectedSegmentIndex == 0) {
        
        customIBActionSheet.buttonResponse = IBActionSheetButtonResponseFadesOnPress;
        
    } else if (self.buttonEffectSegmentedControl.selectedSegmentIndex == 1) {
        
        customIBActionSheet.buttonResponse = IBActionSheetButtonResponseReversesColorsOnPress;
        
    } else if (self.buttonEffectSegmentedControl.selectedSegmentIndex == 2) {
        
        customIBActionSheet.buttonResponse = IBActionSheetButtonResponseShrinksOnPress;
        
    } else {
        
        customIBActionSheet.buttonResponse = IBActionSheetButtonResponseHighlightsOnPress;
        [customIBActionSheet setButtonHighlightTextColor:[UIColor whiteColor]];
        [customIBActionSheet setButtonHighlightBackgroundColor:[UIColor redColor]];
    }
    
    [customIBActionSheet showInView:self.view];
    
}

- (IBAction)showReallyFunkyIBActionSheet:(id)sender {
    
    // To show just how customizable it can be....I'm sorry
    
    IBActionSheet *actionSheet = [[IBActionSheet alloc] initWithTitle:@"I'm deeply sorry\nthat you had" delegate:self cancelButtonTitle:@"Make it Stop" destructiveButtonTitle:nil otherButtonTitles:@"To", @"See", @"This", nil];
    
    actionSheet.buttonResponse = IBActionSheetButtonResponseShrinksOnPress;
    
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:0.258 green:1.000 blue:0.499 alpha:1.000]];
    [actionSheet setButtonTextColor:[UIColor whiteColor]];
    [actionSheet setTitleBackgroundColor:[UIColor orangeColor]];
    [actionSheet setTitleTextColor:[UIColor blackColor]];
    [actionSheet setTitleFont:[UIFont fontWithName:@"Noteworthy-Bold" size:10]];
    
    [actionSheet setButtonTextColor:[UIColor orangeColor] forButtonAtIndex:0];
    [actionSheet setButtonBackgroundColor:[UIColor purpleColor] forButtonAtIndex:0];
    [actionSheet setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:22] forButtonAtIndex:0];
    
    [actionSheet setButtonTextColor:[UIColor lightGrayColor] forButtonAtIndex:1];
    [actionSheet setButtonBackgroundColor:[UIColor yellowColor] forButtonAtIndex:1];
    [actionSheet setFont:[UIFont fontWithName:@"Chalkduster" size:22] forButtonAtIndex:1];
    
    
    [actionSheet setButtonTextColor:[UIColor greenColor] forButtonAtIndex:2];
    [actionSheet setButtonBackgroundColor:[UIColor brownColor] forButtonAtIndex:2];
    [actionSheet setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:22] forButtonAtIndex:3];
    
    [actionSheet showInView:self.view];
}

#pragma mark - IBActionSheet/UIActionSheet Delegate Method

// the delegate method to receive notifications is exactly the same as the one for UIActionSheet
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button at index: %d clicked\nIt's title is '%@'", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}



#pragma mark - All the other junk for the sample project

- (void)dismissCustomIBActionPanel {
    
    [UIView animateWithDuration:0.5f
                     animations:^() {
                         self.semiTransparentView.alpha = 0.0f;
                         self.customIBActionSheetView.alpha = 0.0f;
                         self.standardIBASButton.alpha = 1.0f;
                         self.standardUIASButton.alpha = 1.0f;
                         self.customIBASButton.alpha = 1.0f;
                         self.funkyIBASButton.alpha = 1.0f;
                     }];
}

- (IBAction)itemColorSegmentedControlChanged:(UISegmentedControl *)sender {
    
    const CGFloat *componentColors;
    
    if (self.itemColorSegmentedControl.selectedSegmentIndex == 0) {
        componentColors = CGColorGetComponents(self.textColor.CGColor);
    } else {
        componentColors = CGColorGetComponents(self.backgroundColor.CGColor);
    }
    self.redSlider.value = componentColors[0];
    self.greenSlider.value = componentColors[1];
    self.blueSlider.value = componentColors[2];
    
    [self sliderValueChanged:self.redSlider];
    [self sliderValueChanged:self.greenSlider];
    [self sliderValueChanged:self.blueSlider];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissCustomIBActionPanel];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    if ([sender isEqual:self.redSlider]) {
        
        self.redTextValue.text = [NSString stringWithFormat:@"%.03f", sender.value];
        
    } else if ([sender isEqual:self.greenSlider]) {
        
        self.greenTextValue.text = [NSString stringWithFormat:@"%.03f", sender.value];
        
    } else {
        
        self.blueTextValue.text = [NSString stringWithFormat:@"%.03f", sender.value];
        
    }
    
    if (self.itemColorSegmentedControl.selectedSegmentIndex == 0) {
        
        [self updateTextColor];
        
    } else {
        
        [self updateBackgroundColor];
    }
}

- (void) updateTextColor {
    self.buttonTextColor.textColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.0f];
    self.textColor = self.buttonTextColor.textColor;
}

- (void)updateBackgroundColor {
    self.buttonBackgroundView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.0f];
    self.backgroundColor = self.buttonBackgroundView.backgroundColor;
}


- (IBAction)customIBActionSheetPressed:(id)sender {
    
    [UIView animateWithDuration:0.5f
                     animations:^() {
                         self.semiTransparentView.alpha = 0.4f;
                         self.customIBActionSheetView.alpha = 1.0f;
                         self.standardIBASButton.alpha = 0.0f;
                         self.standardUIASButton.alpha = 0.0f;
                         self.customIBASButton.alpha = 0.0f;
                         self.funkyIBASButton.alpha = 0.0f;
                     }];
}


- (void)makeButtonsLookSomeWhatLikeButtons {
    
    [self addBorderToButton:self.standardUIASButton];
    [self addBorderToButton:self.standardIBASButton];
    [self addBorderToButton:self.customIBASButton];
    [self addBorderToButton:self.funkyIBASButton];
}

- (void)addBorderToButton:(UIButton *)button {
    button.layer.cornerRadius = 16.0f;
    button.layer.borderWidth = 2.0f;
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
}
@end
