//
//  ViewController.h
//  IBActionSheetDemo
//
//  Created by Ian Burns on 8/26/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IBActionSheet.h"

@interface ViewController : UIViewController <UIActionSheetDelegate, IBActionSheetDelegate>

- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)customIBActionSheetPressed:(id)sender;
- (IBAction)sliderValueChanged:(UISlider *)sender;
- (IBAction)standardUIActionSheetPressed:(id)sender;
- (IBAction)standardIBActionSheetPressed:(id)sender;
- (IBAction)showReallyFunkyIBActionSheet:(id)sender;
- (IBAction)showCustomSheetButtonPressed:(id)sender;
- (IBAction)itemColorSegmentedControlChanged:(UISegmentedControl *)sender;


@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *funkyIBASButton;
@property (strong, nonatomic) IBOutlet UIButton *customIBASButton;
@property (strong, nonatomic) IBOutlet UIButton *standardUIASButton;
@property (strong, nonatomic) IBOutlet UIButton *standardIBASButton;
@property (strong, nonatomic) IBOutlet UIButton *showCustomIBASButton;


@property UIView *semiTransparentView;
@property (strong, nonatomic) IBOutlet UIView *buttonBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *customIBActionSheetView;


@property (strong, nonatomic) IBOutlet UISlider *redSlider;
@property (strong, nonatomic) IBOutlet UISlider *blueSlider;
@property (strong, nonatomic) IBOutlet UISlider *greenSlider;


@property (strong, nonatomic) IBOutlet UILabel *redTextValue;
@property (strong, nonatomic) IBOutlet UILabel *blueTextValue;
@property (strong, nonatomic) IBOutlet UILabel *greenTextValue;
@property (strong, nonatomic) IBOutlet UILabel *buttonTextColor;
@property (strong, nonatomic) IBOutlet UILabel *rLabel;
@property (strong, nonatomic) IBOutlet UILabel *gLabel;
@property (strong, nonatomic) IBOutlet UILabel *bLabel;
@property (strong, nonatomic) IBOutlet UILabel *effectLabel;
@property (strong, nonatomic) IBOutlet UILabel *showTitleLabel;


@property (strong, nonatomic) IBOutlet UISegmentedControl *titleSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *itemColorSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *buttonEffectSegmentedControl;



@property UIColor *textColor, *backgroundColor;




@end
